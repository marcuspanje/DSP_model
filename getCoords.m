%find the coordinates of a point given its
%distance from (x0, y0) and slope, m, and directtion
%(1 ->forward, 0 ->bacward).

function P = getCoords(d, x0, y0, m, direction)
if (m == Inf) | (m == -Inf)
    x = x0;
    y = y0 - d;
else
    syms x y;
    S = solve(d==sqrt((x-x0)^2+(y-y0)^2), m==(y-y0)/(x-x0));
    %convert to numeric form and return the max ans 
    P = double([S.x S.y]);
    maxx = max(P(:, 1));
    miny = min(P(:, 2));
end

xarr = P(:, 1);
yarr = P(:, 2);
if direction
    x = max(xarr);
else
    x = min(xarr);
end
y = min(yarr);
P = [x y];

end


