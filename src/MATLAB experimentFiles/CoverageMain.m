% change variables and run different algorithms 

clear all;
close all;

AOV_degree = 90;
%AOV = (AOV_degree * 2*pi)/360; %60 degrees camera Angle of View
R_min = 0.0001;%0.01; % 0.5m
R_max = 25;%10;%30;%100; % 3m

% Dimensions of the area
Dim1_min = 0;%2;
Dim2_min = 0;%2;
Dim1_max = 50;%60;%200; %maximum in x-axis (m)
Dim2_max = 50;%60;%200; %maximum in y-axis (m)

TargetCount = 10;%20;%100;
% fraction of targets below which we allow uncovered targets
UNCOVERED_FRACTION_CRITERION = 0.1; 
MAX_ITERATION = 50;

ClusterNum = round(TargetCount / 20 ); round(TargetCount / 10 );%(Dim1_max/R_max)*(Dim2_max/R_max); % initially
MAX_CLUSTER = round(TargetCount/2);

ScenNum = 1;


cluster_count_avg_algo1 = 0;
cluster_count_std_algo1 = 0;
uncovered_avg_algo1 = 0;
uncovered_algo1_vector = zeros(1,MAX_CLUSTER);
uncovered_algo1_vector(1:ClusterNum-1) = TargetCount;
complexity_avg_algo1 = 0;

for s = 1 : ScenNum
    seed = s;
    data = GenerateData(Dim1_max, Dim2_max, TargetCount, seed);
    uncoveredNum_algo1 = TargetCount;
    cluster_count_algo1 = 1;% ClusterNum;
    
    complexity_algo1 = 0;
    tstart = tic;
    while ((uncoveredNum_algo1 > floor(UNCOVERED_FRACTION_CRITERION * TargetCount))  & (cluster_count_algo1 < MAX_CLUSTER))
        Result = ClusteredCoverageFunc(data, AOV_degree, R_min, R_max, Dim1_min, Dim2_min, Dim1_max, Dim2_max, MAX_ITERATION, UNCOVERED_FRACTION_CRITERION ,cluster_count_algo1, TargetCount);
         %uncoveredNum_algo1 = Result( 1 , 1 );
        uncoveredNum_algo1 = Result( 1 , 5 ); 
        uncovered_algo1_vector(cluster_count_algo1) = uncoveredNum_algo1;
        %complexity_algo1 = complexity_algo1 + Result( 1 , 2 );
        complexity_algo1 = complexity_algo1 + Result( 1 , 6 );
        actual_cam_num(cluster_count_algo1) = size(Result,1);
        cluster_count_algo1 = cluster_count_algo1 + 1;
    end
    algo1elapse = toc(tstart);
    uncoveredNum_algo1
    uncovered_avg_algo1 = uncovered_avg_algo1 + uncoveredNum_algo1;
    cluster_count_algo1 = cluster_count_algo1 - 1;
    cluster_count_avg_algo1 = cluster_count_avg_algo1 + cluster_count_algo1;
    complexity_avg_algo1 = complexity_avg_algo1 + complexity_algo1;
end

uncovered_avg_algo1 = uncovered_avg_algo1 / ScenNum
cluster_count_avg_algo1 = cluster_count_avg_algo1 / ScenNum
complexity_avg_algo1 = complexity_avg_algo1 / ScenNum
figure;
x = ClusterNum : cluster_count_algo1;
true_x = actual_cam_num(x)
plot(x,uncovered_algo1_vector(ClusterNum:cluster_count_algo1));
xlabel('#cameras');
ylabel('#uncovered targets');
title('Algorithm 1 ');

%cluster_count_algo2 = ClusterNum;
%angel_coeff = 1000;% 50;
%step = 2;
%angel_coeff_max = 500;
%uncovered_vs_coeff2 = zeros(1, angel_coeff_max/step + 1);
%k = 1;
%  for angel_coeff = 0 : step : angel_coeff_max
%     uncoveredNum_algo2 = ConvertedFeaturesAlgorithmWorkableFunc(seed,AOV_degree, R_min, R_max, Dim1_max, Dim2_max, MAX_ITERATION, UNCOVERED_FRACTION_CRITERION, cluster_count_algo2, TargetCount,angel_coeff);
%     uncovered_vs_coeff2( k ) = uncoveredNum_algo2;
%     k = k + 1;
% end

%uncoveredNum_algo2
% figure;
% plot(uncovered_vs_coeff2(2:(angel_coeff_max/step) + 1));
% xlabel('angel coefficient');
% ylabel('# of uncovered targets');

angel_coeff = 50;
cluster_count_algo2 = 1;%ClusterNum;
uncoveredNum_algo2 = TargetCount;
loop_count = 1;
Algo2complexity = 0;
tstart2 = tic;
 while ((uncoveredNum_algo2 > UNCOVERED_FRACTION_CRITERION * TargetCount)  & (cluster_count_algo2 < MAX_CLUSTER))
     ResultAlgo2 = ConvertedFeaturesAlgorithmWorkableFunc(data, AOV_degree, R_min, R_max, Dim1_min, Dim1_max, Dim2_min, Dim2_max, MAX_ITERATION, UNCOVERED_FRACTION_CRITERION, cluster_count_algo2, TargetCount,angel_coeff);
     uncoveredNum_algo2 = ResultAlgo2(1,1);
     Algo2complexity = Algo2complexity + ResultAlgo2(1,2);
     UncoveredVsCamNum2(loop_count) = uncoveredNum_algo2;
     cluster_count_algo2 = cluster_count_algo2 + 1
     loop_count = loop_count + 1;
 end
 algo2elapse = toc(tstart2)
 uncoveredNum_algo2
 CamCountAlgo2 = cluster_count_algo2 - 1
 figure;
 plot(UncoveredVsCamNum2);
 xlabel('cluster size');
 ylabel('uncovered targets');
 title('Algorithm 2 ');
 Algo2complexity


 cluster_count_algo3 = 1;%ClusterNum;
 blend = 2;
 multi_class_probability = 0.75;% if highest class probability is bigger than this value, target belongs to one class only
