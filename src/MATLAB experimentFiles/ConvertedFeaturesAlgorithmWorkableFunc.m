function Result = ConvertedFeaturesAlgorithmWorkableFunc(data,AOV_degree, R_min, R_max,Dim1_min, Dim1_max, Dim2_min, Dim2_max, max_iteration, uncovered_fraction_criterion, ClusterNum, TargetCount,coeff,margin)
% this file addresses clustering targets coverable by one camera
% initial number of cameras/clusters = max(dim_x, dim_y)/R_max




MAX_ITERATION = max_iteration;
complexity = 0;
%ClusterNum = 4; % initially
%coeff =0;

%data = GenerateData(Dim1_max, Dim2_max, TargetCount, seed);
ConvertedResults = ConvertedFeaturesAlgorithmFunc(data, TargetCount, ClusterNum, MAX_ITERATION, coeff);
ClusterIndex = ConvertedResults(1,:);
ConvertedComplexity = ConvertedResults(2,1);
complexity = complexity + ConvertedComplexity;

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
            complexity = complexity + 1;
        end
    end
end
Clusters;
sum(Clusters);
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
     temp_vec = CoverageTestFunc(Targets, AOV_degree, R_min, R_max, Dim1_min,Dim2_min, Dim1_max, Dim2_max, clusterIndex,margin); 
     for c = 1 : size( temp_vec, 2 )
         status( clusterIndex , c ) = temp_vec( c );
     end
end

% analyze the results of coverage algorithm
% for i = 1 : ClusterNum
%     j = 1;
%     while ( status( i , j ) ~= -1 )
%         j = j + 1;
%     end
%     for count = 1 : j - 1
%         coverage_status( i , count ) = status( i , count );
%     end
%     axis_ind = 1;
%     for count = j + 1 : j + 3
%         cams( i , axis_ind ) = status( i , count );
%         axis_ind = axis_ind + 1;
%     end
%     cluster_cam_slopes( 1, i ) = status( i , j + 4 );
% end
for i = 1 : ClusterNum
        if (sum(status(i,:),2) == (-1)*size(status,2))
            coverage_status(i, :) = status(i, :);
            cams(i,:) = [-1,-1,-1];
            cluster_cam_dirs(i,:) = [-1,-1,-1];
            
            %row corresponding to empty cluster 
        else
            j = 1;
            while ( (j <= TargetCount + 3) &&  (status( i , j ) ~= -1) )
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
            %cluster_cam_slopes( i ) = status( i , j + 4 );
            temp = 1;
            for k = j+4 : j+6
                cluster_cam_dirs( i , temp) = status(i,k);
                temp = temp + 1;
            end
        end
        %cluster_cam_dirs( i , :) = status(i, j + 4 : j + 6);
end
Clusters
ClusterNum
emptyRowChecker = sum(Clusters,2)
for i = 1 : size(Clusters,1)
    if (emptyRowChecker(i,1) == 0)
        %find the most crowded cluster and add this camera to that cluster
        [maxmembers, cluster_iter] = max(emptyRowChecker);
        
    end
end

%cams
%coverage_status
%cluster_cam_slopes
%plotting useful stuff:
uncoveredNum = 0;
for i = 1 : ClusterNum
        j = 1;
        while ( (j <=  TargetCount) & (coverage_status( i , j ) ~= -1) )
            if ( coverage_status( i , j ) == 0 )
                % target j of cluster i not covered
                uncovered_index = Clusters( i , j );
                uncoveredNum = uncoveredNum + 1;
                complexity = complexity + 2;
            end
            
            j = j + 1;
        end

        
end
    
ConvertedFeaturesComplexity = complexity;
Result = [uncoveredNum, complexity];
% figure;
% plot(uncoveredNum);
% xlabel('iteration');
% ylabel('# of uncovered targets');
% figure;
% plot(clusterSize);
% legend('cluster 1', 'cluster 2', 'cluster 3', 'cluster 4');

end 






