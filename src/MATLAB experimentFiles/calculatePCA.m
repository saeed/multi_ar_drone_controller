function eigenVectors = calculatePCA(data, Num)
   
sum_x = 0;
sum_y = 0;
sum_z = 0;
for i = 1 : Num
    sum_x = sum_x + data( 1 , i );
    sum_y = sum_y + data( 2, i );
end
mean_x = sum_x / Num;
mean_y = sum_y / Num;
mean = [mean_x; mean_y];

S = zeros(4,4);
for i = 1 : Num
    S = S + ( data( : , i ) - mean )*( data( : , i ) - mean )';
end

[V,D] = eig(S)
eigenVectors = V;
