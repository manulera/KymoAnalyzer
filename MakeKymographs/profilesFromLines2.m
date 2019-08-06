function [im_profiles,xx_profiles,yy_profiles] = profilesFromLines2(movie,linear_fits,mode)
    nb_frames = size(movie,3);
    
%     line_span = 100;
    
    im_profiles = cell(1,nb_frames);
    xx_profiles = cell(1,nb_frames);
    yy_profiles = cell(1,nb_frames);
    
    
    
    for i = 1:nb_frames
        
        ima = movie(:,:,i);
        
%         [xc,yc]=projectPoint2(xc,yc,linear_fits(i,1),linear_fits(i,2),linear_fits(i,3));
%         
%         
%         % Unit vector
%         v = [cos(linear_fits(i,1)),sin(linear_fits(i,1))];
%         
%         % We use the parametric form of the line
%         points1 = [xc,yc] - line_span*v;
%         points2 = [xc,yc] + line_span*v;
%         
%         x = [points1(1),points2(1)];
%         y = [points1(2),points2(2)];
        [ss,xx,yy]=multipleImprofileCurve(ima,linear_fits(i,:),3,1,'bicubic');
%         [ss,xx,yy]=multiple_improfile(ima,x',y',3,1,'bicubic');
        
        im_profiles{i}= ss;
        xx_profiles{i}= xx;
        yy_profiles{i}= yy;
        
        
        
        
    end
    
    for i = 1:numel(im_profiles)
        
        switch mode
            case 'mean'
                im_profiles{i} = nanmean(im_profiles{i});
            case 'max'
                im_profiles{i} = max(im_profiles{i});
            otherwise
                error('No valid method provided')
        end
        center = round(size(xx_profiles{i},1)/2);
        xx_profiles{i} = xx_profiles{i}(center,:);
        yy_profiles{i} = yy_profiles{i}(center,:);
    end
    
end

