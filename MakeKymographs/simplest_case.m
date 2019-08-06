ima = binim;
mask = ones(size(binim));
ima = ima*1000;
ima = ima + 1;
[result] = strongest_line(ima,mask,[0,1]);
result
lis = regionprops(mask,ima,'PixelList','PixelValues');
xx = lis.PixelList(:,1);
yy = lis.PixelList(:,2);
zz = lis.PixelValues;
% result = [1, -24];
figure
scatter(xx(zz>1),yy(zz>1))
hold on
plot(xx,-result(1)*xx-result(2))

%%
figure
x = linspace(-30,-20);
tot = [];
for xx = x 
    tot = [tot weight_function(ima,mask,1,xx)];
end
[a,b] = min(tot);
plot(x,tot)



%%
figure
x = linspace(-3,3);
tot = [];
for xx = x 
    tot = [tot weight_function(ima,mask,xx,-26.26)];
end

plot(x,tot)