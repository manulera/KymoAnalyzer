function [pars] = fit_step(data)
    
    x = 1:numel(data);
    fun = @(p) nansum(abs(twostepfun(x,p(1),p(2),p(3),p(4),p(5))-data));

    opts = optimset('MaxFunEvals',50000, 'MaxIter',10000);
    sugg = [numel(data)/3,numel(data)*2/3,quantile(data,0.3),max(data)/2,quantile(data,0.3)];
    pars = fminsearch(fun, sugg, opts);
end

