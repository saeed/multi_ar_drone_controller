%this function takes as input (1)the cluster membership of all targets
% and (2)the current location/direction of cameras assigned to each cluster
%and (3) the current location of all targets
%It outputs which targets are covered
function CoverageStatus = LightFuzzyCoverageTest(data, membership, Cams, AOV_degree, R_min, R_max, Dim1_min, Dim2_min, Dim1_max, Dim2_max, ClusterNum, TargetNum)
AOV = (AOV_degree * 2*pi)/360;
AOV_margin = 0.1 * AOV; % induced due to round-up errors
%Cams(1,:) = x_cam1, y_cam1, z_cam1, dir_x_cam1, dir_y_cam1, dir_z_cam1 -->covers cluster 1
%Cam(2,:) = x_cam2, y_cam2, z_cam2, slope_cam2 -->coveres cluster 2

for i = 1 : TargetNum
    Targets(i) =  TargetClassMultiCluster( data( 1,i ), data( 2,i ), data( 3,i ), 1, 1);
    Targets(i).cluster_index1 = membership(1,i);
    Targets(i).cluster_index2 = membership(2,i);
end
     
sum_projection = 0;
data_subset = [];
for j = 1 : ClusterNum
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
membership
CoverageStatus = ones( 1, TargetNum );
    
for i = 1 : TargetNum
     my_test_pt = [data(1,i), data(2,i), data(3,i)];
     cluster_index1 = Targets(i).cluster_index1;
     cluster_index2 = Targets(i).cluster_index2;
     CAM1 = Cams(cluster_index1 , 1:3);
     if (cluster_index2 == 0)
         cluster_index2 = cluster_index1;
     end
     CAM2 = Cams(cluster_index2 , 1:3);
     flag1 = 1;
     flag2 = 1;
     if (CAM1 ~= [-1,-1,-1])
         test_dist( i ) = EuclideanDist(my_test_pt, CAM1);
         if ((test_dist( i ) > R_max) ||  (test_dist( i ) < R_min))
             %CoverageStatus(1,i) = 0;
             flag1 = 0;
         end
         u =  my_test_pt - CAM1;   
         gamma = interAngle( u, cam_vec( cluster_index1, : ));
         if ( (gamma > AOV/2 + AOV_margin) || (gamma < - AOV/2 - AOV_margin) )
             %CoverageStatus( 1,i ) = 0;
             flag1 = 0;
         end
     end
     if (CAM2 ~= [-1,-1,-1])
         test_dist( i ) = EuclideanDist(my_test_pt, CAM2);
         if ((test_dist( i ) > R_max) ||  (test_dist( i ) < R_min))
             %CoverageStatus(1,i) = 0;
             flag2 = 0;
         end
         u =  my_test_pt - CAM2;   
         gamma = interAngle( u, cam_vec( cluster_index2, : ));
         if ( (gamma > AOV/2 + AOV_margin) || (gamma < - AOV/2 - AOV_margin) )
             %CoverageStatus( 1,i ) = 0;
             flag2 = 0;
         end
     end
     if (flag1 == 0 && flag2 == 0)
         CoverageStatus( 1,i ) = 0;
     end
end


end