%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%INITIALIZATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;

% AOV and Depth (FOV)
AOV_degree = 60;
AOV = (AOV_degree * 2*pi)/360; %60 degrees camera Angle of View
R_min = 0.5; % 0.5m
R_max = 30; % 3m

% Dimensions of the area
Dim1_min = 0;
Dim2_min = 0;
Dim1_max = 20; %maximum in x-axis (m)
Dim2_max = 20; %maximum in y-axis (m)

% OR using random data
TargetNum = 7;

data = GenerateData(Dim1_max, Dim2_max, TargetNum);
X = data( 1, : );
Y = data( 2, : );
Z = data( 3 , : ); 

%TargetNum = size(X,2);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%DATA FITTING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%find the line best approximating (X,Y): Y = f(X)= p1.X + p2
p = polyfit(X, Y, 1);
f = polyval(p,X);
plot(X,Y, 'o',X,f,'-y'); hold on;
axis([-10 30 -10 30]);

best_fit_angle = atan(p(1)); % angle of the line in radians
if (best_fit_angle < 0) 
    best_fit_angle = pi + best_fit_angle;
end
best_line_slope = p(1);
best_shift = p(2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Find the edge objects with most distance to the approximating line
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P_x = X(1);
P_y =f(1);
v1 = [X(1), f(1), 0]; % sample point 1 on best fit line
v2 = [X(2), f(2), 0]; % sample point 2 on best fit line
pt = [X(1), Y(1), 0];
%dist = point_to_line(pt,v1,v2)

%find which targets are above the line
Side = zeros(1,TargetNum);
for i = 1:TargetNum
    if f(i)<= Y(i)
        Side(i) = 1;
    else
        Side(i) = -1;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%METHOD 1: USe the edge points
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%find the edge target above the approximate line
for i = 1:TargetNum
    pt = [X(i), Y(i), 0];
    if (Side(i) > 0)
        dist(i) =  point_to_line(pt,v1,v2);
    else
        dist(i) =  (-1)*point_to_line(pt,v1,v2);
    end 
end
%find max and min points--> these are the two edge points
[edge_above, I_above]=max(dist);
[edge_below, I_below] = min(dist);
[dist_max,I] = max(abs(dist));
EdgePoint = [X(I), Y(I), Z(I)];

% Pass two lines from edge objects each at angle of 90 - AOV/2


%line passing throgh farthest point above the fitting line:
% 1) Find the projection point of edge on line
% Get a unit vector on the line
%v = v2 - v1;
%v = v / norm(v);

%u = EdgePoint - v1;
% point P is the point of projection of the edge point on the best fit line
%P = v1 + dot(u, v) * v; 
P = projection(EdgePoint, v1, v2);
L = dist_max * tan( pi/2 - AOV/2);

x_c = P(1) + L * cos(best_fit_angle);
y_c = P(2) + L * sin(best_fit_angle);
C = [x_c, y_c, 0]; % optimal placement of camera

%plot([x_c, EdgePoint(1)],[y_c, EdgePoint(2)]);hold on;
%plot([X, x_c],[f, y_c],'r'); hold on;
%plot(x_c,y_c, 'xr'); hold on;

%For illustration purposes, also draw the line from the symmetric point
%to the edge point with respect to the best fit line

