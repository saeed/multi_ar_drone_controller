%this function takes as input (1)the cluster membership of all targets
% and (2)the current location/direction of cameras assigned to each cluster
%and (3) the current location of all targets
%It outputs which targets are covered
function CoverageStatus = LightCoverageTest(data, membership, Cams, AOV_degree, R_min, R_max, Dim1_min, Dim2_min, Dim1_max, Dim2_max, ClusterNum, TargetNum)
AOV = (AOV_degree * 2*pi)/360;
AOV_margin = 0.1 * AOV; % induced due to round-up errors
%Cams(1,:) = x_cam1, y_cam1, z_cam1, dir_x_cam1, dir_y_cam1, dir_z_cam1 -->covers cluster 1
%Cam(2,:) = x_cam2, y_cam2, z_cam2, slope_cam2 -->coveres cluster 2

for i = 1 : TargetNum
    Targets(i) = TargetClass( data( 1,i ), data( 2,i ), data( 3,i ), 1 );
    Targets(i).cluster_index = membership(1,i);
end
     
sum_projection = 0;
data_subset = [];
for j = 1 : ClusterNum
%     for i = 1 : TargetNum
%         if (membership(i) == j)
%             data_subset = [data_subset, data(:,i)];
%         end
%     end
%     CAM = Cams(j,1:3);
%     temp_pt(1,1) = CAM(1,1) + 1;
%     temp_pt(1,2) = CAM(1,2) + Cams(j,4)*1;
%     temp_pt(1,3) = 0;
%     cam_dir = temp_pt - CAM;
%     for k = 1 :size(data_subset,2)
%         my_test_pt = (data_subset(:,k))';
%         vec = my_test_pt - CAM;
%         sum_projection = sum_projection + dot(vec , cam_dir);
%     end
%     cam_dir;
%     if (sum_projection > 0)
%         cam_vec(j,:) = cam_dir;
%     else
%         cam_vec(j,:) = -cam_dir;
%     end
    temp = 1;
    for k = 4 : 6
        cam_vec(j, temp) = Cams(j,k);
        temp = temp + 1;
    end
    %cam_vec(j,:) = Cams(j, 4:6);
end
Cams;
ClusterNum;
cam_vec;
membership;
CoverageStatus = ones( 1, TargetNum );
    
for i = 1 : TargetNum
     my_test_pt = [data(1,i), data(2,i), data(3,i)];
     cluster_index = Targets(i).cluster_index;
     CAM = Cams(cluster_index , 1:3);
     if (CAM ~= [-1,-1,-1])
         test_dist( i ) = EuclideanDist(my_test_pt, CAM);
         if ((test_dist( i ) > R_max) ||  (test_dist( i ) < R_min))
             CoverageStatus(1,i) = 0;
         end
         u =  my_test_pt - CAM;   
         gamma = interAngle( u, cam_vec( cluster_index, : ));
         if ( (gamma > AOV/2 + AOV_margin) || (gamma < - AOV/2 - AOV_margin) )
             CoverageStatus( 1,i ) = 0;
         end
     end
end


end