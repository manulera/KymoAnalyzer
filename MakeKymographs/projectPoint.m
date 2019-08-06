function [x1,y1] = projectPoint(x0,y0,a,b)
    
    x1 = (x0-a*y0-a*b)/(a^2+1);
    y1 = -x1*a - b;
    
end

