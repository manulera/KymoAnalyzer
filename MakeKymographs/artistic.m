movie=readTiff('artistic.tif');


[a,b]=max(movie,[],3);
b = size(movie,3)-b;

c = std(movie,[],3);
%%
figure
colormap hot
imagesc(c.^0.1)
axis equal
xlim([0,size(movie,2)])
cc = c.^0.1;
cc = (cc-min(cc(:)))./(max(cc(:))-min(cc(:)));
imwrite(cc,'artistic.tif');
%%
figure
imshow(a.^0.3,[])
axis equal