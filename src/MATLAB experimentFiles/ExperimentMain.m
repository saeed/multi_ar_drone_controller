clear all;
close all;

AOV_degree = 90;
%AOV = (AOV_degree * 2*pi)/360; %60 degrees camera Angle of View
R_min = 0;%0.01; % 0.5m
R_max = 1000;%30;%100; % 3m

% Dimensions of the area
Dim1_min = 2;
Dim2_min = 2;
Dim1_max = 640;%60;%200; %maximum in x-axis (m)
Dim2_max = 480;%60;%200; %maximum in y-axis (m)

TargetCount = 3;%100;
% fraction of targets below which we allow uncovered targets
UNCOVERED_FRACTION_CRITERION = 0.1; 
MAX_ITERATION = 3;

ClusterNum = 1; %TargetCount / 10;%(Dim1_max/R_max)*(Dim2_max/R_max); % initially
MAX_CLUSTER = TargetCount + 1; %round(TargetCount/2);

uncovered_algo1_vector = zeros(1,MAX_CLUSTER-ClusterNum);

seed = 3;
% generate location of targets
data = GenerateData(Dim1_max, Dim2_max, TargetCount,seed); 
%data = [100, 100, 300, 300; 200, 250, 200, 250; 0, 0, 0, 0];
%data =[350, 250, 300, 250; 300, 300, 200, 250; 0, 0, 0 , 0];

data = [50,100,200;250,250,250;0,0,0];

data = [250,300,200;100,200,250;0,0,0];
%data = [150,200,200;150,150,250;0,0,0];
mydata=[150,200,200;150,150,250];
uncoveredNum_algo1 = TargetCount;
cluster_count_algo1 = ClusterNum;

complexity_algo1 = 0;
angle_coeff = 50;
iter = 0;
while ((uncoveredNum_algo1 > UNCOVERED_FRACTION_CRITERION * TargetCount)  && (cluster_count_algo1 < MAX_CLUSTER) && (iter < 100))
   Result = ClusteredCoverageExperimentRevised(data, AOV_degree, R_min, R_max, Dim1_min, Dim2_min, Dim1_max, Dim2_max, MAX_ITERATION, UNCOVERED_FRACTION_CRITERION ,cluster_count_algo1, TargetCount);
    %Result = ConvertedFeaturesAlgorithmWorkableFuncExp(data, AOV_degree, R_min, R_max, Dim1_min, Dim1_max, Dim2_min, Dim2_max, MAX_ITERATION, UNCOVERED_FRACTION_CRITERION, cluster_count_algo1, TargetCount,angle_coeff);
    Result
    uncoveredNum_algo1 = Result(1,5);
    uncovered_algo1_vector(cluster_count_algo1) = uncoveredNum_algo1;
    UsedClustersNum = size(Result , 1);
    Cams = Result(:,1:3)
    CamSlopes = Result(:,4);
    cluster_count_algo1 = cluster_count_algo1 + 1;
    iter = iter + 1;
end
uncoveredNum_algo1 = Result(1,5)

% figure;
% x = ClusterNum : cluster_count_algo1;
% plot(x,uncovered_algo1_vector(ClusterNum:cluster_count_algo1));
% xlabel('#cameras');
% ylabel('#uncovered targets');