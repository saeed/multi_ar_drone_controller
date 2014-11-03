function Result = ConvertedFeaturesAlgorithmFunc(data,AOV_degree, R_min, R_max,Dim1_min, Dim1_max, Dim2_min, Dim2_max, max_iteration, uncovered_fraction_criterion, ClusterNum, TargetCount,coeff)
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
     temp_vec = CoverageTestFunc(Targets, AOV_degree, R_min, R_max, Dim1_min,Dim2_min, Dim1_max, Dim2_max, clusterIndex); 
     complexity = complexity + 15*TargetCount;
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


ConvertedFeaturesComplexity = complexity;
%Result = [uncoveredNum, complexity];
UncoveredNumVec = uncoveredNum*ones(size(FinalCamPositions,1),1);
ComplexityVec = complexity*ones(size(FinalCamPositions,1),1);
UncoveredNumVec;
Result = [FinalCamPositions , FinalCamOrients , UncoveredNumVec, ComplexityVec];
%Result

% figure;
% plot(uncoveredNum);
% xlabel('iteration');
% ylabel('# of uncovered targets');
% figure;
% plot(clusterSize);
% legend('cluster 1', 'cluster 2', 'cluster 3', 'cluster 4');

end 






