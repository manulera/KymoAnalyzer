function [out] = fillUpFun(data)
    out = zeros(size(data));
    for i = 1:numel(data)
        before = nanmax(data(1:i));
        after = nanmax(data(i:end));
        if isnan(before) || isnan(after)
            out(i) = nan;
        else
            out(i) = min(before,after);
        
    end
end

