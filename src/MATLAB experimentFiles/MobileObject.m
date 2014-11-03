classdef MobileObject 
    properties
        x;
        y;
        z;
    end
    
    methods
        function obj = MobileObject(x,y,z)
           % class constructor
                 obj.x = x;
                 obj.y   = y;
                 obj.z    = z;
        end
    end
    
end