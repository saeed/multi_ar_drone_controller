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
seed = 3;
data = GenerateData(Dim1_max, Dim2_max, TargetCount,seed);

sum_x = 0;
sum_y = 0;
sum_z = 0;
my_data = data(1:2,:);
for i = 1 : TargetCount
    sum_x = sum_x + my_data( 1 , i );
    sum_y = sum_y + my_data( 2, i );
end
mean_x = sum_x /TargetCount;
mean_y = sum_y / TargetCount;
mean = [mean_x; mean_y];

S = zeros(2,2);
for i = 1 : TargetCount
    S = S + ( my_data( : , i ) - mean )*( my_data( : , i ) - mean )';
end

[V,D] = eig(S)
eigenVectors = V;
spreadRatio = min(D(1,1),D(2,2))/max(D(1,1),D(2,2));



%V = calculatePCA(data(1:2,:), TargetCount)
% for i = 1 : TargetCount
%     Targets(i) = TargetClass( data( 1,i ), data( 2,i ), data( 3,i ), 1 );
%     if (( data( 1 , i ) < Dim1_max/2 ) & ( data( 2 , i ) < Dim2_max/2 ))
%         Targets(i).cluster_index = 1;
%     elseif (( data( 1 , i ) > Dim1_max/2 ) & ( data( 2 , i ) < Dim2_max/2 ))
%          Targets(i).cluster_index = 2;
%     elseif (( data( 1 , i ) < Dim1_max/2 ) & ( data( 2 , i ) > Dim2_max/2 ))
%          Targets(i).cluster_index = 3;
%     elseif (( data( 1 , i ) > Dim1_max/2 ) & ( data( 2 , i ) > Dim2_max/2 ))
%          Targets(i).cluster_index = 4;
%     end
%          
% end

% for i = 1 : TargetCount
%     Targets(i) = TargetClass( data( 1,i ), data( 2,i ), data( 3,i ), 1 );
%     if (( data( 1 , i ) < Dim1_max/4 ))
%         Targets(i).cluster_index = 1;
%     elseif (( data( 1 , i ) > (1/4)*Dim1_max ) & ( data( 2 , i ) < (2/4)*Dim1_max ))
%          Targets(i).cluster_index = 2;
%     elseif (( data( 1 , i ) > (2/4)*Dim1_max ) & ( data( 2 , i ) < (3/4)*Dim1_max ))
%          Targets(i).cluster_index = 3;
%     elseif (( data( 1 , i ) > (3/4)*Dim1_max ))
%          Targets(i).cluster_index = 4;
%     end
%          
% end
% 

if ClusterNum == 1
   for i = 1 : TargetCount
    Targets(i) = TargetClass( data( 1,i ), data( 2,i ), data( 3,i ), 1 );
    for j = 1 : ClusterNum
        Targets(i).cluster_index = j;
    end
end
 
    
    
end
    

for i = 1 : TargetCount
    Targets(i) = TargetClass( data( 1,i ), data( 2,i ), data( 3,i ), 1 );
    for j = 1 : ClusterNum
        if ( data( 2,i ) > ( j - 1 ) * Dim2_max/ClusterNum & ( data( 2 , i ) < j * Dim2_max/ClusterNum ))
            Targets(i).cluster_index = j;
        end
    end
end

% Clusters is array of all clusters
% each cluster is also an array including the indices of all target points
% in this cluster


% Clusters: matrix of objects of type TargetClass
% each row i of Clusters includes all targets that fall into cluter i
% Use the cluster index attribute of Targets to fill up Clusters vector

for i = 1 : ClusterNum
    members_count = 0;
    for j = 1 : TargetCount
        if ( Targets(j).cluster_index == i )
            members_count = members_count + 1;
            Clusters( i, members_count) = j;
        end
    end
end
Clusters

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

% for those targets not covered in their clusters, decide on the best
% adjacent cluster

