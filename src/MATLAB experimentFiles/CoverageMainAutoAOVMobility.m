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
Dim1_max = 50;%50;%60;%200; %maximum in x-axis (m)
Dim2_max = 50;%50;%60;%200; %maximum in y-axis (m)
MAX_TIME = 22;
RUN_PERIOD = 5;
TargetCount = 50;%50;%50;%20;%100;
% fraction of targets below which we allow uncovered targets
UNCOVERED_FRACTION_CRITERION = 0.1;%0.2; 
MAX_ITERATION = 50;
XSPEED = 0;
YSPEED = 0;

rand_xspeed = rand(1);
rand_yspeed = rand(1);

xspeed_vec = rand_xspeed +  [ 0.1 0.25 0.5 1 2 3 4];
xspeed_vec =  [ 0.1 0.25 0.5 1 2 3 4];
yspeed_vec = [0 0 0 0 0 0 0 ];
%yspeed_vec = rand_yspeed + [ 0.1 0.25 0.5 1 2 3 4];


ClusterNum = round(TargetCount / 20 ); %round(TargetCount / 10 );%(Dim1_max/R_max)*(Dim2_max/R_max); % initially
MAX_CLUSTER = round(TargetCount/2);

ScenNum = 10;%10;

%AOV_vec = [ 45, 60, 90, 120, 150, 180];
%AOV_vec = [90];
%speed_vec = [0.25 0.5 1 2 3 4 5];
speed_vec = [ 0.1 0.25 0.5 1 2 3 4];
angel_coeff = 50;
angle_coeff = 50;


%blend =2;
%multi_class_probability = 0.75;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%HYBRID METHODS HERE
if 0
polar = 1;
t = 0; %target counter
coverage_hybrid_avg = zeros(size(AOV_vec,2), MAX_TIME);
for v = 1 : size(Speed_vec,2)
%for TargetCount = 10: 10: 100
    %t = t + 1;
    %AOV_degree = AOV_vec(1,v); 
    YSPEED = speed_vec(1,v);
    uncoveredNum_hybrid_sum = 0;
    exec_time_hybrid_sum = 0;
    camNum_sum_hybrid = 0;
    coverageVsTime = zeros(ScenNum, MAX_TIME);
    for s = 1 :ScenNum
        seed = s;
        locations = GenerateMobileData(Dim1_max, Dim2_max, TargetCount, seed, MAX_TIME,XSPEED,YSPEED);
        for time_index = 1 : MAX_TIME
            if time_index == 31
                time_index
            end
            time_index
            if (mod(time_index, RUN_PERIOD) == 1)% always run at time 1
                cluster_count_hybrid = 1;%ClusterNum;
                uncoveredNum_hybrid = TargetCount;

                for k = 1 : TargetCount
                    mydata(k,:) = [locations(k,time_index); locations(k+TargetCount,time_index); locations(k+2*TargetCount,time_index)];
                end
                data = mydata'
                %data(1,:) = data(1,:) + (0.001).*rand(1, TargetCount);% to avoid bad fitting
                uncoveredNum_hybrid = TargetCount;
                cluster_count_hybrid = 1;%ClusterNum;
                tstart2 = tic;
                loop_count = 1;
                while ((uncoveredNum_hybrid >= floor(UNCOVERED_FRACTION_CRITERION * TargetCount))  && (cluster_count_hybrid < MAX_CLUSTER))
                    Result = ClusteredCoverageHybridFunc(data, AOV_degree, R_min, R_max, Dim1_min, Dim2_min, Dim1_max, Dim2_max, MAX_ITERATION, UNCOVERED_FRACTION_CRITERION ,cluster_count_hybrid, TargetCount,angle_coeff, polar);
                    for temp_c = 1 : size(Result,1)
                        if Result(temp_c, 1) == -2
                            membership_row = temp_c + 1;
                            break
                        end
                    end
                    Result
                    membership = Result(membership_row , :)
                    CurrentCams = Result(:, 1:6);
                    CurrentCams = CurrentCams(1:membership_row - 2, :)
                    Result;
                    CurrentCams;
                    membership;
                    %coverage = LightCoverageTest(data, membership, CurrentCams, AOV_degree, R_min, R_max, Dim1_min, Dim2_min, Dim1_max, Dim2_max, membership_row -2, TargetCount)
                    %uncoveredNum_hybrid = Result(1,5);
                    uncoveredNum_hybrid = Result(1,7);
                    UncoveredVsCamNumHybrid(loop_count) = uncoveredNum_hybrid;
                    cluster_count_hybrid = cluster_count_hybrid + 1;
                    loop_count = loop_count + 1;
                end
                hybrid_elapse = toc(tstart2)
                Result;
                CamCountHybrid = cluster_count_hybrid - 1
                uncoveredNum_hybrid
                exec_time_hybrid_sum = exec_time_hybrid_sum + hybrid_elapse;
                uncoveredNum_hybrid_sum = uncoveredNum_hybrid_sum + UncoveredVsCamNumHybrid(loop_count-1);
                camNum_sum_hybrid = camNum_sum_hybrid + CamCountHybrid;
                coverageVsTime( s , time_index ) = TargetCount - uncoveredNum_hybrid;
            else
                %test how many targets are covered in between algo's
                %invocations
                for k = 1 : TargetCount
                    mydata(k,:) = [locations(k,time_index); locations(k+TargetCount,time_index); locations(k+2*TargetCount,time_index)];
                end
                data = mydata'
                CurrentCams
                coverage = LightCoverageTest(data, membership, CurrentCams, AOV_degree, R_min, R_max, Dim1_min, Dim2_min, Dim1_max, Dim2_max, membership_row -2, TargetCount)
                covered = sum(coverage)
                uncoveredNum_hybrid_sum = uncoveredNum_hybrid_sum + (TargetCount - covered);
                coverageVsTime( s , time_index ) = covered;
            end
        end
        coverageVsTime
    end
    coverage_hybrid_avg(v, : ) = sum(coverageVsTime,1)/ScenNum
    
    uncoveredNum_hybrid_avg(v, :) = TargetCount - coverage_hybrid_avg(v, : ); %uncoveredNum_hybrid_sum / (ScenNum*MAX_TIME)
    exec_time_hybrid_avg(1,v) = exec_time_hybrid_sum / (ScenNum*MAX_TIME)
    camNum_hybrid_avg(1,v) = camNum_sum_hybrid /(ScenNum*max(1,(MAX_TIME-1)/RUN_PERIOD))
