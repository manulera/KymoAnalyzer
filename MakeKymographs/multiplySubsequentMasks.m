function [mask2] = multiplySubsequentMasks(mask)
    
    if size(mask,3)<3
        error('mask should have at least 3 timepoints')
    end
    mask2 = zeros(size(mask)); 
    for i =2:(size(mask,3)-1)
        mask2(:,:,i) = mask(:,:,i-1).*mask(:,:,i).*mask(:,:,i+1);
    end
    
    mask2(:,:,1)=mask2(:,:,2);
    mask2(:,:,end)=mask2(:,:,end-1);

end

