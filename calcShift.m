function [xShift,yShift] = calcShift(latA,lonA,latB,lonB)

% Calculates the number of meters in the x and y directions between two
% latlon positions for the mooringSurvey software. This function uses the
% seawater package "sw_dist()" function, so the seawater package must be
% installed and on the MATLAB PATH.

% Written on: 20250220
% Last Edit: 20250301
% Michael Cappola (mcappola@udel.edu)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Calculate the distance between points
[dist,angl] = sw_dist([latA;latB],[lonA;lonB],'km');

% Convert distance into meters
dist = dist*1000;

% Calculate the x and y shift values for the next circle
xShift = dist*cos(deg2rad(angl));
yShift = dist*sin(deg2rad(angl));