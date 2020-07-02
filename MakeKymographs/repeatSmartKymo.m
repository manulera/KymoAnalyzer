function [] = repeatSmartKymo(folder)
    
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

% Get the center of mass of the movie
[xc,yc]=imageCenterOfMass(max(movie_sub,[],3).*mask);

%% Load the linear fits from before

% linear_fits_smooth = dlmread([folder filesep 'linear_fits.txt'],' ');
linear_fits_smooth = dlmread([folder filesep 'linear_fits_smooth.txt'],' ');

%% Get the image profiles
[im_profiles,xx_profiles,yy_profiles] = profilesFromLines2(movie,linear_fits_smooth,'mean');

[~,centers] = assembleKymo3(im_profiles,xx_profiles,yy_profiles,xc,yc);

for i = 1:numel(im_profiles)
    nan_values = isnan(im_profiles{i});
    xx_profiles{i}(nan_values) = nan;
    yy_profiles{i}(nan_values) = nan;
end

x_kymo = kymoFromCenters(xx_profiles,centers);
y_kymo = kymoFromCenters(yy_profiles,centers);

save([folder filesep 'smart_kymo.mat'],'x_kymo','y_kymo')

end

