% change variables and run different algorithms 

clear all;
close all;

AOV_degree = 90;
%AOV = (AOV_degree * 2*pi)/360; %60 degrees camera Angle of View
R_min = 0.0001;%0.01; % 0.5m
R_max = 30;%25;%10;%30;%100; % 3m

% Dimensions of the area
Dim1_min = 0;%2;
Dim2_min = 0;%2;
Dim1_max = 50;%60;%200; %maximum in x-axis (m)
Dim2_max = 50;%60;%200; %maximum in y-axis (m)

TargetCount = 50;%50;%20;%100;
% fraction of targets below which we allow uncovered targets
UNCOVERED_FRACTION_CRITERION = 0.1;%0.2; 
MAX_ITERATION = 50;%50;

ClusterNum = round(TargetCount / 20 ); % round(TargetCount / 10 );%(Dim1_max/R_max)*(Dim2_max/R_max); % initially
MAX_CLUSTER = round(TargetCount/2);

ScenNum = 10;
%target_clusters = 4;



%targets_vec = [10 20 30 40 50 60 70 70 90 100 200 400 600 800 1000];
%targets_vec = [ 600 800 1000];
Rmax_vec = [20 25 30 35 40 45 50];
%Rmax_vec = [50 70 90 100 150];
if 0
t = 0; %target counter
for v = 1 : size(Rmax_vec, 2)
    t = t + 1;
    %TargetCount = targets_vec( 1 , t);
    R_max = Rmax_vec(1,t);
%for TargetCount = 10: 10: 100
    MAX_CLUSTER = round(TargetCount/2);
    uncovered_algo1_vector = zeros(ScenNum,MAX_CLUSTER);
    uncovered_sum_algo1_vector = zeros(ScenNum,MAX_CLUSTER);
    for i = 1 : ScenNum
        uncovered_algo1_vector(i,1:ClusterNum-1) = TargetCount;
        uncovered_sum_algo1_vector(i,1:ClusterNum-1) = 0;
    end
    cluster_count_sum_algo1 = 0;
    exec_time_sum = 0;
    uncovered_sum_algo1 = 0;
    for s = 1 : ScenNum
        seed = s;
        data = GenerateData(Dim1_max, Dim2_max, TargetCount, seed);
        %data = GenerateDataWithLineClusters(Dim1_max, Dim2_max,TargetCount, target_clusters, seed);
        data(1,:) = data(1,:) + (0.001).*rand(1, TargetCount);% to avoid bad fitting

        uncoveredNum_algo1 = TargetCount;
        cluster_count_algo1 = 1;% ClusterNum;

        complexity_algo1 = 0;
        tstart = tic;
        while ((uncoveredNum_algo1 >= floor(UNCOVERED_FRACTION_CRITERION * TargetCount)) & (cluster_count_algo1 < MAX_CLUSTER))
            Result = ClusteredCoverageFunc(data, AOV_degree, R_min, R_max, Dim1_min, Dim2_min, Dim1_max, Dim2_max, MAX_ITERATION, UNCOVERED_FRACTION_CRITERION ,cluster_count_algo1, TargetCount);
             %uncoveredNum_algo1 = Result( 1 , 1 );
            uncoveredNum_algo1 = Result( 1 , 5 ); 
            uncovered_algo1_vector(s,cluster_count_algo1) = uncoveredNum_algo1;
            %complexity_algo1 = complexity_algo1 + Result( 1 , 2 );

            actual_cam_num(cluster_count_algo1) = size(Result,1);
            cluster_count_algo1 = cluster_count_algo1 + 1;
        end
        cluster_count_algo1 = cluster_count_algo1 - 1;
        algo1elapse = toc(tstart);
        uncovered_sum_algo1_vector(s,cluster_count_algo1)= uncovered_sum_algo1_vector(s,cluster_count_algo1) + uncovered_algo1_vector(s,cluster_count_algo1);
        uncovered_sum_algo1 = uncovered_sum_algo1 + uncovered_algo1_vector(s,cluster_count_algo1);
        cluster_count_sum_algo1 = cluster_count_sum_algo1 + cluster_count_algo1;
        exec_time_sum = exec_time_sum + algo1elapse;
    end
    uncovered_avg_algo1(1,t) = uncovered_sum_algo1 / ScenNum
    cluster_count_avg_algo1(1,t) = cluster_count_sum_algo1 / ScenNum
    exec_time_avg(1,t) = exec_time_sum / ScenNum
