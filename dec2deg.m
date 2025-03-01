function [degree,minute] = dec2deg(decimal)

% Converts lat lon decimal format to degrees and minutes for the
% mooringSurvey software. 

% Written on: 20250220
% Last Edit: 20250301
% Michael Cappola (mcappola@udel.edu)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% We don't want the sign for the output since we already know the correct
% hemisphere from the user parameters.
decimal = abs(decimal);

% Get the degree.
degree = floor(decimal);

% Calculate the minute from the remainder.
minute = (decimal - degree)*60;

