function [linear_fits] = strongestLines2(movie,mask,background,xc,yc)
nb_frames = size(movie,3);
if numel(background)~=nb_frames
    if numel(background)==1
        background = ones(1,nb_frames)*background;
    else
        error('background vector length and movie length should agree')
    end
end

linear_fits = zeros(nb_frames,2);
barry = waitbar(0,'Doing linear fits');

% As suggested value we can give the linear fit to the cell mask
lis = regionprops(mask,'PixelList');
xx = lis.PixelList(:,1);
yy = lis.PixelList(:,2);
sugg = polyfit(xx,yy,1);

% % If the cell is perpendicular, we transpose the movie to be able to fit
transposing=false;
if abs(sugg(1))>5
    transposing=true;
end

figure
cla
for i = 90:nb_frames
    waitbar(i/nb_frames)
    ima = movie(:,:,i);
    if transposing
        [result] = strongestLine2(ima',mask,background(i),[atan(sugg(1)),xc,yc]);
        result(1) = 1/result(1);
        linear_fits(i,:) = result;
    else
    [result] = strongestLine2(ima,mask,background(i),-sugg,xc,yc);
    linear_fits(i,:) = result;
    end
    

    imshow(ima,[],'InitialMagnification','fit')
    hold on
    x = [0,200];
    y = -result(1)*x-result(2);
    plot(x,y)
    pause(0.5)
    
%     
end
close(barry)
end

