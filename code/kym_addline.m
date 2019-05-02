function [h] = kym_addline(h)
    axes(h.ax_main)
    
    h.kymo_lines{end+1}= kymo_line();
    h.currentline = numel(h.kymo_lines);
    if ~iscell(h.kymo_lines)
        h.kymo_lines = {h.kymo_lines};
    end
end

