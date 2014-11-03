
function output = FinalCoverageMainEnhancedExperiment(data, AOV_degree, R_min, R_max, Dim1_min, Dim2_min, Dim1_max, Dim2_max, max_iteration, uncovered_fraction_criterion, ClusterNum, MAX_CLUSTER, TargetCount,altitude,Margin)
%clear all;
% all;
% AOV_degree = 90;
% %AOV = (AOV_degree * 2*pi)/360; %60 degrees camera Angle of View
% altitude = 1;
% R_min = altitude*10;%0.0001;%0.01; % 0.5m
% R_max = 300;%25;%10;%30;%100; % 3m
% 
% % Dimensions of the area
% Dim1_min = 0;%2;
% Dim2_min = 0;%2;
% Dim1_max = 700;%700;%50;%60;%200; %maximum in x-axis (m)
% Dim2_max = 500%500;%50;%60;%200; %maximum in y-axis (m)
% margin = 10;%10;



AOV = (AOV_degree * 2*pi)/360; %60 degrees camera Angle of View

% TargetCount = 4 ;%20;%100;
% % fraction of targets below which we allow uncovered targets
% uncovered_fraction_criterion = 0.1;
% max_iteration = 50;
UNCOVERED_FRACTION_CRITERION = uncovered_fraction_criterion;%0.2; 
MAX_ITERATION = max_iteration;

% data = GenerateData(Dim1_max, Dim2_max, TargetCount, 1);
% data(1,:) = data(1,:) + (0.01).*rand(1, TargetCount);% to avoid bad fitting


%ClusterNum =  1;%round(TargetCount / 20 ); %round(TargetCount / 10 );%(Dim1_max/R_max)*(Dim2_max/R_max); % initially
%MAX_CLUSTER = round(TargetCount/2);
if 0
        uncoveredNum_algo1 = TargetCount;
        cluster_count_algo1 = 1;% ClusterNum;

        complexity_algo1 = 0;
        tstart = tic;
        while ((uncoveredNum_algo1 > floor(UNCOVERED_FRACTION_CRITERION * TargetCount)) & (cluster_count_algo1 <= MAX_CLUSTER))
            Result = ClusteredCoverageFunc(data, AOV_degree, R_min, R_max, Dim1_min, Dim2_min, Dim1_max, Dim2_max, MAX_ITERATION, UNCOVERED_FRACTION_CRITERION ,cluster_count_algo1, TargetCount,margin);
             %uncoveredNum_algo1 = Result( 1 , 1 );
            %uncoveredNum_algo1 = Result( 1 , 5 ); 
            uncoveredNum_algo1 = Result( 1 , 7); 
            %uncovered_algo1_vector(s,cluster_count_algo1) = uncoveredNum_algo1;
            %complexity_algo1 = complexity_algo1 + Result( 1 , 2 );

            actual_cam_num(cluster_count_algo1) = size(Result,1);
            cluster_count_algo1 = cluster_count_algo1 + 1;
        end
        cluster_count_algo1 = cluster_count_algo1 - 1;
        algo1elapse = toc(tstart);
        Result;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%if 1
  %adding hybrid methods here
  angel_coeff = 50;
  angle_coeff = 50;

polar = 1;
Algo2complexity = 0;

cluster_count_hybrid = 1;%ClusterNum;
uncoveredNum_hybrid = TargetCount;
uncoveredNum_hybrid = TargetCount;
cluster_count_hybrid = 1;%ClusterNum;
tstart2 = tic;
loop_count = 1;
while ((uncoveredNum_hybrid > floor(UNCOVERED_FRACTION_CRITERION * TargetCount))  && (cluster_count_hybrid <= MAX_CLUSTER))
    Result = ClusteredCoverageHybridFunc(data, AOV_degree, R_min, R_max, Dim1_min, Dim2_min, Dim1_max, Dim2_max, MAX_ITERATION, UNCOVERED_FRACTION_CRITERION ,cluster_count_hybrid, TargetCount,angle_coeff, polar,Margin);
    %uncoveredNum_hybrid = Result(1,5);

    %UncoveredVsCamNumHybrid(loop_count) = uncoveredNum_hybrid;
    for temp_c = 1 : size(Result,1)
                if Result(temp_c, 1) == -2
                    membership_row = temp_c + 1;
                    break
                end
    end
    Result
    membership = Result(membership_row , :)
    CurrentCams = Result(:, 1:6);
    CurrentCams = CurrentCams(1:membership_row - 2, :);
    CamDirs = CurrentCams(:, 4:6);
    for angle_ind = 1 : size(CamDirs,1)
        if ((CamDirs(angle_ind, 1) > 0) && (CamDirs(angle_ind, 2) >= 0))
            CamAngles(angle_ind) = (180/pi)*atan(CamDirs(angle_ind, 2)/CamDirs(angle_ind, 1));
        elseif ((CamDirs(angle_ind, 1) > 0) && (CamDirs(angle_ind, 2) <= 0))
            CamAngles(angle_ind) = 360 - (180/pi)*atan(-CamDirs(angle_ind, 2)/CamDirs(angle_ind, 1));
        elseif ((CamDirs(angle_ind, 1) < 0) && (CamDirs(angle_ind, 2) <= 0))
            CamAngles(angle_ind) = 180 + (180/pi)*atan(CamDirs(angle_ind, 2)/(CamDirs(angle_ind, 1)));
        else
            CamAngles(angle_ind) = 180 + (180/pi)*atan((-CamDirs(angle_ind, 2))/(CamDirs(angle_ind, 1)));
        end
    end
    Result;
    CurrentCams
    CamAngles
    membership;
    %coverage = LightCoverageTest(data, membership, CurrentCams, AOV_degree, R_min, R_max, Dim1_min, Dim2_min, Dim1_max, Dim2_max, membership_row -2, TargetCount)
    %uncoveredNum_hybrid = Result(1,5);
    uncoveredNum_hybrid = Result(1,7);
    UncoveredVsCamNumHybrid(loop_count) = uncoveredNum_hybrid;

    cluster_count_hybrid = cluster_count_hybrid + 1;
    loop_count = loop_count + 1;
end
hybrid_elapse = toc(tstart2)

CamCountHybrid = cluster_count_hybrid - 1
uncoveredNum_hybrid

output = [CurrentCams, CamAngles'];
        
%end
 


end





