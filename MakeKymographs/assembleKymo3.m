function [kymo,centers] = assembleKymo3(im_profiles,xx_profiles,yy_profiles,xc,yc)

nb_frames = numel(im_profiles);


centers = zeros(nb_frames,1);

for i =1:nb_frames
    dists = (xc - xx_profiles{i}).^2 + (yc - yy_profiles{i}).^2;
    [~,centers(i)] = nanmin(dists);
end

[kymo]=kymoFromCenters(im_profiles,centers);


end

