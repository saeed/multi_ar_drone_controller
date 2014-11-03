%FuzzyClustering
clear all;
close all;

blend = 2;
ClusterNum = 4;
TargetNum = 20;

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

ClusterNum = 4; % initially
coeff = 0;% to scale angle and magnitude 

P_init = zeros(ClusterNum, TargetNum);
P = zeros(ClusterNum, TargetNum);

data = GenerateData(Dim1_max, Dim2_max, TargetCount);
my_data = data(1:2,:);

%convert the data
for i = 1 : size(my_data,2)
    temp = my_data( : , i );
    f1 = coeff*atan(temp(2)/temp(1));
    f2 = ((temp(1)).^2 + (temp(2)).^2).^0.5;
    converted_data( : , i ) = [f1;f2];
end


%1. Pick the first set of means randomly
mean_vec = zeros( 2 , ClusterNum );

for i = 1 : ClusterNum
    r1 = randi( [(i - 1)*Dim1_max/ClusterNum (i)*Dim1_max/ClusterNum], 1);
    r2 = randi([0 Dim2_max],1);
    mean_vec( 1 , i ) = coeff*atan(r2/r1);
    mean_vec( 2 , i ) = sqrt((r1)^2 + (r2)^2);
    %mean_vec( 1 , i ) = r1;
    %mean_vec( 2 , i ) = r2;
end
mean_vec
% 2. Use fuzzy-kmeans over converted data to find better performance

Mean_Vector_x = zeros( ClusterNum , MAX_ITERATION );
Mean_Vector_y = zeros( ClusterNum , MAX_ITERATION );

for iter = 1 : MAX_ITERATION
    sum_prob = zeros( 1 , TargetCount);
    for j = 1 : TargetCount
        for i = 1 : ClusterNum
           %dist = EuclideanDist2( mean_vec( : , i ) , my_data( :  , j ) );
           dist = EuclideanDist2( mean_vec( : , i ) , converted_data( :  , j ) );
           sum_prob( 1 , j ) = sum_prob( 1 , j ) + ((1/dist).^(1/(blend-1)));
        end
    end
    sum_prob;
    for i = 1 : ClusterNum
        for j = 1 : TargetCount
            %dist = EuclideanDist2( mean_vec(:,i) , my_data(:,j) );
            dist = EuclideanDist2( mean_vec( : , i ) , converted_data( : , j) );
            dist;
            dist_inv = 1/dist;
            sum_prob(1,j);
            P( i , j ) = ( (1/dist).^(1/(blend-1)) )/sum_prob(1,j);
            P(i,j);
        end
    end
    P
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
figure;
for i = 1 : ClusterNum
    plot(Mean_Vector_x(i,:));  
    hold on;
    %figure;
    plot(Mean_Vector_y(i,:));
    hold on;
    legend;
end



        
        