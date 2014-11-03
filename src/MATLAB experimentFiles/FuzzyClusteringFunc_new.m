function uncoveredNum = FuzzyClusteringFunc_new(seed,AOV_degree, R_min, R_max, Dim1_max, Dim2_max, max_iteration, uncovered_fraction_criterion, ClusterNum, TargetCount, coeff, blend, multi_class_probability)

    %FuzzyClustering
    %blend = 2;
    %ClusterNum = 7;
    minimum_dist = 0.01;
    MAX_PROB = multi_class_probability;

    %AOV_degree = 45;
    % AOV = (AOV_degree * 2*pi)/360; %60 degrees camera Angle of View
    %R_min = 0.0001;%0.01; % 0.5m
    %R_max = 15; % 3m

    % Dimensions of the area
    %Dim1_min = 0;
    %Dim2_min = 0;
    %Dim1_max = 31; %maximum in x-axis (m)
    %Dim2_max = 31; %maximum in y-axis (m)


    % OR using random data
    %TargetCount = 30;
    % fraction of targets below which we allow uncovered targets
    %UNCOVERED_FRACTION_CRITERION = 0.2; 
    MAX_ITERATION = max_iteration;


    coeff = 100;% to scale angle and magnitude 
    % if maximum probability of belonging to a class is above this value, only belong to one class
    %otherwise, allow membership in two classes

    P = zeros(ClusterNum, TargetCount);

    data = GenerateData(Dim1_max, Dim2_max, TargetCount, 3);
    my_data = data(1:2,:);

    %convert the data
    for i = 1 : size(my_data,2)
        temp = my_data( : , i );
        f1 = coeff*atan(temp(2)/temp(1));
        f2 = ((temp(1)).^2 + (temp(2)).^2).^0.5;
        converted_data( : , i ) = [f1;f2];
    end
    converted_data;

    %1. Pick the first set of means randomly
    mean_vec = zeros( 2 , ClusterNum );

    for i = 1 : ClusterNum
        r1 = randi( [round((i - 1)*Dim1_max/ClusterNum) round((i)*Dim1_max/ClusterNum)], 1);
        r2 = randi([0 Dim2_max],1);
        mean_vec( 1 , i ) = coeff*atan(r2/r1);
        mean_vec( 2 , i ) = sqrt((r1)^2 + (r2)^2);
        %mean_vec( 1 , i ) = r1;
        %mean_vec( 2 , i ) = r2;
    end
    mean_vec;
    % 2. Use fuzzy-kmeans over converted data to find better performance

    Mean_Vector_x = zeros( ClusterNum , MAX_ITERATION );
    Mean_Vector_y = zeros( ClusterNum , MAX_ITERATION );

    for iter = 1 : MAX_ITERATION
        sum_prob = zeros( 1 , TargetCount);
        for j = 1 : TargetCount
            for i = 1 : ClusterNum
               %dist = EuclideanDist2( mean_vec( : , i ) , my_data( :  , j ) );
               dist = EuclideanDist2( mean_vec( : , i ) , converted_data( :  , j ) );
               if (dist <= minimum_dist)
                   sum_prob( 1 , j ) = sum_prob( 1 , j ) + 1;
               else
                   sum_prob( 1 , j ) = sum_prob( 1 , j ) + ((1/dist).^(1/(blend-1)));
               end
            end
        end
        sum_prob;
        for i = 1 : ClusterNum
            for j = 1 : TargetCount
                %dist = EuclideanDist2( mean_vec(:,i) , my_data(:,j) );
                dist = EuclideanDist2( mean_vec( : , i ) , converted_data( : , j) );
                dist;
                if dist < minimum_dist
                    P( i , j ) = 1;
                else
                    dist_inv = 1/dist;
                    sum_prob(1,j);
                    P( i , j ) = ( (1/dist).^(1/(blend-1)) )/sum_prob(1,j);
                    P(i,j);
                end
            end
        end
        P;
        % find the new mean vector
        sum_vec = zeros( 1 , ClusterNum );
        for i = 1 : ClusterNum
            for j = 1 : TargetCount
                sum_vec( 1 , i ) =  sum_vec( 1 , i ) + (P( i , j )).^blend;
            end
        end

        weighted_sum_vec = zeros( 2 , ClusterNum );
        for i = 1 : ClusterNum
            for j = 1 : TargetCount
                %weighted_sum_vec( : , i ) = weighted_sum_vec( : , i ) + ((P( i , j )).^blend).*my_data( : , j );
                weighted_sum_vec( : , i ) = weighted_sum_vec( : , i ) + ((P( i , j )).^blend).*converted_data( : , j );
            end
        end

        for i = 1 :  ClusterNum
            mean_vec( : , i ) = weighted_sum_vec( : , i ) ./ sum_vec( 1 , i );
        end
        Mean_Vector_x( : , iter ) = mean_vec( 1 , :);
        Mean_Vector_y( : , iter ) = mean_vec( 2 , :);
    end

    % at the end of this, each target has a probability to belong to each
    % cluster
    % we decide 

    max_prob1 = 0;
    max_prob2 = 0;

    % each target can be a member of a maximum of two clusters
    ClusterIndex = zeros(2, TargetCount);

    for i = 1 : TargetCount

        [max_prob1 , max_prob1_ind] = max(P(: , i));

        max_prob2_ind = 0;
        max_prob2 = 0;

        for k = 1 : ClusterNum
            if ((k ~= max_prob1_ind) & (P( k , i ) > max_prob2) )
               max_prob2 = P( k , i );
               max_prob2_ind = k;
            end
        end
        % max_prob2_ind is the index of the second best cluster
        ClusterIndex(1,i) = max_prob1_ind;
        if (max_prob1 < multi_class_probability)
            ClusterIndex(2,i) = max_prob2_ind;
        end
    end

    % plot mean vector
%     figure;
%     for i = 1 : ClusterNum
%         plot(Mean_Vector_x(i,:));  
%         hold on;
%         %figure;
%         plot(Mean_Vector_y(i,:));
%         hold on;
%         legend;
%     end


    for i = 1 : TargetCount
        Targets(i) = TargetClassMultiCluster( data( 1,i ), data( 2,i ), data( 3,i ), 0,0);
        Targets(i).cluster_index1 = ClusterIndex(1,i);   
        Targets(i).cluster_index2 = ClusterIndex(2,i);
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

    %Use these cluster indices in finding camera position
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
         temp_vec = CoverageTestMultiClusterFunc(Targets, AOV_degree, R_min, R_max, clusterIndex); 
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

    targets_coverage = zeros(1, TargetCount);

    %plotting useful stuff:
    uncoveredNum = 0;
    for i = 1 : ClusterNum
        j = 1;
        while ( (j <=  TargetCount) & (coverage_status( i , j ) ~= -1) )
            if ( coverage_status( i , j ) == 1 )
                % target j of cluster i not covered
                covered_index = Clusters( i , j );
                targets_coverage(covered_index) = 1;
            end

            j = j + 1;
        end        
    end

    for i = 1 : TargetCount
        if (targets_coverage(i) ~= 1 )
            uncoveredNum = uncoveredNum + 1;
        end
    end
    uncoveredNum
end

