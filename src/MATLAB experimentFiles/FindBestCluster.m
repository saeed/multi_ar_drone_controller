function result = FindBestCluster(Clusters, Targets, uncovered_index, cams, slopes, rmin, rmax, aov)
    
    complexity = 0;
    current_cluster = Targets(uncovered_index).cluster_index;
    UncoveredTarget = [ Targets(uncovered_index).x , Targets(uncovered_index).y , Targets(uncovered_index).z ];
    
    %special case: cluster of size one can cover any target within range of
    % [rmin, rmax]
    % count the members of each cluster
    member_count = zeros( 1, size(Clusters, 1));
%     for my_ind = 1 : size(Clusters, 1)% number of clusters
%         complexity = complexity + 1;
%         temp_cluster = Clusters( my_ind, :);
%         temp_size = size(Clusters , 2 );
%         for temp_ind = 1 : temp_size
%             complexity = complexity + 3;
%             if ( temp_cluster( 1 , temp_ind ) ~= 0 )
%                 member_count( 1, my_ind )  = member_count( 1, my_ind ) + 1;
%             end
%         end
%     end
    
    
    %check which clusters can cover this target?
    % if more than one, pick the closest cluster
    is_covered = zeros( 1, size( Clusters, 1 ) );
    for my_ind = 1 : size(Clusters, 1)% number of clusters
        complexity = complexity + 2;
        if ( my_ind ~= current_cluster )
            temp_cam = cams( my_ind , : );
            temp_slope = slopes( 1 , my_ind );
            complexity = complexity + 8;%euclidean dist and compare
            complexity = complexity + 7;% angle and compare
            is_covered( my_ind ) = CheckCoverage(UncoveredTarget, temp_cam, temp_slope, rmin, rmax, aov, member_count(1, my_ind));
        end
    end
    
    
    % decide on the best feasible cluster based on angular confidence
    % margin
    angular_separation = zeros( 1 , size( Clusters, 1 ) ) + 1000;
    angular_separation( current_cluster ) = 500; % if no cluster can cover it, stay in your current cluster
    foundCam_flag = 0;
    
     for my_ind = 1 : size(Clusters, 1)% number of clusters
         complexity = complexity + 3;
        if ( ( my_ind ~= current_cluster )  & ( is_covered( my_ind ) == 1 ) )
           temp_cam = cams( my_ind , : );
           temp_slope = slopes( 1 , my_ind );
           angular_separation( my_ind ) = AngularDist(UncoveredTarget, temp_cam, temp_slope, rmin, rmax, aov, member_count(1, my_ind));
           complexity = complexity + 6;
           foundCam_flag = 1;
        end
     end
    emptyRowChecker = sum(Clusters,2);
    unusedCamIndices = find( emptyRowChecker  == 0);
    if isempty(unusedCamIndices) == 1 
        unusedCamCount = 0;
    else
        unusedCamIndices
        unusedCamCount = size(unusedCamIndices,2);
    end
    if ((foundCam_flag == 0) & (unusedCamCount ~= 0)) %no feasible cluster
        %stay in your cluster!
        angular_separation( unusedCamIndices(1) ) = 0;
    end
    
    
    
    dist_to_target = zeros( 1 , size( Clusters, 1 ) ) + 100000;
%     for my_ind = 1 : size(Clusters, 1)% number of clusters
%         complexity = complexity + 3;
%         if ( ( my_ind ~= current_cluster )  & ( is_covered( my_ind ) == 1 ) )
%             members = Clusters( my_ind , : );
%             sum_x = 0; sum_y = 0; sum_z = 0; 
%             k = 1;
%             while ( (k <= size( members,2 )) & (Clusters( my_ind, k) ~= 0) )
%                 sum_x = sum_x + Targets( members(k)).x;
%                 sum_y = sum_y + Targets( members(k)).y;
%                 sum_z = sum_z + Targets( members(k)).z;
%                 k = k + 1;   
%                 complexity = complexity + 4;
%             end
%             
%             mean( my_ind , : ) = [sum_x/(k - 1 ), sum_y/(k -1), sum_z/(k-1)];
%             complexity = complexity + 3;
%             
%             %this does not do any good!! Change the criterion so that
%             %target moves to a cluster whose CAM pos is more probable to
%             %cover it
%             dist_to_target( my_ind ) = EuclideanDist( mean( my_ind , : ) , UncoveredTarget);
%             complexity = complexity + 7;
%             
%         else
%             dist_to_target( my_ind ) = 100000; % set this big so that old cluster is not selected again
%         end
%         
%     end
    
    %[dummy, cluster_ind] = min(dist_to_target);
    [dummy, cluster_ind] = min(angular_separation);
    %disp('complexity due to FindBestCluster ')
    complexity = complexity + size(angular_separation);
   
    result = [cluster_ind, complexity];
end

