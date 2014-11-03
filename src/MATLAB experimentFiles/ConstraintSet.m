function [c,ceq]=ConstraintSet(X)
    c = [];
    for i = 1 : size(X,1)
        ceq(i) = X(i) - X(i)^2;
    end
end

