# INIT_CALCULATOR_YEAR

This is a tool to estimate the vertical temperature profile in the soil from annual oscillations for the particular day of the year

## Method and explanations:

Vertical temperature profile in the soil can be estimated from annual oscillations for any day of the year, for the depth lower than the depth where duirnal oscillations can be neglected (ca. 0.5m). For that, analytical solution of the heat diffusion equation with no initial condition (-oo < t), periodical upper boundary condition (T = A * cos (2 * Pi * t / Period)) and no lower boundary condition (0 < z <oo) can be used. 

Ref.: Tikhonov A. and A. Samarski: Mathematical physics. 1951 (ed. 1977), p.247 

### Input data: 
Amplitude of annual oscillations (C) at 2 arbitrary depth levels estimated from observations (time series of more than one year length)
### Output:
Temperature (C) profile e.g. on the verical grid, e.g. of SURFEX (SURFEX docum., 2018, p. 124) on levels lower than the lowest level of observations and lower than the level without duirnal oscillations (ca. 0.5m)
  
## Description:

`Env_system` - system configuration file  
`Init_Calculator_Year` - script to run the tool  
`src`        - directory with the code  

## Usage:

0. Clone the project:

   `git clone git@github.com:kourzeneva/INIT_CALCULATOR_YEAR.git`

   ... or download the zip file and unzip it.
   
1. Create the working directory with the name `wrk`. All code will be copied there, data will be linked there and the tool will run there. Results will be also located there. From `INIT_CALCULATOR_YEAR`:  

   `mkdir wrk`

   This directory should be created only once. If exists, it will be refreshed automatically.

2. Edit the file `Env_system`. Variables to be adjusted to your setup are:
   
   `Dir` - enter the directory path here

3. Edit the `src/Init_Calculator_Year.F90` file to specify the parameters for your particular site.  Parameters to be specified are:

   `Z1` - upper level with obs. data, m  
   `Z2` - lower level with obs data, m  
   `A1` - annual oscillations amplitude at level Z1, C  
   `A2` - annual oscillations amplitude at level Z2, C  
   `TMEAN` - mean annual temperature, C  
   `JD` - Julian day number, for which you would like to get a profile  
   `HEMISPHERE` - 1 for Northern hemisphere, 0 for Sourthern hemisphere

     Also, other parameters such as vertical grid can be specified if needed.  
   
     Important notes:  
     - don't be too precise to specify the annual amplitudes. Just take them approximately (visually), from the graphs. The accuracy will be enough.
     - when estimating annual amplitude from the graphs, remember to "filter out" duirnal cycle. Consider mean day temperatures, not max day temperatures during summer and min night temperatures during winter.
     - amplitude here means ((maximum in summer) - (minimum in winter))/2. Mean yearly temperature can be estimated as ((maximum in summer) + (minimum in winter))/2

     Example in the code is given for the Cabauw site observations, very approximately.

5. Run the `Init_Calculator_Year` script. From From `INIT_CALCULATOR_YEAR`:

   `./Init_Calculator_Year`

   Result will be on the screen: level number, level depth, temperature. Additionally, the annual temperature amplitude at the surface and the temperature conductivity are prined, for information.
    
   







 