% step = 10;
% angel_coeff_max = 2000;
% uncovered_vs_coeff3 = zeros(1, angel_coeff_max/step + 1);
% k = 1;
% for angel_coeff = 0 : step : angel_coeff_max
%     uncoveredNum_algo3 = FuzzyClusteringFunc(seed,AOV_degree, R_min, R_max, Dim1_max, Dim2_max, MAX_ITERATION, UNCOVERED_FRACTION_CRITERION, cluster_count_algo3, TargetCount, angel_coeff, blend, multi_class_probability);
%     uncovered_vs_coeff3( k ) = uncoveredNum_algo3;
%     k = k + 1;
% end


%  angel_coeff2 = 50;
%  uncoveredNum_algo3 = TargetCount;
%  cluster_count_algo3 = 1; %ClusterNum;
%  loop_count = 1;
%  while ((uncoveredNum_algo3 > UNCOVERED_FRACTION_CRITERION * TargetCount)  & (cluster_count_algo3 < MAX_CLUSTER))
%      %uncoveredNum_algo3 = ConvertedFeaturesAlgorithmWorkableFunc(seed,AOV_degree, R_min, R_max, Dim1_max, Dim2_max, MAX_ITERATION, UNCOVERED_FRACTION_CRITERION, cluster_count_algo3, TargetCount,angel_coeff);
%      uncoveredNum_algo3 = FuzzyClusteringFunc_new(seed,AOV_degree, R_min, R_max, Dim1_max, Dim2_max, MAX_ITERATION, UNCOVERED_FRACTION_CRITERION, cluster_count_algo3, TargetCount, angel_coeff2, blend, multi_class_probability);
%      uncoveredNum_algo3;
%      UncoveredVsCamNum3(loop_count) = uncoveredNum_algo3;
%      cluster_count_algo3 = cluster_count_algo3 + 1;
%      loop_count = loop_count + 1;
%  end
% % 
%  figure;
%  plot(UncoveredVsCamNum3);
%  xlabel('cluster size');
%  ylabel('uncovered targets');
%  title('Algorithm 3 ');

% figure;
% %plot(uncovered_vs_coeff3);
% plot(uncovered_vs_coeff3(2:(angel_coeff_max/step) + 1));

%xlabel('angel coefficient');
%ylabel('# of uncovered targets');

%comparison with CFA:
margin_ratio = 1/6;
pan_step = pi/6;
MAX_CAM_RELOCATION = 10;
seed1 = seed;
seed2 = seed;
%ClusterNum = 1;
cfa_cluster_count = ClusterNum;
cfa_uncovered_num = zeros( 1 , MAX_CAM_RELOCATION);
cfa_uncovered_vs_clusterNum = zeros( 1 , MAX_CLUSTER );
complexity_cfa = 0;
cfa_uncovered_num_avg = TargetCount;
% while ((cfa_cluster_count < MAX_CLUSTER) & (cfa_uncovered_num_avg > UNCOVERED_FRACTION_CRITERION * TargetCount))
%     for i = 1 : MAX_CAM_RELOCATION
%         result = CFAfunc(seed1,seed2+1,AOV_degree, R_min, R_max, pan_step, Dim1_min, Dim1_max, Dim2_min, Dim2_max, cfa_cluster_count, TargetCount, margin_ratio);
%         cfa_uncovered_num( 1 , i ) = result(1,1);
%         complexity_cfa = complexity_cfa + result(1,2);
%         seed2 = seed2 + 1;
%     end
%     cfa_uncovered_num;
%     cfa_uncovered_num_avg = sum(cfa_uncovered_num)/ MAX_CAM_RELOCATION;
%     cfa_std =  std(cfa_uncovered_num);
%     cfa_uncovered_vs_clusterNum( 1 , cfa_cluster_count ) = cfa_uncovered_num_avg;
%     if cfa_uncovered_num_avg < UNCOVERED_FRACTION_CRITERION * TargetCount
%         break;
%     end
%     cfa_cluster_count = cfa_cluster_count + 1;
%     complexity_cfa
% end
% figure;
% plot(cfa_uncovered_vs_clusterNum(1:cfa_cluster_count-1));
% xlabel('cluster size');
% ylabel('uncovered targets');
% title('CFA');

tstart3 = tic;
GreedyResult = Greedyfunc(data, AOV_degree, R_min, R_max, pan_step, Dim1_min, Dim1_max, Dim2_min, Dim2_max, TargetCount);
elapsedGreedy = toc(tstart3)
tstart4 = tic;
DualSamplingResult = DualSamplingFunc(data, AOV_degree, R_min, R_max, pan_step, Dim1_min, Dim1_max, Dim2_min, Dim2_max, TargetCount);
elapsedDualSampling = toc(tstart4)

complexity_algo1
%complexity_cfa

algo1elapse
uncovered_avg_algo1
cluster_count_avg_algo1
algo2elapse
uncoveredNum_algo2
CamCountAlgo2

complexity_Greedy = GreedyResult(3,1) %complexity of greedy algo
complexity_dualSampling = DualSamplingResult(3,1)
cam_number_Greedy = GreedyResult(1,1)
elapsedGreedy
uncovered_Greedy = GreedyResult(2,1)
cam_number_dualSampling = DualSamplingResult(1,1)
uncovered_dualSampling = DualSamplingResult(2,1)




