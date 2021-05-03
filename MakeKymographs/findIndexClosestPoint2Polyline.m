function [centers] = findIndexClosestPoint2Polyline(xx_profiles,yy_profiles,xc,yc)
% xx_profiles, and yy_profiles describe the line along which the intensity
% profile was calculated. Here we find the index of points xx,yy where the
% coordinate is closest to the point xc,yc, which is the center of mass of
% the time projection of the image.

nb_frames = numel(xx_profiles);


centers = zeros(nb_frames,1);

for i =1:nb_frames
    dists = (xc - xx_profiles{i}).^2 + (yc - yy_profiles{i}).^2;
    [~,centers(i)] = nanmin(dists);
end

end

