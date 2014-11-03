% this file addresses clustering targets coverable by one camera
% initial number of cameras/clusters = max(dim_x, dim_y)/R_max

clear all;
close all;

AOV_degree = 60;
AOV = (AOV_degree * 2*pi)/360; %60 degrees camera Angle of View
R_min = 0.0001;%0.01; % 0.5m
R_max = 30; % 3m

% Dimensions of the area
Dim1_min = 0;
Dim2_min = 0;
Dim1_max = 60; %maximum in x-axis (m)
Dim2_max = 60; %maximum in y-axis (m)


% OR using random data
TargetCount = 20;
% fraction of targets below which we allow uncovered targets
UNCOVERED_FRACTION_CRITERION = 0.2; 
MAX_ITERATION = 100;

ClusterNum = 4; % initially

data = GenerateData(Dim1_max, Dim2_max, TargetCount);
ClusterIndex = ConvertedFeaturesAlgorithmFunc(data, TargetCount, ClusterNum, MAX_ITERATION);


for i = 1 : TargetCount
    Targets(i) = TargetClass( data( 1,i ), data( 2,i ), data( 3,i ), 1 );
    Targets(i).cluster_index = ClusterIndex(1,i);        
end






for i = 1 : ClusterNum
    members_count = 0;
    for j = 1 : TargetCount
        if ( Targets(j).cluster_index == i )
            members_count = members_count + 1;
            Clusters( i, members_count) = j;
        end
    end
end

% From matrix Clusters, form Target list for each cluster
% Feed this list to CoverageTestFunc


% ConveragenceTestFunc finds out:
% 1. Where is the optimal camera position
% 2. Which targets cannot be covered in this cluster

status = zeros( ClusterNum, TargetCount + 3 );
coverage_status = zeros( ClusterNum, TargetCount ) - 1;
cams = zeros( ClusterNum, 3 ) - 1;
cluster_cam_slopes = zeros( 1, ClusterNum );
for clusterIndex = 1 : ClusterNum
     temp_vec = CoverageTestFunc(Targets, AOV_degree, R_min, R_max, clusterIndex); 
     for c = 1 : size( temp_vec, 2 )
         status( clusterIndex , c ) = temp_vec( c );
     end
end

% analyze the results of coverage algorithm
for i = 1 : ClusterNum
    j = 1;
    while ( status( i , j ) ~= -1 )
        j = j + 1;
    end
    for count = 1 : j - 1
        coverage_status( i , count ) = status( i , count );
    end
    axis_ind = 1;
    for count = j + 1 : j + 3
        cams( i , axis_ind ) = status( i , count );
        axis_ind = axis_ind + 1;
    end
    cluster_cam_slopes( 1, i ) = status( i , j + 4 )
end


%plotting useful stuff:
uncoveredNum = 0;
for i = 1 : ClusterNum
        j = 1;
        while ( (j <=  TargetCount) & (coverage_status( i , j ) ~= -1) )
            if ( coverage_status( i , j ) == 0 )
                % target j of cluster i not covered
                uncovered_index = Clusters( i , j );
                uncoveredNum = uncoveredNum + 1;
            end
            
            j = j + 1;
        end
        
end
    



   
% figure;
% plot(uncoveredNum);
% xlabel('iteration');
% ylabel('# of uncovered targets');
% figure;
% plot(clusterSize);
% legend('cluster 1', 'cluster 2', 'cluster 3', 'cluster 4');

    






