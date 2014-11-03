% this file calculates C(i,j,fi,i2,j2): if a camera is located at point
% (i,j) with direction fi, does it cover a target at point (i2, j2)?
% if it does, C(i,j,fi,i2,j2) = 1; otherwise 0

AOV_degree = 45;
AOV = (AOV_degree * 2*pi)/360; %60 degrees camera Angle of View
R_min = 0.0001;%0.01; % 0.5m
R_max = 10;%30; % 3m

pan_step = pi/12; % pan angle changes in 30 degrees steps

Dim1_min = 0;
Dim2_min = 0;
Dim1_max = 20;%60; %maximum in x-axis (m)
Dim2_max = 20;%60; %maximum in y-axis (m)
%xmargin = margin_ratio * Dim1_max;%(1/6)*Dim1_max; % do not place cameras at the edges. We want them in the middle
%ymargin = margin_ratio * Dim2_max; %(1/6)*Dim2_max;

TargetCount = 10;
seed = 3;
% generate location of targets
data = GenerateData(Dim1_max, Dim2_max, TargetCount,seed); 
my_data = data(1:2,:);
grid_step_x = 1;
grid_step_y = 1;
z = 0;
pans = (2*pi)/pan_step;
xsteps = (Dim1_max- Dim1_min)/grid_step_x;
ysteps = (Dim2_max- Dim2_min)/grid_step_y;

current_data_set = data;

C = zeros(xsteps,ysteps,pans,TargetCount);

%fileID = fopen('GridCoverageLookup.txt','w');
%fprintf(fileID,'dim1=60,dim2=60,TargetCount=20,R_max = 30\n');
%fprintf(fileID, 

i = 0; j = 0; k = 0;

for grid_x = Dim1_min : grid_step_x : Dim1_max
    i = i + 1;
    j = 0;
    for grid_y = Dim2_min : grid_step_y : Dim2_max
        j = j + 1;
        k = 0;
        for fi = 0 : pan_step : 2*pi - pan_step
            k = k + 1;
            CoverageRangeStatus = ones( 2, TargetCount );
            CoverageStatus = ones( 1, TargetCount );
            CAM = [ grid_x ; grid_y ; z ]';
            
            CoverageRangeStatus = BasicCameraCoverage( current_data_set, CAM, fi, AOV, R_min, R_max );
            CoverageStatus = CoverageRangeStatus(1,:);
            for target = 1 : TargetCount
                C( i, j, k, target ) = CoverageStatus( 1,target );   
                %fprintf(fileID, '%6u', C(i, j, k, target));
            end
        end
    end
    %fprintf(fileID, '\n');
end

%fclose(fileID);
save GridCoverageCoeffs C;
