% Data generation file
function my_data = GenerateData(dim1, dim2, TargetNum, seed)

dim = max(dim1, dim2);


%rng(3);% sets the randome seed to value 0
rng(seed);
% Dim = 2; % for now generate data on a plane
% r = randi(dim,Dim,TargetNum);
% X = r(1,:);
% Y = r(2,:);
% Z = zeros(1,TargetNum);

 Dim = 1;
 %X = (randsample(dim,TargetNum))'; 
 X = randi(dim1, Dim, TargetNum);
 size(X);
 Y = randi(dim2, Dim, TargetNum);
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

end