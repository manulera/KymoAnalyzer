%% Imports
folder = '.';
% Import the movie
movie = readTiff([folder filesep 'movie.tif']);

% Apply gaussian filter in time (this is used to align the movies)
movie_mean = imgaussfilt3(movie,2);

% Load the mask
mask = ~logical(readTiff([folder filesep 'mask.tif']));

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
%% Get the linear fits and the centers of all the kymos
linear_fits = strongestLines(movie,mask,background,xc,yc);
linear_fits_smooth = movmedian(linear_fits,20,1);

%%
[im_profiles,xx_profiles,yy_profiles,gaus_profiles] = profilesFromLines(movie,linear_fits_smooth,xc,yc,movie_mean);
%%
[kymo,centers] = assembleKymo3(im_profiles,xx_profiles,yy_profiles,xc,yc);
figure;imshow(kymo,[]);hold on; scatter(60,150)

%%
dd = dir('./movi*.tif');
for i =1:numel(dd)
    input_file = dd(i).name;
    if contains(input_file,'kymo')
        continue
    end
    
    output_file = [input_file(1:end-4) '_kymo.tif' ];
    
    movie = readTiff(input_file);
    [im_profiles] = profilesFromLines(movie,linear_fits_smooth,xc,yc,movie_mean);
    kymo=kymoFromCenters(im_profiles,centers);
    
    imwrite(uint16(kymo),output_file);
end