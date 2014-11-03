function dist = EuclideanDist2(pt1, pt2)
%Find Euclidean distance between points pt1 and pt2
% pt1 (x, y , z); pt2 (x, y , z)
temp = (pt1(1) - pt2(1)).^2 + (pt1(2) - pt2(2)).^2;
dist = sqrt(temp);
end

