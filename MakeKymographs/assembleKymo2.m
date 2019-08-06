function [kymo,smooth_edges,edges_kymo,centers] = assembleKymo2(im_profiles,gaus_profiles,xx_profiles,yy_profiles,background)

nb_frames = numel(im_profiles);
if numel(background)~=nb_frames
    if numel(background)==1
        background = ones(1,nb_frames)*background;
    else
        error('background vector length and movie length should agree')
    end
end


edges = zeros(nb_frames,4);

% First round

for i = 1:nb_frames
    
    gaus = imgaussfilt(gaus_profiles{i}-background(i),2);
    
    p = fit_step(gaus);
    
    p = round(p);
    p(p<1)=1;
    p(p>numel(gaus))=numel(gaus);
    edges(i,:) = [xx_profiles{i}(p(1)) yy_profiles{i}(p(1)) xx_profiles{i}(p(2)) yy_profiles{i}(p(2))];
    figure
    plot(gaus)
    hold on
    title(num2str(i))
    plot(twostepfun(1:numel(gaus),p(1),p(2),p(3),p(4),p(5)))
    pause(0.5)
    close
end

% Smoothening

smooth_edges = movmedian(edges,30,1);
centers = zeros(nb_frames,1);
edges_kymo = zeros(nb_frames,2);
for i =1:nb_frames
    [~,x1] = min(abs(smooth_edges(i,1) - xx_profiles{i}));
    [~,y1] = min(abs(smooth_edges(i,2) - yy_profiles{i}));
    [~,x2] = min(abs(smooth_edges(i,3) - xx_profiles{i}));
    [~,y2] = min(abs(smooth_edges(i,4) - yy_profiles{i}));
    centers(i) = round(mean([x1,y1,x2,y2]));
    edges_kymo(i,:)=[mean(x1,y1),mean(x2,y2)]-centers(i);
end


[kymo,keep]=kymoFromCenters(im_profiles,centers);
edges_kymo = edges_kymo-keep(1)+1000;

end

