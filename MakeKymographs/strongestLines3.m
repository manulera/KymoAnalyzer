function [linear_fits] = strongestLines3(movie,mask,background,xc,yc,parabolla_frame)

nb_frames = size(movie,3);
if numel(background)~=nb_frames
    if numel(background)==1
        background = ones(1,nb_frames)*background;
    else
        error('background vector length and movie length should agree')
    end
end

linear_fits = zeros(nb_frames,4);

barry = waitbar(0,'Doing helping linear fits');

% As suggested value we can give the linear fit to the cell mask
lis = regionprops(mask,'Orientation');
sugg_ang = -deg2rad(lis.Orientation);


% Fits to slices of 13
ave_slice = 6;
linear_fits_help = zeros(1,4);
linear_fits_ind = [];
for i = ave_slice+1:2*ave_slice+1:nb_frames
    waitbar(i/nb_frames)
    if i+ave_slice>nb_frames
        break
    end
    ima = mean(movie(:,:,i-ave_slice:i+ave_slice),3);
    do_parabolla = i>=parabolla_frame;
    [pars] = weightedOrthogonalFit(ima,mask,background(i),[sugg_ang,xc,yc,0],do_parabolla,1);
    linear_fits_help = [linear_fits_help;pars];
    linear_fits_ind = [linear_fits_ind i];
end
close(barry)
barry = waitbar(0,'Doing linear fits');
linear_fits_help(1,:)=[];
linear_fits_ind(end)=nb_frames;
% figure
% cla
for i = 1:nb_frames
    waitbar(i/nb_frames)
    ima = movie(:,:,i);
    do_parabolla = i>=parabolla_frame;
    jj = find(i<=linear_fits_ind,true,'first');
    [pars] = weightedOrthogonalFit(ima,mask,background(i),linear_fits_help(jj,:),do_parabolla,1);
    if ~do_parabolla
        pars(4)=0;
    end
    linear_fits(i,:) = pars;
%     pars(4)=0;
% Line
%     d = linspace(-150,150);
%     vect = [cos(pars(1)), sin(pars(1))];
%     x = pars(2)+vect(1)*d;
%     y = pars(3)+vect(2)*d;
%     

% Curve
%     x = linspace(-150,150);
%     y = x.^2*pars(4);
%     
%     
%     theta = -pars(1);
%     R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
%     coords = [x; y]' * R;
%     x = coords(:,1);
%     y = coords(:,2);
%     x = x+pars(2);
%     y = y+pars(3);
%     
%     
%     
%     imshow(ima,[],'InitialMagnification','fit')
%     hold on
%     
%     plot(x,y)
%     pause(0.5)
    
%     
end
close(barry)
end

