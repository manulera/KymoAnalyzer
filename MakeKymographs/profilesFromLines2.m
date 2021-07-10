function [im_profiles,xx_profiles,yy_profiles] = profilesFromLines2(movie,linear_fits,mode,profile_width)
    
    
    if nargin<4||isempty(profile_width)
        profile_width = 3;
    end
    nb_frames = min([size(movie,3),size(linear_fits,1)]);
    
    
    
    im_profiles = cell(1,nb_frames);
    xx_profiles = cell(1,nb_frames);
    yy_profiles = cell(1,nb_frames);
    
    
    
    for i = 1:nb_frames
        
        ima = movie(:,:,i);
    try
        [ss,xx,yy]=multipleImprofileCurve(ima,linear_fits(i,:),profile_width,1,'bicubic');
    catch
        error('Error in:\nframe %u\n',i)
    end
        im_profiles{i}= ss;
        xx_profiles{i}= xx;
        yy_profiles{i}= yy;
        
%         cla
%         imshow(ima,[],'InitialMagnification','fit')
%         hold on
%         scatter(xx(4,:),yy(4,:))
%         pause(0.05)
%         title(num2str(i))
        
    end
    
    for i = 1:numel(im_profiles)
        
        switch mode
            case 'mean'
                im_profiles{i} = nanmean(im_profiles{i});
                center = round(size(xx_profiles{i},1)/2);
                xx_profiles{i} = xx_profiles{i}(center,:);
                yy_profiles{i} = yy_profiles{i}(center,:);
            case 'max'
                im_profiles{i} = max(im_profiles{i});
                center = round(size(xx_profiles{i},1)/2);
                xx_profiles{i} = xx_profiles{i}(center,:);
                yy_profiles{i} = yy_profiles{i}(center,:);
            case 'raw'
                % Do nothing
            otherwise
                error('No valid method provided')
        end
        
    end
    
end

