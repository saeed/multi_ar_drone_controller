%ClusteredCoverageCreative(AOV_degree, R_min, R_max, Dim1_min, Dim2_min, Dim1_max, Dim2_max, max_iteration, uncovered_fraction_criterion, ClusterNum, TargetCount)

% this file addresses clustering targets coverable by one camera
% initial number of cameras/clusters = max(dim_x, dim_y)/R_max

AOV_degree = 45;
%AOV = (AOV_degree * 2*pi)/360; %60 degrees camera Angle of View
R_min = 0.0001;%0.01; % 0.5m
R_max = 25;%10;%30;%100; % 3m

% Dimensions of the area
Dim1_min = 0;%2;
Dim2_min = 0;%2;
Dim1_max = 50;%60;%200; %maximum in x-axis (m)
Dim2_max = 50;%60;%200; %maximum in y-axis (m)

TargetCount = 100;%20;%100;
% fraction of targets below which we allow uncovered targets
uncovered_fraction_criterion = 0.1; 
max_iteration = 50;
max_iteration_outer = 30;


AddComplexity = 0;
MultComplexity = 0;
CompComplexity = 0;
seed = 1;
AOV = (AOV_degree * 2*pi)/360; %60 degrees camera Angle of View
data = GenerateData(Dim1_max, Dim2_max, TargetCount, seed);

