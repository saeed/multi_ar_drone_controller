function FinalResult = DirectFeaturesAlgorithmFunc(data, TargetCount, ClusterNum, max_iteration,coeff)
mydata = data(1:2,:);
converted_data = zeros(size(mydata,1),size(mydata,2));
% derive new data from this data
complexity = 0;
for i = 1 : size(mydata,2)
    temp = mydata( : , i );
    %f1 = coeff*atan(temp(2)/temp(1));
    %f2 = ((temp(1)).^2 + (temp(2)).^2).^0.5;
    converted_data( : , i ) = [mydata(1,i);mydata(2,i)];%[f1;f2];
    complexity = complexity + 3;
end
    converted_data;
% run k-means clustering
ClusterIndex = zeros(1, TargetCount);
for i = 1: TargetCount
    ClusterIndex(i) = mod( i , ClusterNum)  + 1;
    complexity = complexity + 2;
end

mean_vector = zeros(2, ClusterNum);
sum_vector = zeros(2, ClusterNum);
count_vector = zeros( 1, ClusterNum);
% find the mean of each cluster
for i = 1 : TargetCount
    ind = ClusterIndex(i);
    sum_vector( : , ind ) = sum_vector( : , ind ) + converted_data( : , i );
    count_vector( 1 , ind ) = count_vector( 1 , ind ) + 1;
    complexity = complexity + 2*size(sum_vector,1);
end

for ind = 1 : ClusterNum
    mean_vector( : , ind ) = sum_vector(  : , ind ) / count_vector( 1 , ind );
    complexity = complexity + size(sum_vector,1);
end

ClusterIndex;
% assign each point to the cluster whose min is closest
min_dist = 1000000;
min_ind = 0;

transitions = zeros(1, max_iteration);

for iteration = 1 : max_iteration
    for i = 1 : TargetCount
        temp_data = converted_data( : , i);
        temp_cluster_ind = ClusterIndex(i);
        min_ind = temp_cluster_ind;
        min_dist = EuclideanDist2(temp_data , mean_vector( : , temp_cluster_ind ));
        complexity = complexity+6;
        for j = 1 : ClusterNum
            temp_dist = EuclideanDist2(temp_data, mean_vector( :, j));
            complexity = complexity+6;
            if ( temp_dist < min_dist - 0.1 )
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
        complexity = complexity + 2*size(sum_vector,1);
    end

    for ind = 1 : ClusterNum
        if count_vector( 1 , ind ) ~= 0
            mean_vector( : , ind ) = sum_vector(  : , ind ) / count_vector( 1 , ind );
            complexity = complexity + 2*size(sum_vector,1);
        else
            mean_vector( : , ind ) = 0;
        end
    end
    sum_vector;
    mean_vector;
end
Complexity = complexity*ones(1, TargetCount);
FinalResult = [ClusterIndex;Complexity];

end


