function result = Greedyfunc(data, AOV_degree, R_min, R_max, pan_step, Dim1_min, Dim1_max, Dim2_min, Dim2_max, TargetCount)
    complexity = 0;
    % implementing CFA:
    %AOV_degree = 45;
    AOV = (AOV_degree * 2*pi)/360; %60 degrees camera Angle of View
    verbose = 0;
    %R_min = 0.0001;%0.01; % 0.5m
    %R_max = 30; % 3m


    %pan_step = pi/6; % pan angle changes in 30 degrees steps

    %Dim1_min = 0;
    %Dim2_min = 0;
    %Dim1_max = 20; %maximum in x-axis (m)
    %Dim2_max = 20; %maximum in y-axis (m)
    complexity = complexity + 2;
    %xmargin = margin_ratio * Dim1_max;%(1/6)*Dim1_max; % do not place cameras at the edges. We want them in the middle
    %ymargin = margin_ratio * Dim2_max; %(1/6)*Dim2_max;
   
    %TargetCount = 10;
    %seed = 3;
    % generate location of targets
    %data = GenerateData(Dim1_max, Dim2_max, TargetCount,seed); 
    my_data = data(1:2,:);
    %fraction of targets below which we allow uncovered targets
   
    grid_step_x = 1;
    grid_step_y = 1;
    pans = ceil((2*pi)/pan_step);
    xsteps = 1 + ceil((Dim1_max- Dim1_min)/grid_step_x);
    ysteps = 1 + ceil((Dim2_max- Dim2_min)/grid_step_y);

    Rank = zeros( xsteps, ysteps, pans );
    complexity = GridCoverageLookupFunc(data,AOV_degree, R_min, R_max, pan_step, Dim1_min, Dim1_max, Dim2_min, Dim2_max, TargetCount);
    load GridCoverageCoeffs;
    coeffs = C;
    
    
    
    
    %cams = [ x' ; y'; z];
    pans = (2*pi)/pan_step;

    current_data_set = data;
    uncovered_num = TargetCount;
    target_ind = 1;
    cam_iteration = 0;
    while ((uncovered_num > 0) & (cam_iteration < round(TargetCount/2)))
    
        cam_iteration = cam_iteration + 1;
        Rank = zeros( xsteps, ysteps, pans );
        complexity = complexity + GridCoverageLookupFunc(current_data_set, AOV_degree, R_min, R_max, pan_step, Dim1_min, Dim1_max, Dim2_min, Dim2_max, uncovered_num);
        load GridCoverageCoeffs;
        coeffs = C;

        for i = 1 : xsteps
            for j = 1 : ysteps
                for k = 1 : pans
                    for target_ind = 1 : uncovered_num
                        if coeffs( i, j, k, target_ind ) == 1
                            Rank( i , j , k ) = Rank( i , j , k ) + 1;
                            complexity = complexity + 1;
                        end
                    end
                end
            end
        end

        % now find the camera-pos-pan combination
        Rank_vector = zeros( 1 , xsteps*ysteps*pans );
        h = 1;
        for i = 1 : xsteps
            for j = 1 : ysteps
                for k = 1 : pans
                    Rank_vector( 1 , h ) = Rank( i , j , k );
                    h = h + 1;
                end
            end
        end
        [ sorted_ranks , I ] =  sort( Rank_vector , 'descend');
        complexity = complexity + size( Rank_vector , 1 )*size( Rank_vector , 2 )*log2(size( Rank_vector , 1 )*size(Rank_vector , 2 ));
        covered_set_indices = [];

        ind= I(1);% item with maximum weight
        ind 
        if ( mod(ind,ysteps*pans) == 0 )
            x_ind = floor(ind/(ysteps*pans))
            y_residue = ind - (x_ind)*ysteps*pans % = 0
            y_ind = ysteps %floor(y_residue/pans)
            pan_ind = pans %y_residue - (y_ind )*pans
            
        else
            x_ind = floor(ind/(ysteps*pans)) + 1
            y_residue = ind - (x_ind - 1)*ysteps*pans
            if ( mod(y_residue , pans) == 0 )
                y_ind = floor(y_residue/pans)
                pan_ind = pans
            else
                y_ind = 1 + floor(y_residue/pans) 
                pan_ind = y_residue - (y_ind - 1)*pans
            end
        end
        
        

        complexity = complexity + 3;
        current_x = Dim1_min + (x_ind-1)*grid_step_x;
        current_y = Dim2_min + (y_ind-1)*grid_step_y;
        current_pan = (pan_ind-1)*pan_step
        cam_pos = [current_x; current_y; 0]
        % now test that at this pan and position which targets are covered
        %complexity = complexity + 15*size(current_data_set , 2);
        if (cam_pos == [17;7;0])
            
            verbose = 1;
        end
        current_coverage = BasicCameraCoverage( current_data_set, cam_pos', current_pan, AOV, R_min, R_max,verbose)
        for k = 1 : size(current_data_set,2)
            complexity = complexity + 2;
            
            if (coeffs( x_ind, y_ind, pan_ind, k) == 1)
            %if current_coverage(1,k) == 1
                covered_set_indices = [covered_set_indices; k];
            end
        end
        covered_set_indices
        current_data_set
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
        uncovered_num = size( current_data_set , 2 )
        
    
    end
    
    result = [cam_iteration; uncovered_num; complexity];
end
            
    
