end

x = ClusterNum : cluster_count_algo1;
%true_x = actual_cam_num(x)
figure;
plot(Rmax_vec, cluster_count_avg_algo1)
xlabel('Rmax');
ylabel('avg. #cameras');
title('Algorithm 1 ');

figure;
plot(Rmax_vec, uncovered_avg_algo1);
xlabel('#Rmax');
ylabel('#uncovered');
title('Algorithm 1 ');

figure;
plot(Rmax_vec, exec_time_avg);
xlabel('Rmax');
ylabel('execution time');
title('Algorithm 1 ');

end
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


Algo2complexity = 0;
t = 0; %target counter
for v = 1 : size(Rmax_vec,2)
%for TargetCount = 10: 10: 100
    t = t + 1;
    %TargetCount = targets_vec( 1 , t);
    R_max = Rmax_vec(1,t); 
    cluster_count_algo2 = 1;%ClusterNum;
    uncoveredNum_algo2 = TargetCount;
    uncoveredNum_algo2_sum = 0;
    exec_time_algo2_sum = 0;
    camNum_sum = 0;
    for s = 1 :ScenNum
        seed = s;
        data = GenerateData(Dim1_max, Dim2_max, TargetCount, seed);
        %data = GenerateDataWithLineClusters(Dim1_max, Dim2_max,TargetCount, target_clusters, seed);
        data(1,:) = data(1,:) + (0.001).*rand(1, TargetCount);% to avoid bad fitting
        uncoveredNum_algo2 = TargetCount;
        cluster_count_algo2 = 1;%ClusterNum;
        tstart2 = tic;
        loop_count = 1;
        while ((uncoveredNum_algo2 >= floor(UNCOVERED_FRACTION_CRITERION * TargetCount))  && (cluster_count_algo2 < MAX_CLUSTER))
            ResultAlgo2 = ConvertedFeaturesAlgorithmWorkableFunc(data, AOV_degree, R_min, R_max, Dim1_min, Dim1_max, Dim2_min, Dim2_max, MAX_ITERATION, UNCOVERED_FRACTION_CRITERION, cluster_count_algo2, TargetCount,angel_coeff);

            uncoveredNum_algo2 = ResultAlgo2(1,1)

            UncoveredVsCamNum2(loop_count) = uncoveredNum_algo2;
            cluster_count_algo2 = cluster_count_algo2 + 1;
            loop_count = loop_count + 1;
        end
        algo2elapse = toc(tstart2)

        CamCountAlgo2 = cluster_count_algo2 - 1
        uncoveredNum_algo2
        exec_time_algo2_sum = exec_time_algo2_sum + algo2elapse;
        uncoveredNum_algo2_sum = uncoveredNum_algo2_sum + UncoveredVsCamNum2(loop_count-1);
        camNum_sum = camNum_sum + CamCountAlgo2;
        
    end
    uncoveredNum_algo2_avg(1,t) = uncoveredNum_algo2_sum / ScenNum
    exec_time_algo2_avg(1,t) = exec_time_algo2_sum / ScenNum
    camNum_avg(1,t) = camNum_sum/ScenNum
end
 
  figure;
  plot(Rmax_vec,camNum_avg);
  xlabel('Rmax');
  ylabel('#cameras');
  title('Algorithm 2 ');
  figure;
  plot(Rmax_vec, uncoveredNum_algo2_avg);
  xlabel('#Rmax');
  ylabel('#uncovered');
  title('Algorithm 2 ');
 
  figure;
  %plot(UncoveredVsCamNum2(1:CamCountAlgo2));
  plot(Rmax_vec, exec_time_algo2_avg);
  xlabel('Rmax');
  ylabel('execution time');
  title('Algorithm 2 ');


 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%For fuzzy:
blend =2;
angle_coeff = 50;
angel_coeff = 50;

 multi_class_probability = 0.75;
