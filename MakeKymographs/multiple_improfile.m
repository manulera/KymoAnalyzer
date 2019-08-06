function [ints,xx,yy] = multiple_improfile(ima,x,y,range,spacing,method)
    
if nargin<6
    method = 'nearest';
end

% Perpendicular to the slope of the line
slope = [diff(y)/diff(x),-1];
slope = slope/norm(slope);

% We calculate perpendicular displacements from the line of value 'spacing'
% from the points at the edges of the line given by x and y

disp = -range*spacing:spacing:range*spacing;

poly=resamplePolyline([x,y],round(sqrt(diff(x)^2+diff(y)^2)));
x = poly(:,1);
y = poly(:,2);

% The matrix where we will store the values
nb_vals = numel(x);
nb_slices = range*2+1 ;

ints = nan(nb_slices,nb_vals);

% figure
% imshow(ima,[])
% hold on
% plot(x,y)
% uiwait
xx = x+disp*slope(1);
xx = xx';
yy = y+disp*slope(2);
yy = yy';

for i =1:nb_slices
    ints(i,:) = improfile(ima,xx(i,:),yy(i,:),nb_vals,method);
end

end

