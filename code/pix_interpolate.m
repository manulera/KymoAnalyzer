function [ xx,yy ] = pix_interpolate( x,y )
        min_val = round(min(x));
        max_val = round(max(x));
        x
        y
        xx = min_val:max_val;       
        yy = interp1(x,y,xx,'pchip');


end

