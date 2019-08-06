function [] = displayLinearFit(movie,linear_fits,t)
    ima = movie(:,:,t);
    figure
    imshow(ima,[])
    hold on
    x = [0,200];
    y = -linear_fits(t,1)*x-linear_fits(t,2);
    plot(x,y)
    
end

