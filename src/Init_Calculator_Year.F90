PROGRAM Init_Calculator_Year
  ! Estimating of the vertical temperature profile in the soil
  ! from annual oscillations
  ! for the particular day of the year, for the depth
  ! lower than the depth where duirnal oscillations can be neglected (ca. 0.5m) 
  ! Input data: amplitude of annual oscillations at 2 arbitrary depth levels
  ! estimated from observations (time series of more than one year length).
  ! Output: temperature (C) profile on the verical grid of SURFEX
  ! (SURFEX docum., 2018, p. 124) on levels lower than the lowest level of observations
  ! and lower than the level without duirnal oscillations (ca. 0.5m)
  ! Method: analytical solution of the heat diffusion equation,
  ! with no initial condition (-oo < t),
  ! periodical upper boundary condition (T=A*cos(2*Pi*t/Period))
  ! and no lower boundary condition (0 < z <oo).
  ! Ref.: Tikhonov A. and A. Samarski: Mathematical physics. 1951 (ed. 1977), p.247 
  ! Author: Ekaterina Kurzeneva
  ! FMI, 02.2026
  IMPLICIT NONE

  ! PARAMETERS ==================================================================

  ! Parameters of the particular site ------------------------------------------
  ! (here. the Cabauw site)
  REAL, PARAMETER :: &
       Z1=0.0, & ! Two levels in the soil with the observations data, m
       Z2=0.5    ! (Z2 is deeper than Z1!)
  REAL, PARAMETER :: &
       A1=12., & ! Amplitudes of the annual temperature oscillations in the soil 
       A2=6.5    ! at these two levels, (C)
                 ! Note: here, the amplitude is (max-min)/2.
  REAL, PARAMETER :: &
       TMEAN=13.5  ! Mean annual temperature, (C)
                   ! Note: mean=(max+min)/2.
  INTEGER, PARAMETER :: &
       JD=183 ! Julian day, for which to calculate the profile
  INTEGER, PARAMETER :: &
       HEMISPHERE = 1   ! Which hemisphere? 1 for Northern, 0 for Southern

  ! Parameters of the grid -------------------------------------------------------
  ! (here, SURFEX grid)
  INTEGER, PARAMETER :: &
       NLEV_H=15   ! Number of half-levels of vertical grid
  REAL, DIMENSION(NLEV_H), PARAMETER :: &
       DEPTH_H= &              ! Vertical grid, half-levels (m)
       (/0.0,0.01,0.04,0.10,0.20,0.40,0.60,0.80,1.00,1.50,2.00,3.00,5.00,8.00,12.00/)

  ! Additional parameters ----------------------------------------------------------
  ! (could be modified slightly)
  REAL, PARAMETER :: &
       DepthNoDA = 0.5 ! The depth (m) where no duirnal oscillations are expected
  REAL, PARAMETER :: &
       TC_MIN = 1.E-9, & ! Minimum possible temperature conductivity, m**2/s
       TC_MAX = 1.E-5    ! Maximum possible temperature conductivity, m**2/s
  
  ! Physical constants -------------------------------------------------------------
  INTEGER, PARAMETER :: &
       PERIOD  = 365, &       ! Period of oscillations on the upper boundary (d)
       LENGTH_OF_DAY = 86400  ! Length of the day, s

  ! LOCAL VARIABLES ==================================================================
  
  REAL :: &
       A0, & ! Amplitude on the upper boundary, (C)
       TC    ! Temperature conductivity, m**2/s

  REAL, DIMENSION(NLEV_H) :: & 
       TEMP_H                  ! Temperature values on vertical grid, (C)

  REAL :: ZW, ZWW, ZT, ZTP     ! working variables
  REAL, DIMENSION(NLEV_H) :: &
       ZWWW_H
  
  REAL :: Pi ! Pi-value
  INTEGER :: il ! loop indexes

  ! ============================================================================

  Pi=ACOS(-1.0)

  ! Estimate annual amplitude at the surface and temperature condactivity
  WRITE(*,*) 
  A0=EXP((Z2*LOG(A1)-Z1*LOG(A2))/(Z2-Z1))
  WRITE(*,'(A43,F6.1,A2)') 'Annual cycle amplitude at the surface is: ', A0, ' C'
  TC=Pi/PERIOD/LENGTH_OF_DAY*((Z2-Z1)/LOG(A1/A2))**2
  IF(TC.LT.TC_MIN) THEN
     WRITE(*,'(A49,E8.1,A7)') 'Temperature conductivity is suspiciously small: ', TC , ' m**2/s'
     WRITE(*,'(A25)') 'Please check the data!!!'
     STOP
  END IF
  IF(TC.GT.TC_MAX) THEN
     WRITE(*,'(A49,E8.1,A7)') 'Temperature conductivity is suspiciously large: ', TC , ' m**2/s'
     WRITE(*,'(A25)') 'Please check the data!!!'
     STOP
  END IF
  WRITE(*,'(A30,E8.1,A7)') 'Temperature conductivity is: ', TC, ' m**2/s'
  WRITE(*,*) 

  ! Calculate the equation parameters
  ZW=2.*Pi/REAL(PERIOD*LENGTH_OF_DAY)
  ZWW=SQRT(ZW/2./TC)
  DO il=1,NLEV_H
     ZWWW_H(il)=ZWW*DEPTH_H(il)
  END DO
  ZT=REAL(JD*LENGTH_OF_DAY)

  ! Calculate and print temperatures
  DO il=1,NLEV_H
     IF(DEPTH_H(il).LT.MAX(DepthNoDA,Z2)) THEN
        WRITE(*,'(I4,F6.2,A4)') il, DEPTH_H(il), ' - '
     ELSE        
        TEMP_H(il)=TMEAN+A0*EXP(-1.*ZWWW_H(il))*COS(ZWWW_H(il)-ZW*ZT+Pi*HEMISPHERE)
        WRITE(*,'(I4,F6.2,F6.1)') il, DEPTH_H(il), TEMP_H(il)
     END IF
   END DO 
  
END PROGRAM Init_Calculator_Year
