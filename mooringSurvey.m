function mooringSurvey(varargin)

% mooringSurvey triangulates the location of an acoustic release from
% coordinate and acoustic transmitter information. It can use a file as the
% input or use the information directly as function arguments. Software 
% will generate the best solution as a plotted jpeg and as a textfile in 
% the current directory. The software is assumed to be used at sea, so 
% input and output are provided in standard degrees and minute format for 
% latitude and longitude. 

% All editable parameters are in the msparam.m file. Update the file for 
% each survey session.

% This software serves as a slimmed down and cleaned up version of "Art's 
% Acoustic Survey Software", originally written by Arthur Newhall. Unlike
% the original software, this updated software does not rely on a MATLAB 
% GUI, gives a plotted jpeg and textfile as the output, and has a more 
% flexible data input framework. It also uses a new algorithm to solve for
% the best acoustic release position that should be less error prone to bad
% data. It borrows one function originally written by Art, as I really 
% couldn't improve it. I kept the input file format the same as "Art's 
% Acoustic Survey Software" so it should be backwards compatible.

% ~~~File Input Mode~~~
% Call the function with the filename as the argument.
% 
% Example Code: mooringSurvey('fooBar.txt');

% The input file row format should be:
% LatDeg1 LatMin1 LonDeg1 LonMin1 travelTimeSeconds1
% LatDeg2 LatMin2 LonDeg2 LonMin2 travelTimeSeconds2
% etc... 

% This mode uses the readtable() function, so any spreadsheet or textfile
% format "should" work, as well as any standard delimiter. The file must be
% in the directory or on the MATLAB PATH.

% ~~~Vector Mode~~~
% Call the function with the data vectors as the arguments. Expected vector
% dimensions are [N,1], where each N is data corresponding to a surveying
% session.
% 
% Example Code: mooringSurvey(LatDeg,LatMin,LonDeg,LonMin,TravelTimeSeconds)

% ~~~Other Info~~~~
% Best results require at least 3 positions, but the code is written to 
% accept any amount of position data. 

% This packages requires the sw_dist.m function found in the sea water
% package. In the off chance that this survey software is downloaded on a 
% ship that doesn't have the seawater package installed, I have this 
% function available in the directory. 

% Version 1.0: Initial release.

% Written on: 20250220
% Last Edit: 20250301
% Michael Cappola (mcappola@udel.edu)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if isempty(varargin)
    disp(' ')
    disp('Version: 1.0') 
    disp(' ')
    return
end

% Set flag to 0. This is set to 1 if all data input conditions are met.
proceed = 0;

%% File Input Mode

% Check if the input is a char array. Then we assume it's a file and search
% for it. This means that the file must be in the directory, or in the
% matlab path.
if ischar(varargin{1})
    filename = varargin{1};
    
    % Try to extract the data. If failure, return to console.
    try
        data = readtable(filename);
    catch
        disp(['Unable to find ' varargin{1}]);
        return
    end
    
    % if file opening is successful, we extract the data.
    latDeg = data{:,1};
    latMin = data{:,2};
    lonDeg = data{:,3};
    lonMin = data{:,4};
    delays = data{:,5}; 
    
    % Quick checksum. All arrays should be the same size.
    c1 = length(latDeg);
    c2 = length(latMin);
    c3 = length(lonDeg);
    c4 = length(lonMin);
    c5 = length(delays);
    
    if sum([c1,c2,c3,c4,c5]) == c1*5
        proceed = 1;
        if c1<3
            disp('WARNING: Recommend using at least 3 survey positions for good results.')
        end
    else
        disp('FILE MODE: Check Sum Failed!')
    end
end

%% Vector Mode

if nargin==5 
    latDeg = varargin{1};
    latMin = varargin{2};
    lonDeg = varargin{3};
    lonMin = varargin{4};
    delays = varargin{5};
    
    % Quick check sum. All arrays should be the same size.
    c1 = length(latDeg);
    c2 = length(latMin);
    c3 = length(lonDeg);
    c4 = length(lonMin);
    c5 = length(delays);
    
    if sum([c1,c2,c3,c4,c5]) == c1*5
        proceed = 1;
        if c1<3
            disp('WARNING: Recommend using at least 3 survey positions for good results.')
        end
    else
        disp('DATA MODE: Check Sum Failed!')
    end
