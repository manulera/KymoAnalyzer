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
    % For a normal one assign the one with highest speed
    if is_special == 0 || is_special == 1
        speed_before = h.kymo_lines{end}.speed;
        kymo_reassing_line(h,~h.kymo_lines{end}.isleft)
        speed_inverted = h.kymo_lines{end}.speed;
        if speed_before > speed_inverted
            kymo_reassing_line(h,~h.kymo_lines{end}.isleft)
        end

    % For a shrinking one assign the one with smallest (more negative) speed
    elseif is_special == 2
        speed_before = h.kymo_lines{end}.speed;
        kymo_reassing_line(h,~h.kymo_lines{end}.isleft)
        speed_inverted = h.kymo_lines{end}.speed;
        if speed_before < speed_inverted
            kymo_reassing_line(h,~h.kymo_lines{end}.isleft)
        end
    end

end

