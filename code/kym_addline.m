function [h] = kym_addline(h)
    axes(h.ax_main)
    
    h.kymo_lines{end+1}= kymo_line(size(h.kymo,1));
    
    h.currentline = numel(h.kymo_lines);
    if ~iscell(h.kymo_lines)
        h.kymo_lines = {h.kymo_lines};
    end
    
    h.kymo_lines{end}.apply_shift(h);
    h.kymo_lines{end}.calc_speed(h);
    
    if h.kymo_lines{end}.speed<0
        h.kymo_lines{end}.isleft = ~h.kymo_lines{end}.isleft;
        h.kymo_lines{end}.apply_shift(h);
        h.kymo_lines{end}.calc_speed(h);
    end
    
end

