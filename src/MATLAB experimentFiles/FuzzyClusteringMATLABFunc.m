%function uncoveredNum = FuzzyClusteringMATLABFunc(data, AOV_degree, R_min, R_max, Dim1_min, Dim1_max, Dim2_min, Dim2_max, max_iteration, uncovered_fraction_criterion, ClusterNum, TargetCount, coeff, blend, multi_class_probability)
function Result = FuzzyClusteringMATLABFunc(data, AOV_degree, R_min, R_max, Dim1_min, Dim1_max, Dim2_min, Dim2_max, max_iteration, uncovered_fraction_criterion, ClusterNum, TargetCount, coeff, blend, multi_class_probability)
data 
 [center, U, obj_fcn] = fcm(data', ClusterNum);
 U
 
 for i = 1 : TargetCount
        Targets(i) = TargetClassMultiCluster( data( 1,i ), data( 2,i ), data( 3,i ), 0,0);
        candidates = U(:,i);
        [best, I_best] = max(U(:,i));
        
        Targets(i).cluster_index1 =  I_best;  %ClusterIndex(1,i);
        %find the next best
         max_val = U(1,i);
         max_I = 1;
        for k = 1 : size(U,1)
            if ((U(k,i) > max_val) & (k ~= I_best))
                max_val = U(k,i);
                max_I = k;
            end    
        end
        if (U(max_I, i) > 1 - multi_class_probability)
            Targets(i).cluster_index2 = max_I;
        else 
            Targets(i).cluster_index2 = 0;
        end
 end
 
  Clusters = zeros( ClusterNum , TargetCount);
    for i = 1 : ClusterNum
        members_count = 0;
        for j = 1 : TargetCount
            if ( Targets(j).cluster_index1 == i )
                members_count = members_count + 1;
                Clusters( i, members_count) = j;
            end
            if ( Targets(j).cluster_index2 == i )
                members_count = members_count + 1;
                Clusters( i, members_count) = j;
            end
        end
    end
    
    status = zeros( ClusterNum, TargetCount + 3 );
coverage_status = zeros( ClusterNum, TargetCount ) - 1;
cams = zeros( ClusterNum, 3 ) - 1;
cluster_cam_slopes = zeros( 1, ClusterNum );
for clusterIndex = 1 : ClusterNum
     temp_vec = CoverageTestMultiClusterFunc(Targets, AOV_degree, R_min, R_max, Dim1_min,Dim2_min, Dim1_max, Dim2_max, clusterIndex); 
     
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
    axis_ind = 1;%x, y, z
    for count = j + 1 : j + 3
        cams( i , axis_ind ) = status( i , count );
        cam_dirs(i, axis_ind) = status(i, count + 3);
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
            end           
            j = j + 1;
        end       
end
FinalCamPositions = [];
FinalCamOrients = [];
FinalCamDirections = [];
for i = 1 : size(cams,1)
    %if cams(i,1) ~= -1
        FinalCamPositions = [FinalCamPositions; cams(i,:)];
        %FinalCamOrients = [FinalCamOrients; cluster_cam_slopes(1,i)];
        FinalCamDirections = [FinalCamDirections; cam_dirs(i, :)];
    %end
end
FinalCamPositions;
FinalCamDirections;
FinalCamOrients;
uncoveredNum;
UncoveredNumVec = uncoveredNum*ones(size(FinalCamPositions,1),1);
%ComplexityVec = complexity*ones(size(FinalCamPositions,1),1);
UncoveredNumVec;

for i = 1 : TargetCount
    Membership(1,i) = Targets(i).cluster_index1;
    Membership(2,i) = Targets(i).cluster_index2;
end
Membership;
%Result = [FinalCamPositions , FinalCamOrients , UncoveredNumVec, ComplexityVec];
Result = [FinalCamPositions , FinalCamDirections , UncoveredNumVec];
Result(: , 8 : TargetCount) = 0;
Result = [Result; zeros(1,TargetCount)-2];
Result = [Result; Membership(1,:); Membership(2,:)];
%Result(ClusterNum+1,:) = Membership(1,:);
Result;
 
end