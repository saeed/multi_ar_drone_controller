clear all;
close all;
AOV_degree = 90;
%AOV = (AOV_degree * 2*pi)/360; %60 degrees camera Angle of View
altitude = 1;
R_min = altitude*10;%0.0001;%0.01; % 0.5m
R_max = 300;%25;%10;%30;%100; % 3m

% Dimensions of the area
Dim1_min = 0;%2;
Dim2_min = 0;%2;
Dim1_max = 700;%700;%50;%60;%200; %maximum in x-axis (m)
Dim2_max = 500%500;%50;%60;%200; %maximum in y-axis (m)
Margin = 10;%10;




AOV = (AOV_degree * 2*pi)/360; %60 degrees camera Angle of View

TargetCount = 1 ;%20;%100;
MAX_CLUSTER = round(TargetCount/2);
ClusterNum =  1;
% fraction of targets below which we allow uncovered targets
uncovered_fraction_criterion = 0.1;
max_iteration = 50;

data = GenerateData(Dim1_max, Dim2_max, TargetCount, 1);
data(1,:) = data(1,:) + (0.01).*rand(1, TargetCount);% to avoid bad fitting
output = FinalCoverageMainEnhancedExperiment(data, AOV_degree, R_min, R_max, Dim1_min, Dim2_min, Dim1_max, Dim2_max, max_iteration, uncovered_fraction_criterion, ClusterNum, MAX_CLUSTER, TargetCount,altitude,Margin);
output