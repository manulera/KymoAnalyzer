function [] = showLinearFit(movie,linear_fits,t)
    figure
    imshow(movie(:,:,t),[],'InitialMagnification','fit')
    hold on
    x = 1:size(movie,2);
    y = -linear_fits(t,1)*x - linear_fits(t,2);
    plot(x,y)
end

