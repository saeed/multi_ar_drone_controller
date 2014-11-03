% implementing CFA:
AOV_degree = 45;
AOV = (AOV_degree * 2*pi)/360; %60 degrees camera Angle of View
R_min = 0.0001;%0.01; % 0.5m
R_max = 30; % 3m


pan_step = pi/6; % pan angle changes in 30 degrees steps

Dim1_min = 0;
Dim2_min = 0;
Dim1_max = 60; %maximum in x-axis (m)
Dim2_max = 60; %maximum in y-axis (m)
xmargin = 10; % do not place cameras at the edges. We want them in the middle
ymargin = 10;
% OR using random data
TargetCount = 20;
% fraction of targets below which we allow uncovered targets
UNCOVERED_FRACTION_CRITERION = 0.2; 
MAX_ITERATION = 100;

ClusterNum = 4; % initially
seed = 3;
% generate location of targets
data = GenerateData(Dim1_max, Dim2_max, TargetCount,seed); 
my_data = data(1:2,:);
% generate location of cameras
rng(seed);
Dim = 1; % for now generate data on a plane
x = randi([Dim1_min + xmargin Dim1_max-xmargin], ClusterNum, 1);
y = randi([Dim2_min + ymargin Dim2_max-ymargin], ClusterNum, 1);
z = zeros(1,ClusterNum);
cams = [ x' ; y' ; z ];
%cams = [ x' ; y'; z];
pans = (2*pi)/pan_step;

current_data_set = data

for iter = 1 : ClusterNum
    % coverage test for each camera at each pan choice
    Weights = zeros(ClusterNum, pans);

    for j = 1 : ClusterNum
        CAM = (cams(:,j))';
        for pan = 0 : pan_step : 2*pi - pan_step
            slope = tan( pan );
            InRangeStatus = ones( 1, size(current_data_set,2) );
            CoverageStatus = ones( 1, size(current_data_set,2) );
            CoverageRangeStatus = ones( 2, size(current_data_set,2) );
            CoverageRangeStatus = BasicCameraCoverage( current_data_set, CAM, pan, AOV, R_min, R_max);

            % count the weight at this pan
            cover_count = sum(CoverageRangeStatus(1,:));
            in_range_count = sum(CoverageRangeStatus(2,:));
            Weights( j , 1 + (pan/pan_step)) = cover_count/in_range_count;
        end
    end

    % 1.now that we have the weights, we pick the camera and pan with maximum
    % weight
    % then we remove that camera and all targets it covers from consideration


    Weights_vector = zeros( 1, ClusterNum * pans );
    k = 1;
    for i = 1 : ClusterNum
        for j = 1 : pans
            Weights_vector( 1 , k )= Weights( i , j );
            k = k + 1;
        end
    end

    % k = ( i - 1)*ClusterNum + (j-1)*pans
    [ sorted_weights , I ] =  sort( Weights_vector , 'descend');
    covered_set_indices = [];
    %uncovered_set_indices = 1:size(current_data_set,2);
    

    ind= I(1);% item with maximum weight
    ind_temp = mod( I(1), pans );
    current_pan_index = ind_temp;
    current_cam = 1 + (I(1)-ind_temp)/pans;
    current_pan = ( current_pan_index - 1 ) * pan_step;
    % now test that at this pan and position which targets are covered
    cam_pos = cams( : , current_cam );

    current_coverage = BasicCameraCoverage( current_data_set, cam_pos', current_pan, AOV, R_min, R_max);
    for k = 1 : size(current_data_set,2)
        if current_coverage(1,k) == 1
            covered_set_indices = [covered_set_indices; k];
        end
    end
    covered_set_indices

    % make a new set of data with items 
    new_data_set = [];
    for i = 1 : size(current_data_set,2)
        covered_flag = 0;
        found = find(covered_set_indices == i);
        if isempty(found) % target i not yet covered
            new_data_set = [new_data_set, current_data_set(:,i)];
        end
    end
    new_data_set
    current_data_set = new_data_set;
end
    
uncovered_num = size( current_data_set , 2 )
            
    
























