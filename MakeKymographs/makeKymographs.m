function [] = makeKymographs(folder)
%% Imports

% Import the movie
movie = readTiff([folder filesep 'movie.tif']);

% Load the mask
mask = ~logical(readTiff([folder filesep 'mask.tif']));

% Keep the biggest region in the mask (Some times there are tiny bits left out)
mask = bwareafilt(mask,1);

% Get the average background
nb_frames = size(movie,3);
background = zeros(1,nb_frames);

movie_sub = movie;
for i = 1:nb_frames
    d = movie(:,:,i);
    background(i) = mean(d(:));
    movie_sub(:,:,i) = d-background(i);
end

figure
imshow(max(movie_sub,[],3),[])
hold on
% Get the center of mass of the movie
[xc,yc]=imageCenterOfMass(max(movie_sub,[],3).*mask);

scatter(xc,yc)

if isfile([folder filesep 'extra_mask.tif'])
    mask = mask & logical(readTiff([folder filesep 'extra_mask.tif']));
    % Keep the biggest mask again
    mask = bwareafilt(mask,1);
end
%% Get the linear fits and the centers of all the kymos
if isfile([folder filesep 'settings.txt'])
    parabolla_frame=csvread([folder filesep 'settings.txt']);
else
    parabolla_frame = input('Provide a frame from which the fit will be done using a parabolla, zero otherwise: ');
end

if parabolla_frame==0
        parabolla_frame = inf;
end
linear_fits = strongestLines3(movie,mask,background,xc,yc,parabolla_frame);
%%
linear_fits_smooth = movmedian(linear_fits,20,1);
if parabolla_frame~=inf
    linear_fits_smooth(1:parabolla_frame-1,:) = movmedian(linear_fits(1:parabolla_frame-1,:),20,1);
    linear_fits_smooth(parabolla_frame:end,:) = movmedian(linear_fits(parabolla_frame:end,:),20,1);
end

dlmwrite([folder filesep 'linear_fits.txt'],linear_fits,' ');
dlmwrite([folder filesep 'linear_fits_smooth.txt'],linear_fits_smooth,' ');

[im_profiles,xx_profiles,yy_profiles] = profilesFromLines2(movie,linear_fits_smooth,'mean');

[kymo,centers] = assembleKymo3(im_profiles,xx_profiles,yy_profiles,xc,yc);
figure;imshow(kymo,[])

%%
dd = dir([folder filesep 'movi*.tif']);
for i =1:numel(dd)
    input_file = dd(i).name;
    if contains(input_file,'kymo')
        continue
    end
    
    input_file = [folder filesep input_file];
    
    movie = readTiff(input_file);
    [im_profiles] = profilesFromLines2(movie,linear_fits_smooth,'mean');
    kymo=kymoFromCenters(im_profiles,centers);
    output_file = [input_file(1:end-4) '_mean_kymo.tif' ];
    imwrite(uint16(kymo),output_file);
    
    [im_profiles] = profilesFromLines2(movie,linear_fits_smooth,'max');
    kymo=kymoFromCenters(im_profiles,centers);
    output_file = [input_file(1:end-4) '_max_kymo.tif' ];
    imwrite(uint16(kymo),output_file);
end
close all
end

