function angle = AngularDist(target_pos, cam_pos, slope, rmin, rmax, aov, mem_count)
    %Tests if target located at @target_pos is covered by camera at @cam_pos and
    %angle of @slope
    % pt1 (x, y , z); pt2 (x, y , z)
    % test range
     
     % test angle: form the line between camera point and each target
     % test if this line is within +/- AOV/2 of the best-fit-line
     if (cam_pos(1) > target_pos(1)) 
        u1 = cam_pos - target_pos;
     else
        u1 = target_pos - cam_pos;
     end

     x1 = 1;
     y1 = cam_pos(2) - slope * ( cam_pos(1) - x1 );
     z1 = 0;
     v_1 = [x1, y1, z1];
     v_2 = cam_pos;
     
     if v_2(1) > v_1(1)
         u2 = v_2 - v_1;
     else
         u2 = v_1 - v_2;
     end

     aov_margin = 0.1 * aov; % induced due to round-up errors

     gamma = interAngle( u1, u2 );

     angle = gamma;

end