ClusterNum = 0;
iter = 0;
uncovered_num = TargetCount;
while ((uncovered_num > uncovered_fraction_criterion*TargetCount) && (iter < max_iteration_outer))
    ClusterNum = ClusterNum + 1;
    iter = iter + 1;
    


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
    for d_ind = 1 : TargetCount
        data_deviated(:,d_ind) = data(:,d_ind) + [0.1; 0.1; 0];
    end
    data_enhanced = [data, data_deviated];

    %S = zeros(2,2);
    %for i = 1 : TargetCount
    %    S = S + ( my_data( : , i ) - mean )*( my_data( : , i ) - mean )';
    %end

    %[V,D] = eig(S)
    %eigenVectors = V;
    %spreadRatio = min(D(1,1),D(2,2))/max(D(1,1),D(2,2));

    for i = 1 : 2*TargetCount
        Targets(i) = TargetClass( data_enhanced( 1,i ), data_enhanced( 2,i ), data_enhanced( 3,i ), 1 );
        for j = 1 : ClusterNum
            if ( data_enhanced( 2,i ) > ( j - 1 ) * Dim2_max/ClusterNum & ( data_enhanced( 2 , i ) < j * Dim2_max/ClusterNum ))
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
        for j = 1 : 2*TargetCount
            if ( Targets(j).cluster_index == i )
                members_count = members_count + 1;
                Clusters( i, members_count) = j;
            end
        end
    end




    Clusters;
    ClusterNum = size(Clusters,1);% some cams may not have been used!
    complexity = CompComplexity + AddComplexity + MultComplexity; 
    % From matrix Clusters, form Target list for each cluster
    % Feed this list to CoverageTestFunc


    % ConveragenceTestFunc finds out:
    % 1. Where is the optimal camera position
    % 2. Which targets cannot be covered in this cluster

    status = zeros( ClusterNum, 2*TargetCount + 3 );
    coverage_status = zeros( ClusterNum, 2*TargetCount ) - 1;
    target_coverage_status = zeros(1, 2*TargetCount);
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
        target_coverage_status = zeros(1, 2*TargetCount);
        for i = 1 : ClusterNum
            j = 1;
            complexity = complexity + 3;


            while ( (j <=  2*TargetCount) & (coverage_status( i , j ) ~= -1) )
                if ( coverage_status( i , j ) == 1 )
                    covered_index = Clusters( i , j );
                    target_coverage_status(covered_index) = 1;
                elseif ( coverage_status( i , j ) == 0)
                    % target j of cluster i not covered
                    uncovered_index = Clusters( i , j );% target uncovered_index not covered
                    if uncovered_index < (TargetCount + 1)
                        uncoveredNum( iteration ) = uncoveredNum( iteration ) + 1;
                    end
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
                        complexity = complexity + 1;
                        Result = FindBestCluster(Clusters, Targets, uncovered_index, cams, cluster_cam_slopes, R_min, R_max, AOV);
                        best_cluster_ind = Result( 1 , 1);
                        complexity = complexity + Result( 1 , 2 );
                        Targets(uncovered_index).cluster_index = best_cluster_ind;
                    end

                end

                j = j + 1;
                complexity = complexity + 1;
            end

        end

        %reset Clusters matrix
        for i = 1 : ClusterNum
            complexity = complexity + 1;
            for j = 1 : 2*TargetCount
                complexity = complexity + 1;
                Clusters( i , j ) = 0;
            end
        end


        % update Clusters matrix with new memberships
        for i = 1 : ClusterNum
            complexity = complexity + 1;
            members_count = 0;
            for j = 1 : 2*TargetCount
            complexity = complexity + 1;
                if ( Targets(j).cluster_index == i )
                    complexity = complexity + 1;
                    members_count = members_count + 1;
                    complexity = complexity + 1;
                    Clusters( i, members_count) = j;
                end
            end
        end

    %     % check if one cluster has no member
        clusterSize( iteration , : ) = zeros( 1, size( Clusters, 2 ));
        for i = 1 : ClusterNum
            complexity = complexity + 1;
            for j = 1 : size(Clusters, 2 )
                complexity = complexity + 2;
                if ( Clusters( i , j ) ~= 0 )
                    clusterSize( iteration , i) = clusterSize( iteration , i) + 1;
                end
            end
        end

        %if convergence accomplished, skip iterating
        complexity = complexity + 2;
        if ( uncoveredNum( iteration ) < uncovered_fraction_criterion * 2*TargetCount )
            converged_flag = 1;
            break
        end

        % ConveragenceTestFunc finds out:
        % 1. Where is the optimal camera position
        % 2. Which targets cannot be covered in this cluster

        status = zeros( ClusterNum, 2*TargetCount + 3 );
        coverage_status = zeros( ClusterNum, 2*TargetCount ) - 1;
        cams = zeros( ClusterNum, 3 ) - 1;
        cluster_cam_slopes = zeros( ClusterNum );
        for clusterIndex = 1 : ClusterNum
            complexity = complexity + 2;
            if ( clusterSize( iteration, clusterIndex ) ~= 0 ) 
                temp_vec = CoverageTestFunc(Targets, AOV_degree, R_min, R_max,Dim1_min,Dim2_min, Dim1_max, Dim2_max, clusterIndex); 

                for c = 1 : size( temp_vec, 2 )
                    complexity = complexity + 1;
                    status( clusterIndex , c ) = temp_vec( c );
                end
            else
                status( clusterIndex , : ) = - 1;
            end

        end

        % analyze the results of coverage algorithm
        for i = 1 : ClusterNum
            j = 1;
            complexity = complexity + 3;
            while ( (j <= 2*TargetCount + 3) &  (status( i , j ) ~= -1) )
                j = j + 1;
            end
            for count = 1 : j - 1
                complexity = complexity + 1;
                coverage_status( i , count ) = status( i , count );
            end
            axis_ind = 1;
            for count = j + 1 : j + 3
                complexity = complexity + 2;
                cams( i , axis_ind ) = status( i , count );
                axis_ind = axis_ind + 1;
            end
            cluster_cam_slopes( i ) = status( i , j + 4 );
            complexity = complexity + status( i , j + 5 );
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



    uncovered_num = uncoveredNum(iteration) ; 

    for i = 1 : TargetCount
        if ((target_coverage_status(1,i) == 0) & (target_coverage_status(1,i+TargetCount) == 1))
            uncovered_num = uncovered_num - 1;
        end
    end

end
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
uncovered_num
UncoveredNumVec = uncovered_num*ones(size(FinalCamPositions,1),1);
ComplexityVec = complexity*ones(size(FinalCamPositions,1),1);
UncoveredNumVec;
Result = [FinalCamPositions , FinalCamOrients , UncoveredNumVec, ComplexityVec];
Result;





