function [h] = kym_addline(h,is_special)
    if nargin<2||isempty(is_special)
        is_special=false;
    end
    axes(h.ax_main)
    
    h.kymo_lines{end+1}= kymo_line(size(h.kymo,1),is_special);
    
    h.currentline = numel(h.kymo_lines);
    if ~iscell(h.kymo_lines)
        h.kymo_lines = {h.kymo_lines};
    end
    
    h.kymo_lines{end}.apply_shift(h);
    
    h.kymo_lines{end}.calc_speed(h);
    
    % Automatically assing left right based on the speed.
    
    switch is_special
        % For a normal one assign the one with highest speed
        case 0
            if h.kymo_lines{end}.speed<0
                kymo_reassing_line(h,~h.kymo_lines{end}.isleft);
            end
        % For a special one (not clear end or begining, tipically slow),
        % assign to the closest pole
        case 1
            % First timepoint of the line
            x1 = h.kymo_lines{end}.x(1);
            y1 = h.kymo_lines{end}.y(1);
            if abs(x1-h.left_edge.x(y1)) < abs(x1-h.right_edge.x(y1))
                kymo_reassing_line(h,true);
            else
                kymo_reassing_line(h,false);
            end
        case 2
            if h.kymo_lines{end}.speed>0
                kymo_reassing_line(h,~h.kymo_lines{end}.isleft);
            end
    end

end

