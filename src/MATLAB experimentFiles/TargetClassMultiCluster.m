classdef TargetClassMultiCluster
    %UNTITLED3 Summary of this class goes here
    % each target point is an object of this class
    %   Detailed explanation goes here
    
    properties
        x;
        y;
        z;
        cluster_index1;
        cluster_index2;
    end
    
    methods
        function obj = TargetClassMultiCluster(x,y,z,cluster_ind1,cluster_ind2)
           % class constructor
                 obj.x = x;
                 obj.y   = y;
                 obj.z    = z;
                 obj.cluster_index1  = cluster_ind1;
                 obj.cluster_index2  = cluster_ind2;
        end
    end
    
end