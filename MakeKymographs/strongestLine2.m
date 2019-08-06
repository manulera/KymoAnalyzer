function [result] = strongestLine2(ima,mask,bg,sugg,xc,yc)

sugg(1)=atan(sugg(1));
fun = @(pars) weight_function2(ima,mask,bg,pars(1),pars(2),xc,yc);

opts = optimset('MaxFunEvals',5000, 'MaxIter',1000);

result = fminsearch(fun, sugg, opts);

result(1) = tan(result(1));
result
end

