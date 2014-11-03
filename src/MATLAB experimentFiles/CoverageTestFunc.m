function coverage_status = CoverageTestFunc( targets, AOV_degree, Rmin, Rmax,Dim1_min,Dim2_min, Dim1_max, Dim2_max, clusterIndex, margin )

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %INITIALIZATION
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    AddComplexity = 0;
    MultComplexity = 0;
    CompComplexity = 0;
    complexity = 0;
    
    % AOV and Depth (FOV)
   
    AOV = (AOV_degree * 2*pi)/360; %60 degrees camera Angle of View
    R_min = Rmin; % 0.5m
    R_max = Rmax; % 3m


    currentClusterSize = 0;
    for i = 1 : size(targets,2)
        if ( targets(i).cluster_index == clusterIndex )
            currentClusterSize = currentClusterSize + 1;
            X( 1 , currentClusterSize ) = targets(i).x;
            Y( 1 , currentClusterSize ) = targets(i).y;
            Z( 1 , currentClusterSize ) = targets(i).z;
        end
    end
    
    CoverageStatus_dummy = [-1];
    %CAM_dummy = [ -1 , -1 , -1 ];
    CAM_dummy  = [margin, margin, 0];
    best_line_slope_dummy = 0;
    best_line_dir_dummy = [1,0];
    
    coverage_status = [CoverageStatus_dummy, -1, CAM_dummy, best_line_dir_dummy, complexity ];
    
    
    if ((size(targets,2) == 0) || (currentClusterSize == 0))
        return
    end
    
    TargetNum = size(X,2);
    
   
    
    if ( ( TargetNum > 0 )  &  ( TargetNum < 2 ) )
        CoverageStatus = 1;
        CAM = [max( X( 1, TargetNum) - R_min, margin) , Y( 1, TargetNum), Z( 1, TargetNum)];
        coverage_status = [CoverageStatus , -1, CAM, best_line_dir_dummy, complexity];
    end
    
    if ( TargetNum < 2 )
        return
    end

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %DATA FITTING
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %find the line best approximating (X,Y): Y = f(X)= p1.X + p2
    %X
    %Y
    
    [p,S,mu] = polyfit(X, Y, 1);
    if (mu(2,1) == 0 )
       p(1) = 100;
    else
       p = polyfit(X,Y,1);
    end
    p;
    f = polyval(p,X);
   
    X;
    Y;
    %figure;
    %plot(X,Y, 'o',X,f,'-y'); 
    %plot(X,Y, 'o'); hold on;
    %figure;
    %plot(X,f,'-y'); 
    %axis([-10 200 -10 200]);
    
    best_fit_angle = atan(p(1)); % angle of the line in radians
    
    if (best_fit_angle < 0) 
        best_fit_angle = pi + best_fit_angle;
    end
    best_line_slope = p(1);
    best_shift = p(2);
    
    best_fit_angle_orth = (pi/2) + best_fit_angle;
    if (best_fit_angle_orth > pi)
        best_fit_angle_orth = best_fit_angle_orth - pi;
    end
    best_line_slope_orth = tan(best_fit_angle_orth);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %calculate sigma_x (a) and sigma_y (b) and compare the ellipse formula
%     if (mu(2,1) ~= 0)
%         sigma_x = mu(2,1);
%     else
%         sigma_x = 0.1; % a small artificial value
%     end
    
    Y_hat = p(1).*X + p(2);
    dev1 = 0;
    dev2 = 0;
    
    for count = 1 : size(X,2)
        my_pt = [X(count),Y(count),0];
        my_v1 = [X(count),p(1)*X(count)+p(2),0];
        my_v2 = [0,p(2),0];
        dev2 = dev2 + (point_to_line(my_pt, my_v1,my_v2)).^2;
        projected_point = projection(my_pt, my_v1,my_v2);
        dev1 = dev1 + (mean(X)-projected_point(1,1))^2 + (mean(Y)-projected_point(1,2))^2;
    end
    sigma_x = sqrt(dev1);
    sigma_y = sqrt(dev2);
    
    d1_max = sigma_x + sqrt(sigma_x^2 + sigma_y^2/(tan(AOV/2))^2);
    d2_max = sigma_y + sqrt(sigma_y^2 + sigma_x^2/(tan(AOV/2))^2);
    
    if (d1_max > Rmax  & d2_max < Rmax)
    %if (d2_max < Rmax)%prefere the orthogonal!
       best_line_slope =  best_line_slope_orth;
       best_fit_angle = best_fit_angle_orth;
       best_shift = mean(Y) - mean(X)*best_line_slope;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Find the edge objects with most distance to the approximating line
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    P_x = X(1);
    P_y = best_line_slope *X(1) + best_shift ;%f(1);
