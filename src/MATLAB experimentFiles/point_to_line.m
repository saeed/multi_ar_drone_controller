function d = point_to_line(pt, v_1, v_2)
a = v_1 - v_2;
b = pt - v_2;
d = norm(cross(a,b)) / norm(a);