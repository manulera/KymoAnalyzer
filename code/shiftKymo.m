function [new_kymo] = shiftKymo(kymo,shift,isleft)
    
    new_kymo = zeros(size(kymo));
    
    if isleft
        for i =1:size(new_kymo,1)
            new_line = kymo(i,shift(i):end);
            new_kymo(i,1:numel(new_line))=new_line;
        end
    else
        for i =1:size(new_kymo,1)
            new_line = kymo(i,1:shift(i));
            new_kymo(i,end-numel(new_line)+1:end)=new_line;
        end
    end
end

