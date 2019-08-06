function [im_profiles,xx_profiles,yy_profiles,im2_profiles] = profilesFromLines(movie,linear_fits,xc,yc,movie2)
    nb_frames = size(movie,3);
    
    
    line_span = 100;
    do_extra= false;
    
    im_profiles = cell(1,nb_frames);
    xx_profiles = cell(1,nb_frames);
    yy_profiles = cell(1,nb_frames);
    if nargin>4
        do_extra = true;
        im2_profiles = cell(1,nb_frames);
    end
    
    
    for i = 1:nb_frames
        
        ima = movie(:,:,i);
        
        [xc,yc]=projectPoint(xc,yc,linear_fits(i,1),linear_fits(i,2));
        
        % Parameters of the line in the for y = ax+b:
        
        a = -linear_fits(i,1);
        b = -linear_fits(i,2);
        
        % Unit vector
        v = [1,b]/(sqrt(1+b^2));
        
        % We use the parametric form of the line
        points1 = [xc,yc] - line_span*v;
        points2 = [xc,yc] + line_span*v;
        
        x = [points1(1),points2(1)];
        y = [points1(2),points2(2)];
        [ss,xx,yy]=multiple_improfile(ima,x',y',3,1,'bicubic');
        
        im_profiles{i}= ss;
        xx_profiles{i}= xx;
        yy_profiles{i}= yy;
        
        if do_extra
            ima2 = movie2(:,:,i);
            im2_profiles{i} = multiple_improfile(ima2,x',y',3,1);
        end
        
        
    end
    
    for i = 1:numel(im_profiles)
        im_profiles{i} = max(im_profiles{i});
        if do_extra
            im2_profiles{i} = mean(im2_profiles{i});
        end
        center = round(size(xx_profiles{i},1)/2);
        xx_profiles{i} = xx_profiles{i}(center,:);
        yy_profiles{i} = yy_profiles{i}(center,:);
    end
    
end

