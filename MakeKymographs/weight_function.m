function [weight] = weight_function(ima,mask,background,a,b,xc,yc)
    
%     if abs(a)>300||abs(a)<0.01
%         weight = inf;
%         return;
%     end
        

    % Project the point on the line
    [xc,yc] = projectPoint(xc,yc,a,b);
    
    lis = regionprops(mask,ima,'PixelList','PixelValues');
    xx = lis.PixelList(:,1);
    yy = lis.PixelList(:,2);
    zz = lis.PixelValues;
    
    dist = abs((a*xx + yy + b)/sqrt(1+a^2));
    
    dist_center2 = sqrt((xx-xc).^2 + (yy-yc).^2);
    weight = abs(zz-background).^2.*exp(-dist_center2(:)/150);
%     weight = abs(zz-background).^2;
    
    
    weight = sum(dist(:).*weight(:)) ;
    
end

