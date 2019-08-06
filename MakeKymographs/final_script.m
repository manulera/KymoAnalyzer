movie = readTiff('movie.tif');
movie_bleach_gauss = readTiff('movie_bleach_gaus1.tif');
movie_mean = imgaussfilt3(movie,2);
mask = ~logical(imread('mask.tif'));
background = 115;

%%

linear_fits = strongestLines(movie_bleach_gauss,mask,background);
%%
linear_fits_smooth = movmedian(linear_fits,20,1);


[im_profiles,xx_profiles,yy_profiles,gaus_profiles] = profilesFromLines(movie_bleach_gauss,mask,linear_fits_smooth,background,movie_mean);

for i = 1:numel(im_profiles)
    im_profiles{i} = max(im_profiles{i});
    gaus_profiles{i} = mean(gaus_profiles{i});
    center = round(size(xx_profiles{i},1)/2);
    xx_profiles{i} = xx_profiles{i}(center,:);
    yy_profiles{i} = yy_profiles{i}(center,:);
end




[kymo,edges] = assembleKymo2(im_profiles,gaus_profiles,xx_profiles,yy_profiles,background);


figure
imshow(kymo(:,:),[115,250],'InitialMagnification','fit')
hold on
scatter(90,40)
% plot(edges_kymo(:,2),1:size(kymo,1))
%%

figure
hold on
for t = 20:25

    plot(imgaussfilt(kymo(t,:)-background,2))
end

ylim([-20,inf])

%%
t= 40;
figure;imshow(movie(:,:,t),[],'InitialMagnification','fit');
hold on
plot(xx_profiles{t}',yy_profiles{t}')
% scatter(edges(t-5:t+5,3),edges(t-5:t+5,4))


