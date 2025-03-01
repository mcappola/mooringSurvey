function [nLat,nLon] = getLatLon(latA,lonA,xs,ys)

% Calulate new latitude and longitude values based on x and y distance in 
% meters from the original latitude and longitude.

% This is repurposed code orignially written for another survey program. I
% gave it a new name and updated the variable names, but the function
% mechanics are unchanged. Oringial code was written by:

%           Art Newhall Survey Software
%			WHOI  10-30-00

% Written on: 20250220
% Last Edit: 20250301
% Michael Cappola (mcappola@udel.edu)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

d2r = pi/180;

nLat = ys./111044.2608 + latA;
nLon = xs./(cos(latA*d2r)*111044.2608) + lonA;
