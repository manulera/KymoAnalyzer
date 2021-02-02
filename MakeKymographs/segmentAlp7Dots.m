function [segmented_dots] = segmentAlp7Dots(folder)
    % Segment every frame in an Alp7-3GFP movie, fitting the distribution
    % of intensities to a Poisson? distribution and taking the mean + 4std
    % as a threshold.
    % Takes the gaussian movie and the mask as inputs, generates a movie
    % with segmented images called segmented_alp7.tif
    % Also returns the movie
    
    
    gauss_stack=readTiffStack([folder filesep 'movie_bleach_corrected_gauss1.tif']);
    mask = ~logical(imread([folder filesep 'mask.tif']));

    segmented_dots = zeros(size(gauss_stack));

    for i = 1:size(gauss_stack,3)

        ima = gauss_stack(:,:,i);
        [bg,st] = image_background(ima(mask));
        
        % Use the average + 4 standrd deviations as threshold
        dot_mask = ima>(bg+2*st);
        
        % Remove small regions (<4 dots)
        dot_mask=bwareaopen(dot_mask,4);
        segmented_dots(:,:,i) = dot_mask;

    end
    segmented_dots = logical(segmented_dots);
    writeTiffStack(segmented_dots,[folder filesep 'segmented_dots.tif'])
 
end

