# mooringSurvey

The main function is mooringSurvey.m. All other functions and scripts are called by mooringSurvey.

The mooringSurvey package triangulates the location of an acoustic release from coordinate and acoustic transmitter information. It can use a file as the input or use the information directly as function arguments. Software will generate the best solution as a plotted jpeg and as a textfile in the current directory. The software is assumed to be used at sea, so input and output are provided in standard degrees and minute format for latitude and longitude. 

All editable parameters are in the msparam.m file. Update the file for each survey session.

This software serves as a slimmed down and cleaned up version of "Art's Acoustic Survey Software", originally written by Arthur Newhall. Unlikethe original software, this updated software does not rely on a MATLAB GUI, gives a plotted jpeg and textfile as the output, and has a more flexible data input framework. It also uses a new algorithm to solve for the best acoustic release position that should be less error prone to bad data. It borrows one function originally written by Art, as I really couldn't improve it. I kept the input file format the same as "Art's Acoustic Survey Software" so it should be backwards compatible.

#### File Input Mode
Call the function with the filename as the argument.
 
Example Code: mooringSurvey('fooBar.txt');

The input file row format should be:
LatDeg1 LatMin1 LonDeg1 LonMin1 travelTimeSeconds1
LatDeg2 LatMin2 LonDeg2 LonMin2 travelTimeSeconds2
etc... 

This mode uses the readtable() function, so any spreadsheet or textfile format "should" work, as well as any standard delimiter. The file must be in the directory or on the MATLAB PATH.

#### Vector Mode
Call the function with the data vectors as the arguments. Expected vector dimensions are [N,1], where each N is data corresponding to a surveying session.

Example Code: mooringSurvey(LatDeg,LatMin,LonDeg,LonMin,TravelTimeSeconds)

#### Other Info
Best results require at least 3 positions, but the code is written to accept any amount of position data. 

This packages requires the sw_dist.m function found in the seawater package. In the off chance that this survey software is downloaded on a ship that doesn't have the seawater package installed, I have this function included in the directory. 

- Version 1.0: Initial release.

Michael Cappola (mcappola@udel.edu)
