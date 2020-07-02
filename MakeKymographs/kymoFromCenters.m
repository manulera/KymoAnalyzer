function [kymo,keep] = kymoFromCenters(im_profiles,centers)

nb_frames = numel(im_profiles);
kymo = zeros(nb_frames,2000);


for i =1:nb_frames
    d = im_profiles{i};
    start = 1000-centers(i);
    finish = start+numel(d)-1;
    
    kymo(i,start:finish)=d;
    
end


% Chop the kymograph
logic = ~isnan(kymo) & kymo~=0;

keep = find(sum(logic)>20);

kymo = kymo(:,keep(1):keep(end));

end

