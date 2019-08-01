classdef kymo_line < handle
    
properties
    %% Main properties
    x
    y
    isleft
    speed
end

methods
    %% Constructor and related
    function obj = kymo_line(ima_size)
        [obj.x,obj.y] = getpts();
        obj.isleft = 1;
        obj.interpolate(ima_size);
    end
    function obj = hard_copy(obj,other)
        obj.x = other.x;
        obj.y = other.y;
        obj.isleft = other.isleft;
    end
    function p = plot_line(obj,shifter,varargin)
        p = plot(abs(obj.x+shifter(obj.y)),obj.y,varargin{:});
    end
    function len = mt_length(obj,handles)
        % Length of the microtubule from the edge
        
        if ~obj.isleft
            kymo_edge = handles.left_edge;
            sign=1;
        else
            kymo_edge = handles.right_edge;
            sign=-1;
        end
        
        len = sign*(obj.x-kymo_edge.x(obj.y));
    end
    
    function calc_speed(obj,handles)
        len = mt_length(obj,handles);
        pf = polyfit(obj.y,len,1);        
        obj.speed = pf(1);
    end
    
    function interpolate(obj, ima_size)
        min_val = round(min(obj.y));
        max_val = round(max(obj.y));
        if max_val>ima_size
            max_val = ima_size;
        end
        if min_val<1
            min_val = 1;
        end
            
        interp_x = min_val:max_val;
            
        obj.x = interp1(obj.y,obj.x,interp_x,'pchip');
        obj.y = interp_x;
%         out = zeros(1,ima_size);
%         out(1:interp_x(1)) = vals(1);
%         out(interp_x) = vals;
%         out(interp_x(end):end) = vals(end);
    end
    
    function extend_edge(obj,ima_size)
        out = zeros(1,ima_size);
        out(1:obj.y(1)) = obj.x(1);
        out(obj.y) = obj.x;
        out(obj.y(end):end) = obj.x(end);
        obj.y = 1:ima_size;
        obj.x = out;
    end
    
    function apply_shift(obj,h)
        if ~h.shifted
            return
        end
        
        if h.shifted>0
            obj.x = obj.x + h.left_edge.x(obj.y);
        else
            kymo_edge = size(h.kymo,2);
            obj.x = h.right_edge.x(obj.y) - kymo_edge + obj.x;
        end
        
        
    end
end
end