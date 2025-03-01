function out = deg2dec(degree,minute,hemi)

% Converts lat lon degree minute format to decimal for the mooringSurvey 
% software. Reapplies the correct sign based on the user input parameters. 

% Written on: 20250220
% Last Edit: 20250301
% Michael Cappola (mcappola@udel.edu)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Convert minute component to decimal
mindec = (minute/60);

% Combine with the degree. Sign must be accounted for.
if hemi=='N' || hemi=='E'
    out = degree + mindec;
end

if hemi=='S' || hemi=='W'
    out = (degree + mindec)*-1;
end

