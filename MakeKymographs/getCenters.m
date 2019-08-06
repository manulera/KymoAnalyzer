function [centers] = getCenters(folder,linear_fits_smooth)
    

% Import the movie
    movie = readTiff([folder filesep 'movie.tif']);

    % Apply gaussian filter in time (this is used to align the movies)
    movie_mean = imgaussfilt3(movie,2);

    % Load the mask
    mask = ~logical(readTiff([folder filesep 'mask.tif']));

    % Get the average background
    nb_frames = size(movie,3);
    background = zeros(1,nb_frames);

    for i = 1:nb_frames
        d = movie(:,:,i);
        background(i) = mean(d(:));
    end

    [im_profiles,xx_profiles,yy_profiles,gaus_profiles] = profilesFromLines(movie,mask,linear_fits_smooth,background,movie_mean);
    [kymo,~,~,centers] = assembleKymo2(im_profiles,gaus_profiles,xx_profiles,yy_profiles,background);
end

