figure

hold on
kl = handles.left_edge;
plot(kl.y,kl.x)

interp_x = round(min(kl.y)):round(max(kl.y));

vals = interp1(kl.y,kl.x,interp_x,'pchip');

vals = round(vals);
plot(interp_x, vals)
axis equal
%%

xx = 1:size(handles.kymo,1);
interp_shift = zeros(1,size(handles.kymo,1));
interp_shift(1:interp_x(1)) = vals(1);
interp_shift(interp_x) = vals;
interp_shift(interp_x(end):end) = vals(end);
%%
max_shift = max(interp_shift);

siz = size(handles.kymo);
new_kymo = zeros(size(handles.kymo));


for i =1:size(new_kymo,1)
    new_line = handles.kymo(i,interp_shift(i):end);
    new_kymo(i,1:numel(new_line))=new_line;
end

figure
imshow(new_kymo,[120,300])