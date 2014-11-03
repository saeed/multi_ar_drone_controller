function angle = interAngle(u1, u2)
u = dot(u1, u2);
angle = acos( u / (norm(u1)*norm(u2)) ); 
end