%     if (best_fit_angle == pi/2)
%         f(1) = Y(1) + 1;
%         f(2) = Y(1) + 2;
%     end
    
    %v1 = [X(1), f(1), 0]; % sample point 1 on best fit line
    v1 = [X(1), best_line_slope *X(1) + best_shift , 0];
    %v2 = [X(2), f(2), 0]; % sample point 2 on best fit line
    %v2 = [X(2), best_line_slope *X(2) + best_shift , 0];
    v2 = [X(1)+1, best_line_slope *(X(1) + 1) + best_shift , 0];
    pt = [X(1), Y(1), 0];
   
    %dist = point_to_line(pt,v1,v2)
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % METHOD 2: find the upper and lower supporting hyperplanes 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % For this, 
    %We try to find the edge point in the direction of line with AOV/2 anle:
    % 1) Make a line orthogonal to the line that has AOV/2 angle with best fit
    % 2) Project all data point on this line and find the min and max 
    % 3) The min and max are the edge points, i.e all points reside on one side
    % of the line that goes through the edge point at angle AOV/2 relative to 
    % best fit line
    % 4) Pass a line through the edge points with angle AOV/2 relative to
    % best fit line
    % 5) The intersection of this line with best fit is a candidate for camera
    % position.
    % 6) Select the candidate point whose avg distance to other points is
    % smaller. Or just has smaller distance to avg point.

    % line with angle AOV/2 to best fit line has angle AOV/2 +/- best_fit_angle

    mean_x = mean(X);
    mean_y = mean(Y);
    mean_z = mean (Z);
    avg = [ mean_x, mean_y, mean_z ];
    % case 1 is for acute angle of best fit line
    % case 2 is for obtuse angle of best fit line
    Case = zeros( 1,2 ); 

    if ( ( best_fit_angle  < pi/2 ) & ( best_fit_angle > 0 ) )
        Case(1) = 1;
    else
        Case(2) = 1;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % address the degenerate case of two points:
    if ( TargetNum == 2 )
        if (X(1) < X(2))
            smaller = 1;
            bigger = 2;
        else
            smaller = 2;
            bigger = 1;
        end
        vertical_flag = 0;
        dist = EuclideanDist( [X( 1 ), Y( 1 ), Z( 1 )], [X( 2 ), Y( 2 ), Z( 2 )] );
        p = polyfit(X,Y,1);
        if p(1,1) ~= best_line_slope
            vertical_flag = 1;
        end
        if ( (dist > R_max)  && (dist > 2*R_max * sin(AOV/2)))
            farness = dist - R_max
            if (X(1) - R_min > margin)
                CAM = [ X( 1 ) - R_min , Y( 1 ), Z( 1 )];
                coverage_status = [ 1, 0, -1, CAM , 1, p(1,1), complexity];
                return
            elseif (X(2) + R_min < Dim1_max - margin)
                CAM = [ X( 2 ) + R_max , Y( 2 ), Z( 2 )];
                coverage_status = [ 1, 0, -1, CAM , -1, -p(1,1), complexity];
                return
            else
                CAM = [ Dim1_max - margin , Y( 2 ), Z( 2 )];
                coverage_status = [ 1, 0, -1, CAM , -1, -p(1,1), complexity];
                return
            end
        elseif ((dist > R_max) && (dist < 2*R_max * sin(AOV/2)) && (p(1,1) > 0))
            CAM_1x = X(smaller) + (dist/(2*sin(AOV/2)))*cos(pi/2-atan(p(1,1)) - AOV/2); 
            CAM_1y = Y(smaller) - (dist/(2*sin(AOV/2)))*sin(pi/2-atan(p(1,1)) - AOV/2); 
            CAM_2x = X(bigger) - (dist/(2*sin(AOV/2)))*cos(pi/2-atan(p(1,1)) - AOV/2); 
            CAM_2y = Y(bigger) + (dist/(2*sin(AOV/2)))*sin(pi/2-atan(p(1,1)) - AOV/2); 
            if (IsInRange( CAM_1x, CAM_1y, Dim1_min, Dim2_min, Dim1_max, Dim2_max, margin ) == 1)
                CAM = [CAM_1x, CAM_1y, 0];
            else
                CAM = [CAM_2x, CAM_2y, 0];
            end

        elseif ((dist > R_max) && (dist < 2*R_max * sin(AOV/2)) && (p(1,1) < 0))
            CAM_1x = X(bigger) + (dist/(2*sin(AOV/2)))*cos(atan(p(1,1)) + AOV/2 - pi/2); 
            CAM_1y = Y(bigger) + (dist/(2*sin(AOV/2)))*sin(atan(p(1,1)) + AOV/2 - pi/2);
            CAM_2x = X(smaller) - (dist/(2*sin(AOV/2)))*cos(atan(p(1,1)) + AOV/2 - pi/2);
            CAM_2y = Y(smaller) - (dist/(2*sin(AOV/2)))*sin(atan(p(1,1)) + AOV/2 - pi/2);
            if (IsInRange( CAM_1x, CAM_1y, Dim1_min, Dim2_min, Dim1_max, Dim2_max, margin ) == 1)
                CAM = [CAM_1x, CAM_1y, 0];
            else 
                CAM = [CAM_2x, CAM_2y, 0];  
            end
            
        end
        
        best_fit_angle
        best_line_slope
        
        %if (vertical_flag == 0) 
        if (p(1,1) >= 0)
            x_CAM1 = X( smaller ) - R_min * cos( atan(p(1,1)));
            y_CAM1 = Y(smaller ) - R_min * sin( atan(p(1,1)));
            x_CAM2 = X(bigger) + R_min*cos( atan(p(1,1)));
            y_CAM2 = Y(bigger) + R_min*sin(atan(p(1,1)));
        else
            x_CAM1 = X(smaller) - R_min*abs(cos(atan(p(1,1))));
            y_CAM1 = Y(smaller ) + R_min * sin( atan(p(1,1)));
            x_CAM2 = X(bigger) + R_min*abs(cos( atan(p(1,1))));
            y_CAM2 = Y(bigger) - R_min*sin(atan(p(1,1)));
        end
        z_CAM = 0;
        inRange1 = IsInRange(x_CAM1, y_CAM1,Dim1_min, Dim2_min, Dim1_max, Dim2_max, margin );
        inRange2 = IsInRange(x_CAM2, y_CAM2,Dim1_min, Dim2_min, Dim1_max, Dim2_max, margin );
        if (inRange1 == 1)
            x_CAM = x_CAM1;
            y_CAM = y_CAM1;
            camera_direction = [ 1, p(1,1), 0];
        else
            x_CAM = x_CAM2;
            y_CAM = y_CAM2;
            camera_direction = [-1, -p(1,1),0];
        end
        %camera_direction = [ 1, p(1,1), 0];
