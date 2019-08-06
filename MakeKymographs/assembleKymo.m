function [kymo,edges] = assembleKymo(im_profiles,gaus_profiles,xx_profiles,yy_profiles,background)

nb_frames = numel(im_profiles);
if numel(background)~=nb_frames
    if numel(background)==1
        background = ones(1,nb_frames)*background;
    else
        error('background vector length and movie length should agree')
    end
end

kymo = zeros(nb_frames,1000);
edges = zeros(nb_frames,4);

% First round

for i = 1:nb_frames
    
    d = im_profiles{i};
    gaus = imgaussfilt(gaus_profiles{i}-background(i),2);
    
    p = fit_step(gaus);
    
    
    center= round(sum(p(1:2))/2);
    
    start = 500-center;
    finish = start+numel(d)-1;
    
    kymo(i,start:finish)=d;
    
    
    p = round(p);
    p(p<1)=1;
    p(p>numel(gaus))=numel(gaus);

    edges(i,:) = [xx_profiles{i}(p(1)) yy_profiles{i}(p(1)) xx_profiles{i}(p(2)) yy_profiles{i}(p(2))];
    
end

% Smoothening



% Chop the kymograph
logic = ~isnan(kymo) & kymo>0;

keep = find(sum(logic)>20);
kymo = kymo(:,keep(1):keep(end));


end

