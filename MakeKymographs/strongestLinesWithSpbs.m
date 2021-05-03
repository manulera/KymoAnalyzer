function [old_format] = strongestLinesWithSpbs(movie,mask,background,spb_1,spb_2)

nb_frames = size(movie,3);
if numel(background)~=nb_frames
    if numel(background)==1
        background = ones(1,nb_frames)*background;
    else
        error('background vector length and movie length should agree')
    end
end

parab_fits = zeros(nb_frames,1);

barry = waitbar(0,'Doing helping parabolla fits');

% Fits to slices of 13 (for parabollas)
ave_slice = 6;
parabolla_fits_help = zeros(1,1);
parabolla_fits_ind = [];
for i = ave_slice+1:2*ave_slice+1:nb_frames
    waitbar(i/nb_frames)
    if i+ave_slice>nb_frames
        break
    end
    
    ima = mean(movie(:,:,i-ave_slice:i+ave_slice),3);
    
    pars=weightedOrthogonalFitConstrained(ima,mask,background(i),spb_1(i,:),spb_2(i,:),1);
    
    parabolla_fits_help = [parabolla_fits_help;pars];
    parabolla_fits_ind = [parabolla_fits_ind i];
end

parabolla_fits_help(1,:)=[];
parabolla_fits_ind(end)=nb_frames;

close(barry)
barry = waitbar(0,'Doing fits');

for i = 1:nb_frames
    waitbar(i/nb_frames)
    ima = movie(:,:,i);
    jj = find(i<=parabolla_fits_ind,true,'first');
    sugg = parabolla_fits_help(jj,:);
    parab_fits(i,:) = weightedOrthogonalFitConstrained(ima,mask,background(i),spb_1(i,:),spb_2(i,:),1,sugg);
    
end
% Smooth the fits
parab_fits = movmedian(parab_fits,10,1);
old_format= zeros(nb_frames,4);
% Convert to the old format
for i = 1:nb_frames
    old_format(i,:) = convertParabollaFit2OldFit(spb_1(i,:),spb_2(i,:),parab_fits(i,:));
end

close(barry)
end

