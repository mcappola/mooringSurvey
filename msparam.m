
% User parameters for the mooringSurvey software.

equator = 'S';          % Which side of the equator? 
                        % 'N' or 'S'
                                
meridian = 'W';         % Which side of the meridian?
                        % 'E' or 'W'

soundSpeed = 1500;      % Sound speed in m/s.
releaseDepth = 497;     % Estimated depth of the release in m
transducerDepth = 10;   % Estimated depth of transducer in m

initDist = 1000;        % Initial distance for plots in meters, 1000 would 
                        % cover an area 2000m by 2000m. 
                        
precision = 10;         % Solution precision in meters. Choosing a value 
                        % greater than 1 saves compute time on large arrays
                        % required for a deep acoustic release.


