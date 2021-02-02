function [] = repeatKymographs(folder)
%% Imports

% Import the movie
movie = readTiff([folder filesep 'movie.tif']);

%% 1. Get the center of mass inside the cell mask

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

%% Load the linear fits from before

% linear_fits_smooth = dlmread([folder filesep 'linear_fits.txt'],' ');
linear_fits_smooth = dlmread([folder filesep 'linear_fits_smooth.txt'],' ');

nb_frames = min([nb_frames,size(linear_fits_smooth,1)]);
%% Get the image profiles
[im_profiles,xx_profiles,yy_profiles] = profilesFromLines2(movie(:,:,1:nb_frames),linear_fits_smooth,'mean');

[kymo,centers] = assembleKymo3(im_profiles,xx_profiles,yy_profiles,xc,yc);
figure;imshow(kymo,[])

dd = dir([folder filesep 'movi*.tif']);
for i =1:numel(dd)
    input_file = dd(i).name;
    if contains(input_file,'kymo')
        continue
    end
    
    input_file = [folder filesep input_file];
    
    movie = readTiff(input_file);
    movie = movie(:,:,1:nb_frames);
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