end
 
  figure;
  %plot(UncoveredVsCamNum2(1:CamCountAlgo2));
  plot(camNum_hybrid_avg);
  xlabel('AOV');
  ylabel('#cameras');
  title('Algorithm Hybrid kmeans ');
  figure;
  %plot(UncoveredVsCamNum2(1:CamCountAlgo2));
  for v = 1 : size(AOV_vec,2)
      plot(uncoveredNum_hybrid_avg(v,:)/TargetCount);
      uncovered_avg_overTime = sum(uncoveredNum_hybrid_avg(v,:))/(MAX_TIME*TargetCount)
      xlabel('time');
      ylabel('#uncovered');
      title('Algorithm hybrid kmeans ');
      hold on;
  end
 
  figure;
  %plot(UncoveredVsCamNum2(1:CamCountAlgo2));
  plot(exec_time_hybrid_avg);
  xlabel('AOV');
  ylabel('execution time');
  title('Algorithm hybrid kmeans ');
  
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FOR FUZZY:
if 1
blend = 2;
multi_class_probability = 0.75;
MyCamCount = [];

t = 0; %target counter
coverage_fuzzy_avg = zeros(size(speed_vec,2), MAX_TIME);
for v = 1 : size(xspeed_vec,2)
    TotalAlgoRuns = 0;
