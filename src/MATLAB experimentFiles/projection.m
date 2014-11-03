function proj = projection(pt, v1, v2)
v = v1 -v2;
v = v / norm(v);
u = pt - v1;
proj = v1 + dot(u,v)*v;
end

