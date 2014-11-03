% pose the camera placement problem as a ILP
clear all;
close all;
AOV_degree = 45;
AOV = (AOV_degree * 2*pi)/360; %60 degrees camera Angle of View
R_min = 0.0001;%0.01; % 0.5m
R_max = 10; % 3m

pan_step = pi/12; % pan angle changes in 30 degrees steps

Dim1_min = 0;
Dim2_min = 0;
Dim1_max = 20; %maximum in x-axis (m)
Dim2_max = 20; %maximum in y-axis (m)
%xmargin = margin_ratio * Dim1_max;%(1/6)*Dim1_max; % do not place cameras at the edges. We want them in the middle
%ymargin = margin_ratio * Dim2_max; %(1/6)*Dim2_max;

TargetCount = 10;
seed = 3;
% generate location of targets
%data = GenerateData(Dim1_max, Dim2_max, TargetCount,seed); 
%my_data = data(1:2,:);
grid_step_x = 1;
grid_step_y = 1;
%z = 0;
pans = (2*pi)/pan_step;
xsteps = (Dim1_max- Dim1_min)/grid_step_x;
ysteps = (Dim2_max- Dim2_min)/grid_step_y;

%current_data_set = data;

load GridCoverageCoeffs;
coeffs = C;
%coeffs = D;
%D = ones(xsteps,ysteps,pans,TargetCount);
D = randi(2, xsteps,ysteps,pans,TargetCount) - 1;

N = xsteps*ysteps*pans;
f = ones(1,N);
A = [];
h = 1;
target_ind = 1;
for target_ind = 1 : TargetCount
    h = 1;
    for i = 1 : xsteps
        for j = 1 : ysteps
            for k = 1 : pans
                B( 1 , h ) = coeffs(i, j , k , target_ind);%D(i,j,k,target_ind);
                h = h + 1;
            end
        end
    end
    B;
    A = [A;B];
end
%A = [A,A];
%Padding = zeros(1,N);
% for i = 1 : TargetCount
%     for j = 1 : N
%         A( i , N+j ) = 0;
%     end
% end
b = ones( 1 , TargetCount);
%[X,FVAL,EXITFLAG] = bintprog(f,-A,-b,'on');
%X = linprog(f,-A,-b)
lb = (zeros(1,N)-0.001)';
ub = (ones(1,N))';
%options = optimset
%options=optimset('Algorithm','active-set','MaxIter',1000000000*size(f,2),'MaxNodes',1000000*size(f,2));
%X = linprog(f,-A,-b, [],[], l , u);
% F = sort(X, 'descend');
% for i = 1 : size(F,1)
%     if  F(i) > 0.5
%         H( i ) = 1;
%     else
%         H(i) = 0;
%     end
% end
X0 = zeros(1,N);
x0 = zeros(1,2*N);
%[x,fval] = fmincon(@mymin,x0,-A,-b,[],[],lb,ub);  
options=optimset('MaxTime', 36000);
[X,FVAL,EXITFLAG] = bintprog(f,-A,-b,[],[],[],options);
save GridCoverageCams X;
