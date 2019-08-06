function [result] = strongestLineAngle(ima,mask,bg,sugg)
% sugg(1)=atan(sugg(1));
fun = @(pars) weightFunctionAngle(ima,mask,bg,pars);

opts = optimset('MaxFunEvals',5000, 'MaxIter',1000);

result = fminsearch(fun, sugg, opts);
end