t = 0; %target counter
for v = 1 : size(Rmax_vec,2)
%for TargetCount = 10: 10: 100
    t = t + 1;
    R_max = Rmax_vec(1,t);  
    cluster_count_fuzzy = 1;%ClusterNum;
    uncoveredNum_fuzzy = TargetCount;
    uncoveredNum_fuzzy_sum = 0;
    exec_time_fuzzy_sum = 0;
    camNum_sum_fuzzy = 0;
    for s = 1 :ScenNum
        seed = s;
        data = GenerateData(Dim1_max, Dim2_max, TargetCount, seed);
        %data = GenerateDataWithLineClusters(Dim1_max, Dim2_max,TargetCount, target_clusters, seed);
        data(1,:) = data(1,:) + (0.001).*rand(1, TargetCount);% to avoid bad fitting
        uncoveredNum_fuzzy = TargetCount;
        cluster_count_fuzzy = 2;%ClusterNum;
        tstart2 = tic;
        loop_count = 1;
        while ((uncoveredNum_fuzzy >= floor(UNCOVERED_FRACTION_CRITERION * TargetCount))  && (cluster_count_fuzzy < MAX_CLUSTER))
            uncoveredNum_fuzzy = FuzzyClusteringMATLABFunc(data, AOV_degree, R_min, R_max, Dim1_min, Dim1_max, Dim2_min, Dim2_max, MAX_ITERATION, UNCOVERED_FRACTION_CRITERION, cluster_count_fuzzy, TargetCount, angel_coeff, blend, multi_class_probability);
            UncoveredVsCamNumFuzzy(loop_count) = uncoveredNum_fuzzy;
            cluster_count_fuzzy = cluster_count_fuzzy + 1;
            loop_count = loop_count + 1;
        end
        algoFuzzyelapse = toc(tstart2)

        CamCountAlgoFuzzy = cluster_count_fuzzy - 1
        uncoveredNum_fuzzy
        exec_time_fuzzy_sum = exec_time_fuzzy_sum + algoFuzzyelapse;
        uncoveredNum_fuzzy_sum = uncoveredNum_fuzzy_sum + UncoveredVsCamNumFuzzy(loop_count-1);
        camNum_sum_fuzzy = camNum_sum_fuzzy + CamCountAlgoFuzzy;
        
    end
    uncoveredNum_fuzzy_avg(1,t) = uncoveredNum_fuzzy_sum / ScenNum
    exec_time_fuzzy_avg(1,t) = exec_time_fuzzy_sum / ScenNum
    camNum_avg_fuzzy(1,t) = camNum_sum_fuzzy/ScenNum
end
 
  figure;
  plot(Rmax_vec,camNum_avg_fuzzy);
  xlabel('Rmax');
  ylabel('#cameras');
  title('Algorithm Fuzzy ');
  figure;
  plot(Rmax_vec, uncoveredNum_fuzzy_avg);
  xlabel('Rmax');
  ylabel('#uncovered');
  title('Algorithm Fuzzy ');
 
  figure;
  %plot(UncoveredVsCamNum2(1:CamCountAlgo2));
  plot(Rmax_vec, exec_time_fuzzy_avg);
  xlabel('Rmax');
  ylabel('execution time');
  title('Algorithm Fuzzy ');

  
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %HYBRIDS
 if 1
  %adding hybrid methods here
  angel_coeff = 50;

