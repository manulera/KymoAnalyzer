function [] = makeKymographs(folder,config_file)

if nargin<2||isempty(config_file)
        config_file = [folder filesep 'kymo_config.txt'];
    if ~isfile(config_file)
        template = '/Users/Manu/Documents/Projects/Matlab/ImageAnalysis/KymoAnalyzer/MakeKymographs/config/config_mal3D.txt';
        % Copy the config file
        copyfile(template,config_file);
    end
    
    
end

config = readConfigFile(config_file);

%% Imports

% Use a mask for each frame of the movie
segmented_mask = 1;
if isfield('movie_mask',config)
    if strcmp(config.mode,'alp7')
        if isfile([folder filesep config.movie_mask])
            segmented_mask=~logical(readTiffStack([folder filesep config.movie_mask]));
        else
            segmented_mask=segmentAlp7Dots(folder);
        end
    end
    
    segmented_mask=double(segmented_mask);
    segmented_mask(~logical(segmented_mask))=nan;
end

% Import the movie
movie = readTiff([folder filesep config.main_movie]);

if strcmp(config.multiply_subsequent,'1')
    movie=multiplySubsequentMasks(movie);
end

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

if strcmp(config.mode,'alp7')
    linear_fits = strongestLines3(movie.*segmented_mask,mask,background,xc,yc,parabolla_frame);
elseif strcmp(config.mode,'mal3D')
    if isfile([folder filesep 'spb_mask.tif'])
        spb_mask = ~logical(readTiff([folder filesep 'spb_mask.tif']));
    else
        spb_mask=1;
    end
    figure
    imshow(spb_mask)
    [linear_fits,spb_1,spb_2] = findSpindlesSpbsAlp7(movie,mask,background,parabolla_frame,spb_mask);
    dlmwrite([folder filesep 'spbs.txt'],[spb_1,spb_2])
else
    linear_fits = strongestLines3(movie,mask,background,xc,yc,parabolla_frame);
end

%%
linear_fits_smooth = movmedian(linear_fits,20,1);
if parabolla_frame~=inf
    linear_fits_smooth(1:parabolla_frame-1,:) = movmedian(linear_fits(1:parabolla_frame-1,:),20,1);
    linear_fits_smooth(parabolla_frame:end,:) = movmedian(linear_fits(parabolla_frame:end,:),20,1);
end

dlmwrite([folder filesep 'linear_fits.txt'],linear_fits,' ');
dlmwrite([folder filesep 'linear_fits_smooth.txt'],linear_fits_smooth,' ');

%%
repeatKymographs(folder)
end

