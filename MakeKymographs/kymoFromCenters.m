function [kymo,keep] = kymoFromCenters(im_profiles,centers,keep)

% Now you can pass keep as an argument. This is for making kymographs of
% different width using the same line. Otherwise the edges will not match.


if nargin<3||isempty(keep)
    keep = [];
end

nb_frames = numel(im_profiles);
kymo = zeros(nb_frames,2000);


for i =1:nb_frames
    d = im_profiles{i};
    start = 3000-centers(i);
    finish = start+numel(d)-1;
    
    kymo(i,start:finish)=d;
    
end

if isempty(keep)
    % Chop the kymograph
    logic = ~isnan(kymo) & kymo~=0;

    keep = find(sum(logic)>20);
end
    kymo = kymo(:,keep(1):keep(end));
end

