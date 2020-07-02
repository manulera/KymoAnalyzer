function [xx,yy] = kymo2coord(t,kymo_lines,smart_kymo)
% [xx,yy] = kymo2coord(t,y,smartkymo)
% Takes a value defined by t,kl.x(t) in a kymograph and returns the xx,yy
% position xx,yy of the reference in the movie at time t

xx = zeros(1,numel(kymo_lines));
yy = zeros(1,numel(kymo_lines));

for i = 1:numel(kymo_lines)
    x = kymo_lines{i}.x;
    index = find(kymo_lines{i}.y==t);
    if ~isempty(index)
        xx(i)=smart_kymo.x_kymo(t,round(x(index)));
        yy(i)=smart_kymo.y_kymo(t,round(x(index)));
    end
end

end

