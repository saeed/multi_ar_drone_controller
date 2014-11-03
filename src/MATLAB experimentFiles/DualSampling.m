AOV_degree = 45;
%AOV = (AOV_degree * 2*pi)/360; %60 degrees camera Angle of View
R_min = 0.0001;%0.01; % 0.5m
R_max = 10;%10;%30;%100; % 3m

% Dimensions of the area
Dim1_min = 0;%2;
Dim2_min = 0;%2;
Dim1_max = 20;%60;%200; %maximum in x-axis (m)
Dim2_max = 20;%60;%200; %maximum in y-axis (m)

TargetCount = 40;%20;%100;
% fraction of targets below which we allow uncovered targets
UNCOVERED_FRACTION_CRITERION = 0.1; 
MAX_ITERATION = 50;