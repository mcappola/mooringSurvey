function out = addCircle(mat,xc,yc,r)

% The main algorithm to find the best acoustic release position for the
% mooringSurvey software. This calculates the absolute distance from the 
% survey point origin, minus the acoustic release horizontal range, and
% stores the value in a storage array. The effect of this is to create a
% field of values where the horizontal range ring has the lowest values in
% the array. This storage array is passed back into the function on each
% function call and we add the value already present for that position.

% Taking the minimum value of this array, once all positions are added,
% should be the best location for the acoustic release. In essence, this is
% where the most horizontal range rings intersect, but since we are taking
% the minimum of a field instead of solving for an exact solution, this
% algorithm is more robust to bad data, where an exact solution may be
% impossible. This algorithm working is contingent on the storage matrix 
% being large enough to contain all of the survey points and their rings, 
% which is controlled in the user parameters (msparam.m).

% To save compute time on large arrays, the user can control the precision
% in the user parameters (msparam.m). Default is 10, which is a good
% balance of speed and precision.

% Written on: 20250220
% Last Edit: 20250301
% Michael Cappola (mcappola@udel.edu)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Call user parameters
msparam

[aa,bb] = size(mat);

% Search through the matrix and find solutions that are within the range of
% the center point.

% We only do this every 10 meters to save compute. This limits the
% accuracy, but 10 meters is irrelevant fot this problem. 

xPoints = -initDist:initDist;
yPoints = -initDist:initDist;
for ii = 2:precision:aa-1                
    for jj = 2:precision:bb-1
        % Calculate the distance of the point
        xPointi = xPoints(ii);
        yPointi = yPoints(jj);
        AA = (xPointi-xc)^2;
        BB = (yPointi-yc)^2;
        d = sqrt(AA+BB);

        % Get the position value if it already exists.
        val = mat(initDist + yPointi,initDist + xPointi);
        
        % Add the new position value to the storage array.
        mat(initDist + yPointi,initDist + xPointi) = val + abs(d - r);
    end
end

out = mat;
        
