function [ xx,yy,ys,ystd ] = bin_ave_line( x,y,bins )
    
    xx = nan(1,numel(bins)-1);
    yy = nan(1,numel(bins)-1);
    ys = nan(1,numel(bins)-1);
    ystd = nan(1,numel(bins)-1);
    for i =2:numel(bins)
        xx(i) = mean([bins(i),bins(i-1)]);
        inds = x>bins(i-1) & x<=bins(i);
        if any(inds)
            data = y(inds);
            yy(i) = mean(data);
            ys(i) = std(data)/sqrt(length(data));
            ystd(i) = std(data);
        end
    end

end

