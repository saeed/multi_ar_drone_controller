function projection = project(pt, v1, v2)
v = v1 -v2
v = v / norm(v)
u = pt - v1
projection = v1 + dot(u,v)*v
end

