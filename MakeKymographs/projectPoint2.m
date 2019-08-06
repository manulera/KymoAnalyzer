function [x2,y2] = projectPoint2(xp,yp,ang,x0,y0)
    
    t = cos(ang)*(xp-x0) + sin(ang)*(yp-y0);
    x2 = x0 +t*cos(ang);
    y2 = y0 +t*cos(ang);

end

