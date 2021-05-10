function [] = repeatKymographs(folder,membrane_only)
if nargin<2||isempty(membrane_only)
    membrane_only = false;
end
%% Imports

% Import the movie
movie = readTiff([folder filesep 'movie.tif']);
config_file = [folder filesep 'kymo_config.txt'];
if isfile(config_file)
    config = readConfigFile(config_file);
    fits_file = config.fits_file;
    kymo_line_width = [];
    kymo_line_width = 5;
    if isfield(config,'line_width')
        kymo_line_width = str2double(config.line_width);
    end
    wrap_angles=(isfield(config,'wrap_angles') && config.wrap_angles=='1');
    
else
    fits_file = 'linear_fits_smooth.txt';
end

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

linear_fits_smooth = dlmread([folder filesep 'linear_fits.txt'],' ');
% linear_fits_smooth = dlmread([folder filesep 'linear_fits_smooth.txt'],' ');


% Wrap angles
if wrap_angles
    wrapN = @(x) (1 + mod(x-1, pi));
    toWrap=linear_fits_smooth(:,1)>=pi;
    linear_fits_smooth(toWrap,4) = -linear_fits_smooth(toWrap,4);
    linear_fits_smooth(:,1) = wrapN(linear_fits_smooth(:,1));
end

nb_frames = min([nb_frames,size(linear_fits_smooth,1)]);
%% Get the image profiles

[im_profiles,xx_profiles,yy_profiles] = profilesFromLines2(movie(:,:,1:nb_frames),linear_fits_smooth,'mean',kymo_line_width);

[centers] = findIndexClosestPoint2Polyline(xx_profiles,yy_profiles,xc,yc);

[kymo,keep]=kymoFromCenters(im_profiles,centers);

figure;imshow(kymo,[])

dd = dir([folder filesep '*.tif']);

if membrane_only 
    dd = dir([folder filesep '*_membrane.tif']);
end

for i =1:numel(dd)
    input_file = dd(i).name;
    if contains(input_file,'kymo')||contains(input_file,'mask.tif')
        continue
    end
    
    input_file = [folder filesep input_file];
    
    movie = readTiff(input_file);
    if contains(input_file,'probs')
        movie=multiplySubsequentMasks(movie)*256;
    end
    movie = movie(:,:,1:nb_frames);
    
    [im_profiles] = profilesFromLines2(movie,linear_fits_smooth,'mean',kymo_line_width);
    kymo=kymoFromCenters(im_profiles,centers,keep);
    output_file = [input_file(1:end-4) '_mean_kymo.tif' ];
    imwrite(uint16(kymo),output_file);
    
    [im_profiles] = profilesFromLines2(movie,linear_fits_smooth,'max',kymo_line_width);
    kymo=kymoFromCenters(im_profiles,centers,keep);
    output_file = [input_file(1:end-4) '_max_kymo.tif' ];
    imwrite(uint16(kymo),output_file);
end
close all
end

