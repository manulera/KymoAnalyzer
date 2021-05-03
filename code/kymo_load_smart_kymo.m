function [handles] = kymo_load_smart_kymo(handles)
    
    [handles.smart_kymo]=repeatSmartKymo(handles.pathfile);
    handles.fits = dlmread([handles.pathfile filesep 'linear_fits_smooth.txt'],' ');
    handles.movie = readTiff([handles.pathfile filesep 'movie.tif']);
    handles.mask = readTiff([handles.pathfile filesep 'mask.tif']);
    nb_frames = size(handles.movie,3);
    background = zeros(1,nb_frames);
    movie_sub = handles.movie;
    
    for i = 1:nb_frames
        d = handles.movie(:,:,i);
        background(i) = mean(d(:));
        movie_sub(:,:,i) = d-background(i);
    end
    [handles.xc,handles.yc]=imageCenterOfMass(max(movie_sub,[],3).*handles.mask);
    
end

