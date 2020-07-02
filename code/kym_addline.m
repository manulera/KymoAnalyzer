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
    if h.kymo_lines{end}.speed<0
        kymo_reassing_line(h,~h.kymo_lines{end}.isleft);
    end
    
end

