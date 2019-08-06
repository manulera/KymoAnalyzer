function [xcentre,ycentre] = imageCenterOfMass(img)
    img(isnan(img))=0;
    [x, y] = meshgrid(1:size(img, 2), 1:size(img, 1));
    weightedx = x .* img;
    weightedy = y .* img;
    xcentre = sum(weightedx(:)) / sum(img(:));
    ycentre = sum(weightedy(:)) / sum(img(:));
    
end

