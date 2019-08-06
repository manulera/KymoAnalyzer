movie = readTiff('movie.tif');
movie_mean = imgaussfilt3(movie,2);
mask = ~logical(imread('mask.tif'));


%%
im_profiles = {};
gaus_profiles = {};
xx_profiles = {};
yy_profiles = {};
linear_fits = zeros(200,2);
for i = 1:200
    
    ima = movie(:,:,i);
    [xc,yc]=imageCenterOfMass(ima.*mask);

    ima_keep = ima(find(ima));
    background = 115;

    [result] = strongestLine(ima,mask,background,[0,1]);
    x = [xc-50,xc+50];
    y = -result(1)*x-result(2);
    [ss,xx,yy]=multiple_improfile(ima,x',y',3,1);
    this_prof = max(ss);
    im_profiles= [im_profiles this_prof];
    xx_profiles= [xx_profiles xx];
    yy_profiles= [yy_profiles yy];
    
    gaus_prof = max(multiple_improfile(movie_mean(:,:,i),x',y',3,1));
    gaus_profiles= [gaus_profiles gaus_prof];
    linear_fits(i,:) = result;
    
end
%%
figure
imshow(ima.*mask,[130,300],'InitialMagnification','fit')
hold on

plot(x,-result(1)*x-result(2))
scatter(xc,yc)

%%
kymo = zeros(200,1000);
kymo2 = zeros(200,1000);
edges = zeros(200,2);
kymo2_edges = zeros(200,4);
for i = 1:200
    
    
    
    d = im_profiles{i};
    gaus = imgaussfilt(gaus_profiles{i}-115,2);
    
    p = fit_step(gaus);
    x = 1:numel(gaus);

    fit = twostepfun(x,p(1),p(2),p(3),p(4),p(5));
    
    
    
    center = round(numel(d)/2);
    center2= round(sum(p(1:2))/2);
    [xc,yc]=imageCenterOfMass(d(center-40:center+40));
    
    start = 500-round(xc+(center-40));
    finish = start+numel(d)-1;
    
    kymo(i,start:finish)=d;
    
    start2 = 500-center2;
    finish2 = start2+numel(d)-1;
    
    kymo2(i,start2:finish2)=d;
    
    edges(i,:) = p(1:2)+start;
    p = round(p);
    p(p<1)=1;
    kymo2_edges(i,:) = [xx_profiles{i}(p(1)) yy_profiles{i}(p(1)) xx_profiles{i}(p(2)) yy_profiles{i}(p(2))];
   
    
end
%%
figure
% scatter(kymo2_edges(1:100,1),kymo2_edges(1:100,2),[],1:100)
hold on
plot(kymo2_edges(1:100,2))
plot(movmedian(kymo2_edges(1:100,2),6))
%%
timepoint = 30;

figure
imshow(kymo(:,350:650),[115,300],'InitialMagnification','fit')
hold on
plot(edges(:,:)-350,1:200)

%%

figure
imshow(kymo2(:,650:-1:350),[115,300],'InitialMagnification','fit')

%%
% figure
% bin1 = kymo(:,650:-1:350)>140;
% bin2 = bwareaopen(bin1,20);
% imshow(bin2,'InitialMagnification','fit')
hold on

x = 150+40;
plot([x,x],[0,400])

x = 150-40;
plot([x,x],[0,400])

plot([0,300],[timepoint,timepoint])


prof = im_profiles{timepoint}-115;
prof2 = prof;
prof2(isnan(prof))=0;

figure
subplot(2,1,1)
plot(cumsum(prof2.^2))

gaus = imgaussfilt(prof,2);
subplot(2,1,2)
plot(gaus)
hold on
plot(prof);
plot(diff(gaus,8))

%%
timepoint = 60;
prof = im_profiles{timepoint}-115;
gaus = imgaussfilt(prof,2);
x_peaks = islocalmax(gaus);
xx = 1:numel(x_peaks);

figure
plot(prof)
hold on
plot(gaus)
scatter(xx(x_peaks),gaus(x_peaks))

%%
timepoint = 25;
figure
kymo2=zeros(size(kymo));
for timepoint = 1
    prof = gaus_profiles{timepoint}-115;

    gaus = imgaussfilt(prof,2);
    p = fit_step(gaus);
    x = 1:numel(gaus);

    fit = twostepfun(x,p(1),p(2),p(3),p(4),p(5));
    
%     figure
    plot(gaus)
    hold on
    plot(fit)
end
%%
timepoint = 60;
figure
prof = im_profiles{timepoint};
gaus = imgaussfilt(prof,2);

hold on
plot(gaus)


prof = gaus_profiles{timepoint};
gaus = imgaussfilt(prof,2);

plot(prof)

%%
figure
plot(linear_fits(:,2))
plot(movelinear_fits(:,2))
