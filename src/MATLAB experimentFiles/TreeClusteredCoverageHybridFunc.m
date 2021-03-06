function Result = TreeClusteredCoverageHybridFunc(data,AOV_degree, R_min, R_max, Dim1_min, Dim2_min, Dim1_max, Dim2_max, max_iteration, uncovered_fraction_criterion, ClusterNum, TargetCount,coeff)

% this file addresses clustering targets coverable by one camera
% initial number of cameras/clusters = max(dim_x, dim_y)/R_max

AddComplexity = 0;
MultComplexity = 0;
CompComplexity = 0;
complexity = 0;

AOV = (AOV_degree * 2*pi)/360; %60 degrees camera Angle of View
%data = GenerateData(Dim1_max, Dim2_max, TargetCount, seed);

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


mydata = [data(1,:);data(2,:)];
% direct features:
T = clusterdata(mydata', 'maxclust', ClusterNum);
ClusterIndex = T'

%polar features
%converted_data = zeros(size(mydata,1),size(mydata,2));
% derive new data from this data
complexity = 0;
% for i = 1 : size(mydata,2)
%     temp = mydata( : , i );
%     f1 = coeff*atan(temp(2)/temp(1));
%     f2 = ((temp(1)).^2 + (temp(2)).^2).^0.5;
%     converted_data( : , i ) = [f1;f2];
%     complexity = complexity + 3;
% end
% T = clusterdata(converted_data', 'maxclust', ClusterNum);
% ClusterIndex = T'

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
Clusters;


% Clusters is array of all clusters
% each cluster is also an array including the indices of all target points
% in this cluster


% Clusters: matrix of objects of type TargetClass
% each row i of Clusters includes all targets that fall into cluter i
% Use the cluster index attribute of Targets to fill up Clusters vector

ClusterNum = size(Clusters,1);% some cams may not have been used!

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
     temp_vec = CoverageTestFunc(Targets, AOV_degree, R_min, R_max, Dim1_min, Dim2_min, Dim1_max, Dim2_max, clusterIndex); 
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
    cluster_cam_slopes( 1, i ) = status( i , j + 4 );
    complexity = complexity + status( i , j + 5 );
end

emptyRowChecker = sum(Clusters,2);
for i = 1 : ClusterNum
    if (emptyRowChecker(i,1) == 0)
        %find the most crowded cluster and add this camera to that cluster
        [maxmembers, cluster_iter] = max(emptyRowChecker);
        
    end
end


% for those targets not covered in their clusters, decide on the best
% adjacent cluster

% if a cluster has no member, remove it
% how to manage number of clusters
% how to increase them if needed?


uncoveredNum = zeros(max_iteration);
iteration = 1;
converged_flag = 0;

while ( ( iteration < max_iteration )  & ( converged_flag ~= 1 ) )
    iteration = iteration + 1;
    
    emptyRowChecker = sum(Clusters,2);
    unusedCamIndices = find( emptyRowChecker  == 0);
    
    for i = 1 : ClusterNum
        j = 1;
       
        
        
        while ( (j <=  TargetCount) & (coverage_status( i , j ) ~= -1) )
            if ( coverage_status( i , j ) == 0 )
                % target j of cluster i not covered
                uncovered_index = Clusters( i , j );
                uncoveredNum( iteration ) = uncoveredNum( iteration ) + 1;
                % change this target's cluster by modifying its cluster index
                % if extra camera available, use it. Otherwise move it to a
                % different cluster
                if isempty(unusedCamIndices) == 1 
                    unusedCamCount = 0;
                else
                    unusedCamIndices
                    unusedCamCount = size(unusedCamIndices,2);
                end
                unusedCamIndices;
                if ( isempty(unusedCamIndices) == 0 )
                    best_cluster_ind = unusedCamIndices(1)
                    unusedCamIndices = unusedCamIndices(2:unusedCamCount)
                    Targets(uncovered_index).cluster_index = best_cluster_ind;
                else
                
                    % find a cluster whose mean is closer to this target
                    
                    Result = FindBestCluster(Clusters, Targets, uncovered_index, cams, cluster_cam_slopes, R_min, R_max, AOV);
                    best_cluster_ind = Result( 1 , 1);
                   
                    Targets(uncovered_index).cluster_index = best_cluster_ind;
                end

            end
            
            j = j + 1;
            complexity = complexity + 1;
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
    
    %if convergence accomplished, skip iterating
    complexity = complexity + 2;
    if ( uncoveredNum( iteration ) < uncovered_fraction_criterion * TargetCount )
        converged_flag = 1;
        break
    end
    
    % ConveragenceTestFunc finds out:
    % 1. Where is the optimal camera position
    % 2. Which targets cannot be covered in this cluster

    status = zeros( ClusterNum, TargetCount + 3 );
    coverage_status = zeros( ClusterNum, TargetCount ) - 1;
    cams = zeros( ClusterNum, 3 ) - 1;
    cluster_cam_slopes = zeros( ClusterNum );
    for clusterIndex = 1 : ClusterNum
        
        if ( clusterSize( iteration, clusterIndex ) ~= 0 ) 
            temp_vec = CoverageTestFunc(Targets, AOV_degree, R_min, R_max,Dim1_min,Dim2_min, Dim1_max, Dim2_max, clusterIndex); 
             
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
            complexity = complexity + 2;
            cams( i , axis_ind ) = status( i , count );
            axis_ind = axis_ind + 1;
        end
        cluster_cam_slopes( i ) = status( i , j + 4 );
       
    end
    
    
    
    iteration;
    uncoveredNum( iteration );
    converged_flag;
end
% figure;
% plot(uncoveredNum(1:iteration));
% xlabel('iteration');
% ylabel('# of uncovered targets');
% title(ClusterNum);
% title(['ClusterNum is ',num2str(ClusterNum)])
% figure;
% clusterSize
% plot(clusterSize);
%legend('cluster 1', 'cluster 2', 'cluster 3', 'cluster 4');

uncovered_num = uncoveredNum(iteration);    
result = [uncovered_num, complexity];

FinalCamPositions = [];
FinalCamOrients = [];
for i = 1 : size(cams,1)
    if cams(i,1) ~= -1
        FinalCamPositions = [FinalCamPositions; cams(i,:)];
        FinalCamOrients = [FinalCamOrients; cluster_cam_slopes(1,i)];
    end
end
FinalCamPositions;
FinalCamOrients;
uncovered_num;
UncoveredNumVec = uncovered_num*ones(size(FinalCamPositions,1),1);
ComplexityVec = complexity*ones(size(FinalCamPositions,1),1);
UncoveredNumVec;
Result = [FinalCamPositions , FinalCamOrients , UncoveredNumVec, ComplexityVec];
Result;

end




