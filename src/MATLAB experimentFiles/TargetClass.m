classdef TargetClass
    %UNTITLED3 Summary of this class goes here
    % each target point is an object of this class
    %   Detailed explanation goes here
    
    properties
        x;
        y;
        z;
        cluster_index;
    end
    
    methods
        function obj = TargetClass(x,y,z,cluster_ind)
           % class constructor
                 obj.x = x;
                 obj.y   = y;
                 obj.z    = z;
                 obj.cluster_index  = cluster_ind;
        end
    end
    
end

