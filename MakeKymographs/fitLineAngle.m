function [result] = fitLineAngle(x,y)
    
    sugg = [pi/2,mean(x),mean(y)];
    

    fun = @(pars) weightFunctionAngle(x,y,pars);

    opts = optimset('MaxFunEvals',5000, 'MaxIter',1000);

    result = fminsearch(fun, sugg, opts);
end

