function out = horzRange(timeDelay)

% Calculates the horizontal distance (parallel to the sea surface) from the
% ship to the acoustic release based on the time delay information for the
% mooringSurvey software.

% Written on: 20250220
% Last Edit: 20250301
% Michael Cappola (mcappola@udel.edu)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Call user parameters
msparam

% Calculate the slant range
slantRange = timeDelay * soundSpeed;

% Calculate theta
theta = asin((releaseDepth-transducerDepth)/slantRange);

% Calculate horizontal distance
out = slantRange*cos(theta);
