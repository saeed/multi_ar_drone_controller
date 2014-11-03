clear all;
close all;

AOV_degree = 60;
AOV = (AOV_degree * 2*pi)/360; %60 degrees camera Angle of View
R_min = 0.0001;%0.01; % 0.5m
R_max = 30; % 3m

% Dimensions of the area
Dim1_min = 0;
Dim2_min = 0;
Dim1_max = 60; %maximum in x-axis (m)
Dim2_max = 60; %maximum in y-axis (m)

% OR using random data
TargetCount = 20;
% fraction of targets below which we allow uncovered targets
UNCOVERED_FRACTION_CRITERION = 0.2; 
MAX_ITERATION = 100;

ClusterNum = 5; % initially

data = GenerateData(Dim1_max, Dim2_max, TargetCount);
mydata = data(1:2,:);
converted_data = zeros(size(mydata,1),size(mydata,2));
% derive new data from this data

for i = 1 : size(mydata,2)
    temp = mydata( : , i );
    f1 = atan(temp(2)/temp(1));
    f2 = ((temp(1)).^2 + (temp(2)).^2).^0.5;
    converted_data( : , i ) = [f1;f2];
end
    
% run k-means clustering
ClusterIndex = zeros(1, TargetCount);
for i = 1: TargetCount
    ClusterIndex(i) = mod( i , ClusterNum)  + 1;
end

mean_vector = zeros(2, ClusterNum);
sum_vector = zeros(2, ClusterNum);
count_vector = zeros( 1, ClusterNum);
% find the mean of each cluster
for i = 1 : TargetCount
    ind = ClusterIndex(i);
    sum_vector( : , ind ) = sum_vector( : , ind ) + converted_data( : , i );
    count_vector( 1 , ind ) = count_vector( 1 , ind ) + 1;
end

for ind = 1 : ClusterNum
    mean_vector( : , ind ) = sum_vector(  : , ind ) / count_vector( 1 , ind );
end

ClusterIndex
% assign each point to the cluster whose min is closest
min_dist = 1000000;
min_ind = 0;

transitions = zeros(1, MAX_ITERATION);

for iteration = 1 : MAX_ITERATION
    for i = 1 : TargetCount
        temp_data = converted_data( : , i);
        temp_cluster_ind = ClusterIndex(i);
        min_ind = temp_cluster_ind;
        min_dist = EuclideanDist2(temp_data , mean_vector( : , temp_cluster_ind ));
        for j = 1 : ClusterNum
            temp_dist = EuclideanDist2(temp_data, mean_vector( :, j));
            if (temp_dist < min_dist - 0.1)
                min_dist = temp_dist;
                min_ind =  j;
            end
        end
        if min_ind ~= temp_cluster_ind
            transitions( iteration ) =  transitions( iteration ) + 1;
        end
        ClusterIndex(i) = min_ind;
    end
    %ClusterIndex
    
    mean_vector = zeros(2, ClusterNum);
    sum_vector = zeros(2, ClusterNum);
    count_vector = zeros( 1, ClusterNum);
    for i = 1 : TargetCount
        ind = ClusterIndex(i);
        sum_vector( : , ind ) = sum_vector( : , ind ) + converted_data( : , i );
        count_vector( 1 , ind ) = count_vector( 1 , ind ) + 1;
    end

    for ind = 1 : ClusterNum
        mean_vector( : , ind ) = sum_vector(  : , ind ) / count_vector( 1 , ind );
    end
end
   