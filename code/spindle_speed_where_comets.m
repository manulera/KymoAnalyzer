function [out] = spindle_speed_where_comets(spindle_length,kymo_lines)
    
    all_y = [];
    for i = 1:numel(kymo_lines)
        kl = kymo_lines{1};
        all_y = [all_y min(kl.y) max(kl.y)];
    end
    t = min(all_y):max(all_y);
    linfit = polyfit(t,spindle_length(t),1);
    out = linfit(1);
end

