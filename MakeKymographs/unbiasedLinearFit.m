function [result] = unbiasedLinearFit(x,y)
    
    fun = @(pars) weightFunctionUnbiased(x,y,pars);

    opts = optimset('MaxFunEvals',5000, 'MaxIter',1000);

    result = fminsearch(fun, sugg, opts);
    if ~second_degree
        result(4)=0;
    end
end

