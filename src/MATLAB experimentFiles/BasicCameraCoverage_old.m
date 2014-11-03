function coverage = BasicCameraCoverage( data, CAM, pan, AOV, R_min, R_max, TargetCount)
    InRangeStatus = ones( 1, TargetCount );
    CoverageStatus = ones( 1, TargetCount );
    slope = tan(pan);
    for i = 1 : size( data , 2 )
         my_test_pt = [data(1,i),data(2,i), data(3,i)];
         %camera coordination line:
         v1 = CAM;
         v2(1,1) = CAM(1,1) + 1;
         v2(1,2) = CAM(1,2) +slope*(CAM(1,1) + 1 - CAM(1,1));
         v2(1,3) = 0;
         % test range
         test_dist( i ) = EuclideanDist(my_test_pt, CAM);
         if ((test_dist( i ) > R_max) |  (test_dist( i ) < R_min))
             %' test_dist ( i ) '
             %test_dist ( i )
             InRangeStatus(i) = 0;
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

         AOV_margin = 0.01 * AOV; % induced due to round-up errors

         gamma(i) = interAngle( u1, u2 );

         if ( (gamma(i) > AOV/2 + AOV_margin) | (gamma(i) < - AOV/2 - AOV_margin) )
             %' gamma '
             %gamma
             CoverageStatus( i ) = 0;
         end     
    end
    InRangeStatus;
    CoverageStatus;
    InRangeNum = sum(InRangeStatus);
    CoveredNum = sum(CoverageStatus);
    coverage = [CoverageStatus; InRangeStatus];
end

