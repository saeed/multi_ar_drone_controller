function f = mymin(x)
    size(x)
    n = size(x,2)/2; 
    coeff = ones(1,size(x,2));
    size(coeff)
    f = coeff'*x;
%     for i = 1 : n 
%         f = f + x(n+i)*x(i)*(1-x(i));
%     end
end