%for TargetCount = 10: 10: 100
    %t = t + 1;
    %AOV_degree = AOV_vec(1,v); 
    YSPEED = speed_vec(1,v);
    uncoveredNum_fuzzy_sum = 0;
    exec_time_fuzzy_sum = 0;
    camNum_sum_fuzzy = 0;
    coverageVsTime = zeros(ScenNum, MAX_TIME);
    for s = 1 :ScenNum
        seed = s;
        XSPEED = xspeed_vec(1,v);
        YSPEED = yspeed_vec(1,v);
        locations = GenerateMobileData(Dim1_max, Dim2_max, TargetCount, seed, MAX_TIME,XSPEED,YSPEED);
        for time_index = 1 : MAX_TIME
            time_index
            if (mod(time_index, RUN_PERIOD) == 1)% always run at time 1
                cluster_count_fuzzy = 1;%ClusterNum;
                uncoveredNum_fuzzy = TargetCount;

                for k = 1 : TargetCount
                    mydata(k,:) = [locations(k,time_index); locations(k+TargetCount,time_index); locations(k+2*TargetCount,time_index)];
                end
                data = mydata'
                %data(1,:) = data(1,:) + (0.001).*rand(1, TargetCount);% to avoid bad fitting
                uncoveredNum_fuzzy = TargetCount;
                cluster_count_fuzzy = 1;%ClusterNum;
                tstart2 = tic;
                loop_count = 1;
                while ((uncoveredNum_fuzzy >= floor(UNCOVERED_FRACTION_CRITERION * TargetCount))  && (cluster_count_fuzzy < MAX_CLUSTER))
                    Result = FuzzyClusteringMATLABFunc(data, AOV_degree, R_min, R_max, Dim1_min, Dim1_max, Dim2_min, Dim2_max, MAX_ITERATION, UNCOVERED_FRACTION_CRITERION, cluster_count_fuzzy, TargetCount, angle_coeff, blend, multi_class_probability)
                    for temp_c = 1 : size(Result,1)
                        if Result(temp_c, 1) == -2
                            membership_row = temp_c + 1;
                            break
                        end
                    end
                    Result
                    membership = Result(membership_row , :)
                    membership = [membership; Result(membership_row + 1, : )];
                    CurrentCams = Result(:, 1:6);
                    CurrentCams = CurrentCams(1:membership_row - 2, :)
                    Result;
                    CurrentCams;
                    membership;
                    %coverage = LightCoverageTest(data, membership, CurrentCams, AOV_degree, R_min, R_max, Dim1_min, Dim2_min, Dim1_max, Dim2_max, membership_row -2, TargetCount)
                    %uncoveredNum_hybrid = Result(1,5);
                    uncoveredNum_fuzzy = Result(1,7);
                    UncoveredVsCamNumFuzzy(loop_count) = uncoveredNum_fuzzy;
                    cluster_count_fuzzy = cluster_count_fuzzy + 1;
                    loop_count = loop_count + 1;
                end
                fuzzy_elapse = toc(tstart2)
                Result;
                CamCountFuzzy = cluster_count_fuzzy - 1
                MyCamCount = [ MyCamCount, CamCountFuzzy ];
                uncoveredNum_fuzzy
                exec_time_fuzzy_sum = exec_time_fuzzy_sum + fuzzy_elapse;
                uncoveredNum_fuzzy_sum = uncoveredNum_fuzzy_sum + UncoveredVsCamNumFuzzy(loop_count-1);
                camNum_sum_fuzzy = camNum_sum_fuzzy + CamCountFuzzy;
                coverageVsTime( s , time_index ) = TargetCount - uncoveredNum_fuzzy;
                TotalAlgoRuns = TotalAlgoRuns + 1;
            else
                %test how many targets are covered in between algo's
                %invocations
                for k = 1 : TargetCount
                    mydata(k,:) = [locations(k,time_index); locations(k+TargetCount,time_index); locations(k+2*TargetCount,time_index)];
                end
                data = mydata'
                CurrentCams
                coverage = LightFuzzyCoverageTest(data, membership, CurrentCams, AOV_degree, R_min, R_max, Dim1_min, Dim2_min, Dim1_max, Dim2_max, membership_row -2, TargetCount)
                covered = sum(coverage)
                uncoveredNum_fuzzy_sum = uncoveredNum_fuzzy_sum + (TargetCount - covered);
                coverageVsTime( s , time_index ) = covered;
            end
        end
        coverageVsTime
    end
    coverage_fuzzy_avg(v, : ) = sum(coverageVsTime,1)/ScenNum
    
    uncoveredNum_fuzzy_avg(v, :) = TargetCount - coverage_fuzzy_avg(v, : ); %uncoveredNum_hybrid_sum / (ScenNum*MAX_TIME)
    exec_time_fuzzy_avg(1,v) = exec_time_fuzzy_sum / (ScenNum*MAX_TIME)
    camNum_fuzzy_avg(1,v) = camNum_sum_fuzzy /TotalAlgoRuns %/(ScenNum*max(1,(MAX_TIME-1)/RUN_PERIOD))
end
 
  figure;
  %plot(UncoveredVsCamNum2(1:CamCountAlgo2));
  plot(camNum_fuzzy_avg);
  xlabel('AOV');
  ylabel('#cameras');
  title('Algorithm Fuzzy');
  figure;
  %plot(UncoveredVsCamNum2(1:CamCountAlgo2));
  for v = 1 : size(speed_vec,2)
      plot(uncoveredNum_fuzzy_avg(v,:)/TargetCount);
      uncovered_avg_overTime = sum(uncoveredNum_fuzzy_avg(v,:))/(MAX_TIME*TargetCount)
      xlabel('time');
      ylabel('#uncovered');
      title('Algorithm fuzzy ');
      hold on;
  end
 
  figure;
  %plot(UncoveredVsCamNum2(1:CamCountAlgo2));
  plot(exec_time_fuzzy_avg);
  xlabel('AOV');
  ylabel('execution time');
  title('Algorithm fuzzy ');
  
  MyCamCount
  
  figure;
  plot(sum(uncoveredNum_fuzzy_avg,2)/(MAX_TIME*TargetCount));
  xlabel('speed');
  ylabel('uncovered ratio');
  title('avg. uncovered vs speed');
  
end


