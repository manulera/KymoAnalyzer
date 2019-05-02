classdef kymo_line < handle
    
properties
    %% Main properties
    x
    y
    x_shift
    x_shift_left
    x_shift_right
    isleft
    speed
end

methods
    %% Constructor and related
    function obj = kymo_line()
        [obj.x,obj.y] = getpts();
        obj.x_shift = obj.x;
        obj.x_shift_left = obj.x;
        obj.x_shift_right = obj.x;
        obj.isleft = 1;
    end
    function obj = hard_copy(obj,other)
        obj.x = other.x;
        obj.y = other.y;
        obj.x_shift = other.x_shift;
        obj.isleft = other.isleft;
    end
    function p = plot_line(obj,varargin)
        p = plot(obj.x,obj.y,varargin{:});
    end
    function p = plot_shift(obj,varargin)
        p = plot(obj.x_shift,obj.y,varargin{:});
    end
    function obj = shift(obj,shift)
        obj.x_shift = obj.x +shift;
    end
    function calc_speed(obj)
        if obj.isleft
            [xx,yy] = pix_interpolate(obj.y,obj.x_shift_left);
            pf = polyfit(xx,yy,1);
            %pf = polyfit(obj.y,obj.x_shift_left,1);
            pf(1) = -pf(1);
        else
            [xx,yy] = pix_interpolate(obj.y,obj.x_shift_right);
            pf = polyfit(xx,yy,1);
            %pf = polyfit(obj.y,obj.x_shift_right,1);
        end
        obj.speed = pf(1);
    end
    
    function out = interpolate(obj, ima_size)
        min_val = round(min(obj.y));
        max_val = round(max(obj.y));
        if max_val>ima_size
            max_val = ima_size;
        end
        if min_val<1
            min_val = 1;
        end
            
        interp_x = min_val:max_val;
            
        vals = interp1(obj.y,obj.x,interp_x,'pchip');
        vals = round(vals);

        out = zeros(1,ima_size);
        out(1:interp_x(1)) = vals(1);
        out(interp_x) = vals;
        out(interp_x(end):end) = vals(end);
    end
end
end