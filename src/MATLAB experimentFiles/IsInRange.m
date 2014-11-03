function inRange = IsInRange( x, y, dim1_min, dim2_min, dim1_max, dim2_max, margin )


if ((x < dim1_min + margin) || (x > dim1_max - margin) || (y < dim2_min + margin) || (y > dim2_max - margin))
   inRange = 0;
else
    inRange = 1;
end