x_symmetric_to_edge = P(1) + dist_max * sin(best_fit_angle);
y_symmetric_to_edge = P(2) + dist_max * cos(best_fit_angle);
%plot([x_c, x_symmetric_to_edge], [y_c, y_symmetric_to_edge] , 'g'); hold on; 

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
       
    end
    [edge_1, I_1]= max( proj_points_on_x1 );
    [edge_2, I_2] = min( proj_points_on_x1 );
    edgePoint_1 = [ X(I_1(1)), Y(I_1(1)), Z(I_1(1)) ];
    edgePoint_2 = [ X(I_2(1)), Y(I_2(1)), Z(I_2(1)) ];
    plot(edgePoint_1(1), edgePoint_1(2) , 'x'); hold on;
    plot(edgePoint_2(1), edgePoint_2(2) , 'x'); hold on;
    
    plot([-12, V1(1), V2(1) , 12 ], [-12*slope_pos, V1(2), V2(2), slope_pos * 12 ] , 'm'); hold on; 
    
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
    end
    [ edge_1, I_3 ]= max( proj_points_on_x2 );
    [ edge_2, I_4 ] = min( proj_points_on_x2 );
    edgePoint_3 = [ X(I_3(1)), Y(I_3(1)), Z(I_3(1)) ];
    edgePoint_4 = [ X(I_4(1)), Y(I_4(1)), Z(I_4(1)) ];
    plot(edgePoint_3(1), edgePoint_3(2) , 'x'); hold on;
    plot(edgePoint_4(1), edgePoint_4(2) , 'x'); hold on;
    
    plot([ -12, V3(1), V4(1) , 12 ], [ -12 * slope_neg, V3(2), V4(2), slope_neg * 12 ] , 'g'); hold on; 
    
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
    end
    [edge_1, I_1]= max( proj_points_on_x1 );
    [edge_2, I_2] = min( proj_points_on_x1 );
    edgePoint_1 = [ X(I_1(1)), Y(I_1(1)), Z(I_1(1)) ];
    edgePoint_2 = [ X(I_2(1)), Y(I_2(1)), Z(I_2(1)) ];
    plot(edgePoint_1(1), edgePoint_1(2) , 'x'); hold on;
    plot(edgePoint_2(1), edgePoint_2(2) , 'x'); hold on;
    
    plot([-12, V1(1), V2(1) , 12 ], [-12* slope_up, V1(2), V2(2), slope_up * 12 ] , 'm'); hold on; 
    
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
    end
    [edge_3, I_3] = max( proj_points_on_x2 );
    [edge_4, I_4] = min( proj_points_on_x2 );
    edgePoint_3 = [ X(I_3(1)), Y(I_3(1)), Z(I_3(1)) ];
    edgePoint_4 = [ X(I_4(1)), Y(I_4(1)), Z(I_4(1)) ];
    plot(edgePoint_3(1), edgePoint_3(2) , 'x'); hold on;
    plot(edgePoint_4(1), edgePoint_4(2) , 'x'); hold on;
    
    plot([-12, V3(1), V4(1) , 12 ], [ -12* slope_down, V3(2), V4(2), slope_down * 12 ] , 'm'); hold on; 
    
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

%use edgeList and edgeIndexList
for j = 1 : 4 % test which j is bestIndex
    test_edge = edgeList( j,: )
    test_index = edgeIndexList ( j );
    if ( j < 3 )% incident on the upper line with + AOV/2 (two lines define min/max)
        %pass a line parallel to the upper line and find intersection with
        %best-fit-line

        x_cam( j ) = ( Y( test_index ) - best_shift - ray_slope(1) * X( test_index ) )/( best_line_slope - ray_slope(1) );
        y_cam( j ) = best_line_slope * x_cam( j ) + best_shift;
        z_cam( j ) = 0;
    else
        %pass a line with the line - AOV/2 and find intersection with
        %best-fit-line
        x_cam( j ) = (Y( test_index ) - best_shift - ray_slope(2) * X( test_index ))/( best_line_slope - ray_slope(2) );
        y_cam( j ) = best_line_slope * x_cam( j ) + best_shift;
        z_cam( j ) = 0;

    end
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

% coverage test
CoverageStatus = ones( 1, TargetNum );
for i = 1 : TargetNum
     my_test_pt = [X(i), Y(i), Z(i)];
     % test range
     test_dist( i ) = EuclideanDist(my_test_pt, CAM);
     if ((test_dist( i ) > R_max) |  (test_dist( i ) < R_min))
         CoverageStatus(i) = 0;
     end
     % test angle: form the line between camera point and each target
     % test if this line is within +/- AOV/2 of the best-fit-line
     if (CAM(1) > my_test_pt(1)) 
        u1 = CAM - my_test_pt;
     else
        u1 = my_test_pt - CAM;
     end
     
     if v2(1) > v1(1)
         u2 = v2 - v1;
     else
         u2 = v1 - v2;
     end
     
     AOV_margin = 0.1 * AOV; % induced due to round-up errors
     
     gamma(i) = interAngle( u1, u2 );
     
     if ( (gamma > AOV/2 + AOV_margin) | (gamma < - AOV/2 - AOV_margin) )
         CoverageStatus( i ) = 0;
     end
     
end