end

% Check if the program has the data required to proceed. If not, exit.
if proceed~=1
    disp('Check your data! Exiting Program.')
    return
end

msparam

% Convery input to decimal vectors.
latS = deg2dec(latDeg,latMin,equator);
lonS = deg2dec(lonDeg,lonMin,meridian);
delS = delays;

% Initialize the storage array.
mat = zeros((initDist*2)+1,(initDist*2)+1);

for ii = 1:length(latS)
    % Calculate range and shift values.
    r = horzRange(delS(ii));
    [xc(ii),yc(ii)] = calcShift(latS(1),lonS(1),latS(ii),lonS(ii));    
    
    % Add the circle data to the storage array.
    mat = addCircle(mat,xc(ii),yc(ii),r);
    
    % Calculate plot data for the circle.
    theta = linspace(0,2*pi);
    x1(ii,:) = r*cos(theta) + xc(ii);
    y1(ii,:) = r*sin(theta) + yc(ii);     
end

% Get the X and Y position from the storage matrix.
mat(mat==0) = nan;
[YY,XX] = find(mat==min(mat,[],'all'));

% Calculate the position referenced to the origin.
xPos = XX-initDist;
yPos = YY-initDist;

% Get the new lat lons
[nLat,nLon] = getLatLon(latS(1),lonS(1),xPos,yPos);

% Convert back to degrees
[nLatDeg,nLatMin] = dec2deg(nLat);
[nLonDeg,nLonMin] = dec2deg(nLon);

% Display output
disp(' ')
disp('**Release Coordinates**')
disp(['Latitude:  ' num2str(nLatDeg) ' ' num2str(nLatMin) ' ' equator])
disp(['Longitude: ' num2str(nLonDeg) ' ' num2str(nLonMin) ' ' meridian])
disp(' ')

%% Plot the wave fronts
figure('Position',[390 178 803 720])
hold on
for ii = 1:length(latS)
    plot(x1(ii,:),y1(ii,:),'k-','LineWidth',1.5)
    plot(xc(ii),yc(ii),'k+','MarkerSize',15,'LineWidth',2)
end
plot(XX-initDist,YY-initDist,'ro','MarkerSize',10,'LineWidth',2)
xline(XX-initDist,'r--','Label',[num2str(XX-initDist) ' m'],'LabelOrientation','horizontal','LineWidth',1.5,'FontWeight','bold')
yline(YY-initDist,'r--','Label',[num2str(YY-initDist) ' m'],'LabelOrientation','horizontal','LineWidth',1.5,'FontWeight','bold')
xlim([-initDist initDist])
ylim([-initDist initDist])
xticks([-initDist:(initDist*2)/10:initDist])
yticks([-initDist:(initDist*2)/10:initDist])
xlabel('Distance from Initial Position [m]','FontSize',16)
ylabel('Distance from Initial Position [m]','FontSize',16)
title('Acoustic Release Coordinates','FontWeight','bold','FontSize',20)
subtitle(['Latitude: ' num2str(nLatDeg) '\circ ' num2str(nLatMin) ' ' equator '     ' ...
    'Longitude: ' num2str(nLonDeg) '\circ ' num2str(nLonMin) ' ' meridian],...
    'FontSize',16,'FontWeight','bold')
axis square
grid on
hold off

% Save the output
now = datetime;
gdate = datevec(now);
YY = num2str(gdate(1));
MM = num2str(gdate(2),'%.2d');
DD = num2str(gdate(3),'%.2d');
HH = num2str(gdate(4),'%.2d');
mm = num2str(gdate(5),'%.2d');
ss = num2str(round(gdate(6)),'%.2d');

% Save the plot
exportgraphics(gca,['mooringSurveyResults_' YY MM DD '_' HH mm ss '.jpg']);

% Save the output to a text file too.
filename = ['mooringSurveyResults_' YY MM DD '_' HH mm ss '.txt'];
fid = fopen(filename,'w');
fprintf(fid,'**Release Coordinates**\n');
fprintf(fid,['Latitude:  ' num2str(nLatDeg) ' ' num2str(nLatMin) ' ' equator '\n']);
fprintf(fid,['Longitude: ' num2str(nLonDeg) ' ' num2str(nLonMin) ' ' meridian '\n']);
fclose(fid);

