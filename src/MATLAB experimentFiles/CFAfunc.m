function result = CFAfunc(seed1,seed2,AOV_degree, R_min, R_max, pan_step, Dim1_min, Dim1_max, Dim2_min, Dim2_max, ClusterNum, TargetCount, margin_ratio)
    complexity = 0;
    % implementing CFA:
    %AOV_degree = 45;
    AOV = (AOV_degree * 2*pi)/360; %60 degrees camera Angle of View
   % R_min = 0.0001;%0.01; % 0.5m
    %R_max = 30; % 3m


    %pan_step = pi/6; % pan angle changes in 30 degrees steps

    %Dim1_min = 0;
   % Dim2_min = 0;
   % Dim1_max = 60; %maximum in x-axis (m)
   % Dim2_max = 60; %maximum in y-axis (m)
    complexity = complexity + 2;
    xmargin = margin_ratio * Dim1_max;%(1/6)*Dim1_max; % do not place cameras at the edges. We want them in the middle
    ymargin = margin_ratio * Dim2_max; %(1/6)*Dim2_max;
    % OR using random data
    %TargetCount = 20;
    % fraction of targets below which we allow uncovered targets
   

    %ClusterNum = 4; % initially
    %seed = 3;
    % generate location of targets
    data = GenerateData(Dim1_max, Dim2_max, TargetCount,seed1); 
    my_data = data(1:2,:);
    % generate location of cameras
    rng(seed2);
    Dim = 1; % for now generate data on a plane
    x = randi([round(Dim1_min + xmargin) round(Dim1_max-xmargin)], ClusterNum, 1);
    %x = (xmargin, Dim1_max - xmargin, xmargin, Dim1_max - xmargin);
    %y = (ymargin, ymargin, Dim2_max - ymargin, Dim2_max - ymargin);
    y = randi([round(Dim2_min + ymargin) round(Dim2_max-ymargin)], ClusterNum, 1);
    z = zeros(1,ClusterNum);
    
    cams = [ x' ; y' ; z ];
    %cams = [ x' ; y'; z];
    pans = (2*pi)/pan_step;

    current_data_set = data;

    for iter = 1 : ClusterNum
        complexity = complexity + 1;
        % coverage test for each camera at each pan choice
        Weights = zeros(ClusterNum, pans);

        for j = 1 : ClusterNum
            complexity = complexity + 1;
            CAM = (cams(:,j))';
            for pan = 0 : pan_step : 2*pi - pan_step
                complexity = complexity + 1;
                slope = tan( pan );
                InRangeStatus = ones( 1, size(current_data_set,2) );
                CoverageStatus = ones( 1, size(current_data_set,2) );
                CoverageRangeStatus = ones( 2, size(current_data_set,2) );
                complexity = complexity + 15*size(current_data_set,2); % same as CheckCoverage(...)
                CoverageRangeStatus = BasicCameraCoverage( current_data_set, CAM, pan, AOV, R_min, R_max);

                % count the weight at this pan
                cover_count = sum(CoverageRangeStatus(1,:));
                in_range_count = sum(CoverageRangeStatus(2,:));
                Weights( j , 1 + (pan/pan_step)) = cover_count/in_range_count;
                complexity = complexity + 2*size(CoverageRangeStatus, 2) + 1;
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
        complexity = complexity + size( Weights_vector , 1 )*size( Weights_vector , 2 )*log2(size( Weights_vector , 1 )*size( Weights_vector , 2 ));
        covered_set_indices = [];
        %uncovered_set_indices = 1:TargetCount;


        ind= I(1);% item with maximum weight
        ind_temp = mod( I(1), pans );
        complexity = complexity + 3;
        current_pan_index = ind_temp;
        current_cam = 1 + (I(1)-ind_temp)/pans;
        current_pan = ( current_pan_index - 1 ) * pan_step;
        % now test that at this pan and position which targets are covered
        cam_pos = cams( : , current_cam );
        complexity = complexity + 15*size(current_data_set , 2);
        current_coverage = BasicCameraCoverage( current_data_set, cam_pos', current_pan, AOV, R_min, R_max);
        for k = 1 : size(current_data_set,2)
            complexity = complexity + 2;
            if current_coverage(1,k) == 1
                covered_set_indices = [covered_set_indices; k];
            end
        end

        % make a new set of data with items 
        new_data_set = [];
        for i = 1 : size(current_data_set,2)
            complexity = complexity + 1;
            covered_flag = 0;
            complexity = complexity + size(covered_set_indices,2);
            found = find(covered_set_indices == i);
            complexity = complexity + 1;
            if isempty(found) % target i not yet covered
               new_data_set = [new_data_set, current_data_set(:,i)];
            end
        end
        new_data_set;
        current_data_set = new_data_set;
    end

    uncovered_num = size( current_data_set , 2 );
    %disp(' cfa complexity = ')
    complexity;
    result = [uncovered_num, complexity];
end
            
    
