polar = 1;
Algo2complexity = 0;
t = 0; %target counter
for v = 1 : size(Rmax_vec,2)
%for TargetCount = 10: 10: 100
    t = t + 1;
    R_max = Rmax_vec(1,t);  
    cluster_count_hybrid = 1;%ClusterNum;
    uncoveredNum_hybrid = TargetCount;
    uncoveredNum_hybrid_sum = 0;
    exec_time_hybrid_sum = 0;
    camNum_sum_hybrid = 0;
    for s = 1 :ScenNum
        seed = s;
        data = GenerateData(Dim1_max, Dim2_max, TargetCount, seed);
        %data = GenerateDataWithLineClusters(Dim1_max, Dim2_max,TargetCount, target_clusters, seed);
        data(1,:) = data(1,:) + (0.001).*rand(1, TargetCount);% to avoid bad fitting
        uncoveredNum_hybrid = TargetCount;
        cluster_count_hybrid = 1;%ClusterNum;
        tstart2 = tic;
        loop_count = 1;
        while ((uncoveredNum_hybrid >= floor(UNCOVERED_FRACTION_CRITERION * TargetCount))  && (cluster_count_hybrid < MAX_CLUSTER))
            Result = ClusteredCoverageHybridFunc(data, AOV_degree, R_min, R_max, Dim1_min, Dim2_min, Dim1_max, Dim2_max, MAX_ITERATION, UNCOVERED_FRACTION_CRITERION ,cluster_count_hybrid, TargetCount,angle_coeff, polar);
            uncoveredNum_hybrid = Result(1,5);

            UncoveredVsCamNumHybrid(loop_count) = uncoveredNum_hybrid;
            cluster_count_hybrid = cluster_count_hybrid + 1;
            loop_count = loop_count + 1;
        end
        hybrid_elapse = toc(tstart2)

        CamCountHybrid = cluster_count_hybrid - 1
        uncoveredNum_hybrid
        exec_time_hybrid_sum = exec_time_hybrid_sum + hybrid_elapse;
        uncoveredNum_hybrid_sum = uncoveredNum_hybrid_sum + UncoveredVsCamNumHybrid(loop_count-1);
        camNum_sum_hybrid = camNum_sum_hybrid + CamCountHybrid;
        
    end
    uncoveredNum_hybrid_avg(1,t) = uncoveredNum_hybrid_sum / ScenNum
    exec_time_hybrid_avg(1,t) = exec_time_hybrid_sum / ScenNum
    camNum_hybrid_avg(1,t) = camNum_sum_hybrid/ScenNum
end
 
  figure;
  %plot(UncoveredVsCamNum2(1:CamCountAlgo2));
  plot(camNum_hybrid_avg);
  xlabel('Rmax');
  ylabel('#cameras');
  title('Algorithm Hybrid kmeans ');
  figure;
  %plot(UncoveredVsCamNum2(1:CamCountAlgo2));
  plot(uncoveredNum_hybrid_avg);
  xlabel('Rmax');
  ylabel('#uncovered');
  title('Algorithm hybrid kmeans ');
 
  figure;
  %plot(UncoveredVsCamNum2(1:CamCountAlgo2));
  plot(exec_time_hybrid_avg);
  xlabel('Rmax');
  ylabel('execution time');
  title('Algorithm hybrid kmeans ');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%tree-based clusters hybrid

t = 0; %target counter
for v = 1 : size(Rmax_vec,2)
%for TargetCount = 10: 10: 100
    t = t + 1;
    R_max = Rmax_vec(1,t);  
    cluster_count_hybridt = 1;%ClusterNum;
    uncoveredNum_hybridt = TargetCount;
    uncoveredNum_hybridt_sum = 0;
    exec_time_hybridt_sum = 0;
    camNum_sum_hybridt = 0;
    for s = 1 :ScenNum
        seed = s;
        data = GenerateData(Dim1_max, Dim2_max, TargetCount, seed);
        %data = GenerateDataWithLineClusters(Dim1_max, Dim2_max,TargetCount, target_clusters, seed);
        data(1,:) = data(1,:) + (0.001).*rand(1, TargetCount);% to avoid bad fitting
        uncoveredNum_hybridt = TargetCount;
        cluster_count_hybridt = 1;%ClusterNum;
        tstart3 = tic;
        loop_count = 1;
        while ((uncoveredNum_hybridt >= floor(UNCOVERED_FRACTION_CRITERION * TargetCount))  && (cluster_count_hybridt < MAX_CLUSTER))
            Result = TreeClusteredCoverageHybridFunc(data, AOV_degree, R_min, R_max, Dim1_min, Dim2_min, Dim1_max, Dim2_max, MAX_ITERATION, UNCOVERED_FRACTION_CRITERION ,cluster_count_hybridt, TargetCount,angle_coeff);
            uncoveredNum_hybridt = Result(1,5);

            UncoveredVsCamNumht(loop_count) = uncoveredNum_hybridt;
            cluster_count_hybridt = cluster_count_hybridt + 1;
            loop_count = loop_count + 1;
        end
        hybridt_elapse = toc(tstart3)

        CamCountHybridt = cluster_count_hybridt - 1
        uncoveredNum_hybridt
        exec_time_hybridt_sum = exec_time_hybridt_sum + hybridt_elapse;
        uncoveredNum_hybridt_sum = uncoveredNum_hybridt_sum + UncoveredVsCamNumht(loop_count-1);
        camNum_sum_hybridt = camNum_sum_hybridt + CamCountHybridt;
        
    end
    uncoveredNum_hybridt_avg(1,t) = uncoveredNum_hybridt_sum / ScenNum
    exec_time_hybridt_avg(1,t) = exec_time_hybridt_sum / ScenNum
    camNum_hybridt_avg(1,t) = camNum_sum_hybridt/ScenNum