%         if ((x_CAM < margin) || (x_CAM > Dim1_max-margin) || (y_CAM < margin) || (y_CAM > Dim2_max - margin))
%             x_CAM = X( bigger ) + R_min * cos( atan(p(1,1)));
%             y_CAM = Y(bigger ) + R_min * sin( atan(p(1,1)));% + p(1,2);
%             camera_direction = [-1, -p(1,1),0];
%         end
        %y_CAM = best_line_slope * x_CAM + best_shift
        z_CAM = 0;
        coverage_status = [ 1, 1, -1, x_CAM, y_CAM, z_CAM, camera_direction(1), camera_direction(2), camera_direction(3), complexity];
        return
%         else
%             x_inter = (X(1) + X(2))/2;
%             y_inter = (Y(1) + Y(2))/2;
%             x_CAM = X(2) + (dist/(2*sin(AOV/2)))*cos(atan(p(1,1)+AOV/2-pi/2);
%             y_CAM = Y(2) + (dist/(2*sin(AOV/2)))*sin(atan(p(1,1)+AOV/2-pi/2);
%             z_CAM = 0;
%             coverage_status = [ 1, 1, -1, x_CAM, y_CAM, z_CAM, 1, best_line_slope, complexity];
%             return
%         end
    end
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if ( Case(1) == 1 )
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        %Now for the camera line with + AOV/2 angle with main line
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        slope_pos = tan( pi/2 + AOV/2 + best_fit_angle );
        V1 = [ 0, 0, 0 ];
        V2 = [ 1, slope_pos, 0 ];
        x_axis_pt1 = [ 0, 0, 0 ];
        x_axis_pt2 = [ 1, 0, 0 ];
        for i = 1 : TargetNum
           test_pt = [ X(i), Y(i), 0 ];
           proj_points_1( i , : ) = projection( test_pt, V1, V2 );
           % Now find which two points from the projection list are min an max
           % Project these points on x_axis
           %proj_points_on_x2 ( i , : ) = proj_points_2( i, 1) * cos( pi/2 + AOV/2 + best_fit_angle ); % corrected this! Correct others!
           proj_points_on_x1 ( i , : ) = projection( proj_points_1( i, : ),  x_axis_pt1,  x_axis_pt2 );
           AddComplexity = AddComplexity + 2;
           MultComplexity = MultComplexity + 2;

        end
        [ edge_1, I_1 ] = max( proj_points_on_x1 );
        [ edge_2, I_2 ] = min( proj_points_on_x1 );
        edgePoint_1 = [ X(I_1(1)), Y(I_1(1)), Z(I_1(1)) ];
        edgePoint_2 = [ X(I_2(1)), Y(I_2(1)), Z(I_2(1)) ];
        %plot(edgePoint_1(1), edgePoint_1(2) , 'x'); hold on;
        %plot(edgePoint_2(1), edgePoint_2(2) , 'x'); hold on;

        %plot([-12, V1(1), V2(1) , 12 ], [-12*slope_pos, V1(2), V2(2), slope_pos * 12 ] , 'm'); hold on; 

         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %for camera line with - AOV/2 angle with main line
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Pass a line through origin with angle pi/2-AOV/2+best_fit_angle
        slope_neg = tan( pi/2 - AOV/2  + best_fit_angle );
        %p2 = [slope_up, 0];
        V3 = [ 0, 0, 0 ];
        V4 = [ 1, slope_neg, 0 ];
        x_axis_pt1 = [ 0, 0, 0 ];
        x_axis_pt2 = [ 1, 0, 0 ];

        for i = 1 : TargetNum
            test_pt = [X(i), Y(i), 0];
            proj_points_2( i , : ) = projection(test_pt, V3, V4);
            % Now find which two points from the projection list are min an max
            % Project these points on x_axis
            %proj_points_on_x1 ( i , : ) = proj_points_1( i, 1) * cos( pi/2 - AOV/2 + best_fit_angle ); %Azin: correct this!
            proj_points_on_x2 ( i , : ) = projection( proj_points_2( i, : ),  x_axis_pt1,  x_axis_pt2 );
            AddComplexity = AddComplexity + 2;
            MultComplexity = MultComplexity + 2;
        end
        [ edge_1, I_3 ]= max( proj_points_on_x2 );
        [ edge_2, I_4 ] = min( proj_points_on_x2 );
        edgePoint_3 = [ X(I_3(1)), Y(I_3(1)), Z(I_3(1)) ];
        edgePoint_4 = [ X(I_4(1)), Y(I_4(1)), Z(I_4(1)) ];
        %plot(edgePoint_3(1), edgePoint_3(2) , 'x'); hold on;
        %plot(edgePoint_4(1), edgePoint_4(2) , 'x'); hold on;

        %plot([ -12, V3(1), V4(1) , 12 ], [ -12 * slope_neg, V3(2), V4(2), slope_neg * 12 ] , 'g'); hold on; 

    else % if Case (2) == 1
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %for camera line + AOV/2 angle with main line
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         % Pass a line through origin with angle AOV/2 - 180 + best_fit_angle
        slope_up = tan( best_fit_angle + AOV/2 - pi / 2 );
        %p2 = [slope_up, 0];
        V1 = [ 0, 0, 0 ];
        V2 = [ 1, slope_up, 0 ];
        x_axis_pt1 = [0, 0, 0];
        x_axis_pt2 = [1, 0, 0];

        for i = 1 : TargetNum
            test_pt = [ X(i), Y(i), 0 ];
            proj_points_1( i , : ) = projection(test_pt, V1, V2);
            % Now find which two points from the projection list are min an max
            % Project these points on x_axis
            %proj_points_on_x ( i , : ) = proj_points_1( i, 1) * cos( AOV/2 - pi + best_fit_angle );% Azin: correct this!
            proj_points_on_x1 ( i , : ) = projection( proj_points_1( i, : ),  x_axis_pt1,  x_axis_pt2 );
            AddComplexity = AddComplexity + 2;
            MultComplexity = MultComplexity + 2;
        end
        [edge_1, I_1]= max( proj_points_on_x1 );
        [edge_2, I_2] = min( proj_points_on_x1 );
        edgePoint_1 = [ X(I_1(1)), Y(I_1(1)), Z(I_1(1)) ];
        edgePoint_2 = [ X(I_2(1)), Y(I_2(1)), Z(I_2(1)) ];
        %plot(edgePoint_1(1), edgePoint_1(2) , 'x'); hold on;
        %plot(edgePoint_2(1), edgePoint_2(2) , 'x'); hold on;

       % plot([-12, V1(1), V2(1) , 12 ], [-12* slope_up, V1(2), V2(2), slope_up * 12 ] , 'm'); hold on; 

         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        %for the camera line with - AOV/2 angle with main line
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        slope_down = tan( best_fit_angle - AOV/2 - pi / 2 );
        V3 = [ 0, 0, 0 ];
        V4 = [ 1, slope_down, 0 ];
        for i = 1 : TargetNum
           test_pt = [X(i), Y(i), 0];
           proj_points_2( i , : ) = projection( test_pt, V3, V4);
           % Now find which two points from the projection list are min an max
           % Project these points on x_axis
           %proj_points_on_x ( i , : ) = proj_points_2( i, 1 ) * cos( best_fit_angle - AOV/2 ); % Azin: correct this!
           proj_points_on_x2 ( i , : ) = projection( proj_points_2( i, : ),  x_axis_pt1,  x_axis_pt2 );
           AddComplexity = AddComplexity + 2;
           MultComplexity = MultComplexity + 2;
        end
        [edge_3, I_3] = max( proj_points_on_x2 );
        [edge_4, I_4] = min( proj_points_on_x2 );
        edgePoint_3 = [ X(I_3(1)), Y(I_3(1)), Z(I_3(1)) ];
        edgePoint_4 = [ X(I_4(1)), Y(I_4(1)), Z(I_4(1)) ];
        %plot(edgePoint_3(1), edgePoint_3(2) , 'x'); hold on;
        %plot(edgePoint_4(1), edgePoint_4(2) , 'x'); hold on;

       % plot([-12, V3(1), V4(1) , 12 ], [ -12* slope_down, V3(2), V4(2), slope_down * 12 ] , 'm'); hold on; 

    end

    edgeIndexList = [ I_1(1), I_2(1), I_3(1), I_4(1) ];
    edgeList = [ edgePoint_1; edgePoint_2; edgePoint_3; edgePoint_4 ];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % angle and slope of the above and below camera ray lines for all cases
    %ray_angle_case1 = [ best_fit_angle + AOV/2, best_fit_angle - AOV/2 ];
    %ray_angle_case2 = [ best_fit_angle + AOV/2, best_fit_angle - AOV/2 ];
    ray_angle = [ best_fit_angle + AOV/2, best_fit_angle - AOV/2 ];
    %ray_slope_case1 = tan( ray_angle_case1 );
    %ray_slope_case2 = tan( ray_angle_case2 );
    ray_slope = tan( ray_angle );
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    CompComplexity = CompComplexity + 4;
    %use edgeList and edgeIndexList
    for j = 1 : 4 % test which j is bestIndex
        test_edge = edgeList( j,: );
        test_index = edgeIndexList ( j );
        CompComplexity = CompComplexity + 1;
        if ( j < 3 )% incident on the upper line with + AOV/2 (two lines define min/max)
            %pass a line parallel to the upper line and find intersection with
            %best-fit-line

            x_cam( j ) = ( Y( test_index ) - best_shift - ray_slope(1) * X( test_index ) )/( best_line_slope - ray_slope(1) );
            y_cam( j ) = best_line_slope * x_cam( j ) + best_shift;
            z_cam( j ) = 0;
            AddComplexity = AddComplexity + 4;
            MultComplexity = MultComplexity + 3;
        else
            %pass a line with the line - AOV/2 and find intersection with
            %best-fit-line
            x_cam( j ) = (Y( test_index ) - best_shift - ray_slope(2) * X( test_index ))/( best_line_slope - ray_slope(2) );
            y_cam( j ) = best_line_slope * x_cam( j ) + best_shift;
            z_cam( j ) = 0;
            AddComplexity = AddComplexity + 4;
            MultComplexity = MultComplexity + 3;

        end
    end
    % check if cameras are out of range
    modified = zeros(1,4);
    for j = 1 : 4
        if (x_cam(j) < Dim1_min+margin) 
            x_cam(j) = Dim1_min+margin;
            modified(1,j) = 1;
        elseif (x_cam(j) > Dim1_max-margin) 
            x_cam(j) = Dim1_max-margin;
            modified(1,j) = 1;
        end
        if (y_cam(j) < Dim2_min+margin) 
            y_cam(j) = Dim2_min+margin;
            modified(1,j) = 1;
        elseif (y_cam(j) > Dim2_max-margin) 
            y_cam(j) = Dim2_max-margin;
            modified(1,j) = 1;
        end
        camDist(j) = EuclideanDist( [x_cam( j ), y_cam( j ), z_cam( j )], avg);
    end

    % From the set of 4 candidate camera positions, pick the one farthest to avg point
    % so that maximum number of points are covered
    for j = 1 : 4
        camDist(j) = EuclideanDist( [x_cam( j ), y_cam( j ), z_cam( j )], avg);
    end
    [ CameraPosDeterminer, bestIndex ] = max( camDist );
    CamPosIndex = edgeIndexList( bestIndex );

    %Finally, find the camera position!!
    % This line passes through the best candidate (cameraPosDeterminer)
    %
    camPosDetermienr_coords = [ X( CamPosIndex) , Y( CamPosIndex ) , Z( CamPosIndex )];

    CAM = [x_cam( bestIndex ), y_cam( bestIndex ), z_cam( bestIndex )]; % optimal placement of camera

    u2 = v2 - v1;%vector defining best line
    cam_vec = u2;
    
    %determining the camera direction
    sum_projection = 0;
    for i = 1 : TargetNum
         my_test_pt = [X(i), Y(i), Z(i)];
         vec = my_test_pt - CAM;
         sum_projection = sum_projection + dot(vec,u2);
    end
    if (sum_projection > 0)
        cam_vec = u2;
    else
        cam_vec = -u2;
    end
    
    
    % coverage test
    CoverageStatus = ones( 1, TargetNum );
    
    for i = 1 : TargetNum
         my_test_pt = [X(i), Y(i), Z(i)];
         % test range
         test_dist = EuclideanDist(my_test_pt, CAM);
         if ((test_dist > R_max) ||  (test_dist < R_min))
             CoverageStatus(i) = 0;
         end
         % test angle: form the line between camera point and each target
         % test if this line is within +/- AOV/2 of the best-fit-line
         u1 =  my_test_pt - CAM;     
         AOV_margin = 0.1 * AOV; % induced due to round-up errors
         gamma = interAngle( u1, cam_vec );
         if ( (gamma > AOV/2 + AOV_margin) || (gamma < - AOV/2 - AOV_margin) )
             CoverageStatus( i ) = 0;
         end

    end
    complexity = AddComplexity + MultComplexity + CompComplexity;
    %best_line_slope
    %disp(' complexity due to CoverageTestFunc')
    
    %CoverageStatus
    %res1 = sum(CoverageStatus)
    coverage_status = [CoverageStatus, -1, CAM , cam_vec, complexity];
    coverage_status;

end



