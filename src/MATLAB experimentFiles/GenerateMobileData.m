% Data generation file
function Location = GenerateMobileData(dim1, dim2, TargetNum, seed, MaxTime, xspeed, yspeed)

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
 size(X)
 Y = randi(dim2, Dim, TargetNum);
 %Y = (randsample(dim2,TargetNum))'; 
 
% Y = X + randi(round(dim/2), Dim, TargetNum);
 Z = zeros(1,TargetNum);
for i = 1 : TargetNum 
    for t = 1 : MaxTime
        LocationX(i,t) = X( 1,i );%, Y( 1,i ), Z( 1,i ));
        LocationY(i,t) = Y( 1,i );
        LocationZ(i,t) = Z( 1,i );
    end
end
LocationX(2,1)
LocationY(2,1)
LocationZ(2,1)
for i = 1:TargetNum
    my_data(1,:,i) = [LocationX(i,1); LocationY(i,1); LocationZ(i,1)];
end
for j = 2 : MaxTime
    for i = 1:TargetNum
        %x = Location(i,j-1).x
        %y = Location(i,j-1).y
        %z = Location(i,j-1).z
        LocationX(i,j) = mod(LocationX(i,j-1)+xspeed, dim1);
        LocationY(i,j) = mod(LocationY(i,j-1)+yspeed, dim2);
        LocationZ(i,j) = LocationZ(i,j-1);
        %Location(i,j) = MobileObject(Location(i,j-1).x, Location(i,j-1).y, Location(i,j-1).z);
        %Location(i,j).x = mod(Location(i,j-1).x + 1, dim1);
    end
end
Location =[LocationX;LocationY;LocationZ]

end