end
 
  figure;
  %plot(UncoveredVsCamNum2(1:CamCountAlgo2));
  plot(camNum_hybridt_avg);
  xlabel('Rmax');
  ylabel('#cameras');
  title('Algorithm Hybrid tree ');
  figure;
  %plot(UncoveredVsCamNum2(1:CamCountAlgo2));
  plot(uncoveredNum_hybridt_avg);
  xlabel('Rmax');
  ylabel('#uncovered');
  title('Algorithm hybrid tree ');
 
  figure;
  %plot(UncoveredVsCamNum2(1:CamCountAlgo2));
  plot(exec_time_hybridt_avg);
  xlabel('Rmax');
  ylabel('execution time');
  title('Algorithm hybrid tree ');

end  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

if 0
%re-define ScenNum 
ScenNum = 5;

t = 0; %target counter
for v = 1 : size(Rmax_vec,2)
    Greedy_exec_time_sum = 0;
    Greedy_uncovered_sum = 0;
    Greedy_camNum_sum = 0;

    Dual_exec_time_sum = 0;
    Dual_uncovered_sum = 0;
    Dual_camNum_sum = 0;
%for TargetCount = 10: 10: 100
    t = t + 1;
    %TargetCount = targets_vec( 1 , t);
    R_max = Rmax_vec(1,t);
    for s = 1 :ScenNum
        seed = s;
        data = GenerateData(Dim1_max, Dim2_max, TargetCount, seed);
        %data = GenerateDataWithLineClusters(Dim1_max, Dim2_max,TargetCount, target_clusters, seed);
        data(1,:) = data(1,:) + (0.001).*rand(1, TargetCount);% to avoid bad fitting
        tstart3 = tic;
        GreedyResult = Greedyfunc(data, AOV_degree, R_min, R_max, pan_step, Dim1_min, Dim1_max, Dim2_min, Dim2_max, TargetCount);
        elapsedGreedy = toc(tstart3);
        uncovered_Greedy = GreedyResult(2,1);
        cam_number_Greedy = GreedyResult(1,1);

        Greedy_exec_time_sum = Greedy_exec_time_sum + elapsedGreedy;
        Greedy_uncovered_sum = Greedy_uncovered_sum + uncovered_Greedy;
        Greedy_camNum_sum = Greedy_camNum_sum + cam_number_Greedy;


        tstart4 = tic;
        DualSamplingResult = DualSamplingFunc(data, AOV_degree, R_min, R_max, pan_step, Dim1_min, Dim1_max, Dim2_min, Dim2_max, TargetCount);
        elapsedDualSampling = toc(tstart4);
        cam_number_dualSampling = DualSamplingResult(1,1);
        uncovered_dualSampling = DualSamplingResult(2,1);

        Dual_exec_time_sum = Dual_exec_time_sum + elapsedDualSampling;
        Dual_uncovered_sum = Dual_uncovered_sum + uncovered_dualSampling;
        Dual_camNum_sum = Dual_camNum_sum + cam_number_dualSampling;
    end
    Greedy_exec_time_avg(1,t) = Greedy_exec_time_sum/ScenNum
    Greedy_uncovered_avg(1,t) = Greedy_uncovered_sum/ScenNum
    Greedy_camNum_avg(1,t) = Greedy_camNum_sum/ScenNum

    Dual_exec_time_avg(1,t) = Dual_exec_time_sum/ScenNum
    Dual_uncovered_avg(1,t) = Dual_uncovered_sum/ScenNum
    Dual_camNum_avg(1,t) = Dual_camNum_sum/ScenNum
end


Greedy_exec_time_avg
Greedy_uncovered_avg
Greedy_camNum_avg


Dual_exec_time_avg
Dual_uncovered_avg
Dual_camNum_avg
end