% if a cluster has no member, remove it
% how to manage number of clusters
% how to increase them if needed?


uncoveredNum = zeros(MAX_ITERATION);
iteration = 1;
converged_flag = 0;
while ( ( iteration < MAX_ITERATION )  & ( converged_flag ~= 1 ) )
    iteration = iteration + 1;
    
    for i = 1 : ClusterNum
        j = 1;
        while ( (j <=  TargetCount) & (coverage_status( i , j ) ~= -1) )
            if ( coverage_status( i , j ) == 0 )
                % target j of cluster i not covered
                uncovered_index = Clusters( i , j );
                uncoveredNum( iteration ) = uncoveredNum( iteration ) + 1;
                % change this target's cluster by modifying its cluster index
                % find a cluster whose mean is closer to this target

                best_cluster_ind = FindBestCluster(Clusters, Targets, uncovered_index, cams, cluster_cam_slopes, R_min, R_max, AOV);

                Targets(uncovered_index).cluster_index = best_cluster_ind;

            end
            
            j = j + 1;
        end
        
    end
    
    %reset Clusters matrix
    for i = 1 : ClusterNum
        for j = 1 : TargetCount
            Clusters( i , j ) = 0;
        end
    end
    
    
    % update Clusters matrix with new memberships
    for i = 1 : ClusterNum
        members_count = 0;
        for j = 1 : TargetCount
            if ( Targets(j).cluster_index == i )
                members_count = members_count + 1;
                Clusters( i, members_count) = j;
            end
        end
    end
    
%     % check if one cluster has no member
    clusterSize( iteration , : ) = zeros( 1, size( Clusters, 2 ));
    for i = 1 : ClusterNum
        for j = 1 : size(Clusters, 2 )
            if ( Clusters( i , j ) ~= 0 )
                clusterSize( iteration , i) = clusterSize( iteration , i) + 1;
            end
        end
    end
    
%     tempClusters = Clusters;
%     for i = 1 : ClusterNum
%         if ( clusterSize( i ) ~= 0 )
%             tempClusters( i , : ) = Clusters( i , : );
%         end
%     end
%     % all clusters with no member are eliminated
%     Clusters = tempClusters;
%     ClusterNum = size( tempClusters , 1 );
%     
   
    %if (uncoveredNum(iteration) < UNCOVERED_FRACTION_CRITERION * TargetCount)
    %    break
    %end
    
    %if convergence accomplished, skip iterating
    if ( uncoveredNum( iteration ) < UNCOVERED_FRACTION_CRITERION * TargetCount )
                converged_flag = 1;
                break
    end
    
    % ConveragenceTestFunc finds out:
    % 1. Where is the optimal camera position
    % 2. Which targets cannot be covered in this cluster

    status = zeros( ClusterNum, TargetCount + 3 );
    coverage_status = zeros( ClusterNum, TargetCount ) - 1;
    cams = zeros( ClusterNum, 3 ) - 1;
    cluster_cam_slope = zeros( ClusterNum );
    for clusterIndex = 1 : ClusterNum
        if ( clusterSize( iteration, clusterIndex ) ~= 0 ) 
            temp_vec = CoverageTestFunc(Targets, AOV_degree, R_min, R_max, clusterIndex); 
            for c = 1 : size( temp_vec, 2 )
                status( clusterIndex , c ) = temp_vec( c );
            end
        else
            status( clusterIndex , : ) = - 1;
        end
        
    end

    % analyze the results of coverage algorithm
    for i = 1 : ClusterNum
        j = 1;
        while ( (j <= TargetCount + 3) &  (status( i , j ) ~= -1) )
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
        cluster_cam_slope( i ) = status( i , j + 4 );
    end
    
    
    
    
end
figure;
plot(uncoveredNum);
xlabel('iteration');
ylabel('# of uncovered targets');
figure;
plot(clusterSize);
legend('cluster 1', 'cluster 2', 'cluster 3', 'cluster 4');

    






