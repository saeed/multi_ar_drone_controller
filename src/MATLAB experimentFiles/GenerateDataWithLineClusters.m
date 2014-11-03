% Data generation file
function my_data = GenerateDataWithLineClusters(dim1, dim2, TargetNum, targetClusters, seed)

dim = max(dim1, dim2);
dim1 =40;
dim2=40;

%rng(3);% sets the randome seed to value 0
rng(seed);
% Dim = 2; % for now generate data on a plane
% r = randi(dim,Dim,TargetNum);
% X = r(1,:);
% Y = r(2,:);
% Z = zeros(1,TargetNum);

 Dim = 1;
 if targetClusters == 1
    X = ((dim/4).*randn(TargetNum,1) + dim/2)';
    Y = X + randn(TargetNum,1);
 elseif targetClusters == 2
     X1 = (dim/4).*randn(TargetNum/2,1) + dim/2;
     Y1 = X1 + randn(TargetNum/2,1);
     X2 = (dim/4).*randn(TargetNum/2,1) + (3*dim)/4;
     Y2 = X2 + randn(TargetNum/2,1) + (3/4)*dim;
     X = ([X1;X2])';
     Y = ([Y1;Y2])';
 elseif targetClusters == 4
     X1 = (dim/8).*randn(floor(TargetNum/4),1) + dim/4;
     Y1 = 2*X1 + randn(floor(TargetNum/4),1);
     X2 = (dim/8).*randn(floor(TargetNum/4),1) + (3*dim)/4;
     Y2 = X2 + randn(floor(TargetNum/4),1) - (2*dim/4);
     X3 = (dim/8).*randn(floor(TargetNum/4),1) + dim/4;
     Y3 = X3 + randn(floor(TargetNum/4),1) + (2*dim)/4;
     
     X4 = (dim/8).*randn(floor(TargetNum/4)+ mod(TargetNum,targetClusters), 1) + (3*dim)/4;
     Y4 = X4 + randn(floor(TargetNum/4)+ mod(TargetNum,targetClusters), 1);
     X = ([X1;X2;X3;X4])'
     Y = ([Y1;Y2;Y3;Y4])'
 elseif targetClusters == 8
     X1 = (dim/16).*randn(floor(TargetNum/8),1) + dim/8
     Y1 = (dim/8).*randn(floor(TargetNum/8),1) + dim/4
     X2 = (dim/16).*randn(floor(TargetNum/8),1) + (3*dim)/8
     Y2 = (dim/8).*randn(floor(TargetNum/8),1) + dim/4
     X3 = (dim/16).*randn(floor(TargetNum/8),1) + (5*dim)/8
     Y3 = (dim/8).*randn(floor(TargetNum/8),1) + dim/4
     X4 = (dim/16).*randn(floor(TargetNum/8),1) + (7*dim)/8
     Y4 = (dim/8).*randn(floor(TargetNum/8),1) + dim/4
     X5 = (dim/16).*randn(floor(TargetNum/8),1) + dim/8
     Y5 = (dim/8).*randn(floor(TargetNum/8),1) + (3*dim)/4
     X6 = (dim/16).*randn(floor(TargetNum/8),1) + (3*dim)/8
     Y6 = (dim/8).*randn(floor(TargetNum/8),1) + (3*dim)/4
     X7 = (dim/16).*randn(floor(TargetNum/8),1) + (5*dim)/8
     Y7 = (dim/8).*randn(floor(TargetNum/8),1) + (3*dim)/4
     X8 = (dim/16).*randn(floor(TargetNum/8) + mod(TargetNum,targetClusters) , 1) + (7*dim)/8
     Y8 = (dim/8).*randn(floor(TargetNum/8) + mod(TargetNum,targetClusters), 1 ) + (3*dim)/4
     X = ([X1;X2;X3;X4;X5;X6;X7;X8])';
     Y = ([Y1;Y2;Y3;Y4;Y5;Y6;Y7;Y8])';
 end
     
 %X = (randsample(dim,TargetNum))'; 
 %X = randi(dim1, Dim, TargetNum);
% size(X);
% Y = randi(dim2, Dim, TargetNum);
 %Y = (randsample(dim2,TargetNum))'; 
 
% Y = X + randi(round(dim/2), Dim, TargetNum);
 Z = zeros(1,TargetNum);


% Dim = 1;
% X1 = randi(dim1, Dim, TargetNum/2);
% size(X1);
% %Y = randi(dim2, Dim, TargetNum);
% Y1 = X1 + randi(round(dim/2), Dim, TargetNum/2);
% Z = zeros(1,TargetNum);
% rng(seed + 1);
% X2 = randi(dim1, Dim, TargetNum/2);
% size(X2);
% %Y = randi(dim2, Dim, TargetNum);
% Y2 = X2 + randi(round(dim/2), Dim, TargetNum/2);

%X = [X1 , X2];
%Y = [Y1, Y2];

my_data = [ X ; Y ; Z ];
for check_1 = 1 : size(my_data,2)
    for check_2 = 1 :size(my_data,1)
        my_data(check_2, check_1) = floor(my_data(check_2, check_1));
        if (my_data(check_2, check_1) <= 0 )
            my_data(check_2, check_1) = 1;
        elseif (my_data(check_2, check_1) > dim)
            my_data(check_2, check_1)  = dim - 2;
        end
    end
end
    

end