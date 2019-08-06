function [values] = set_cmap(data,cmap,mini,maxi)
    data = double(data);
    nb_cols = size(cmap,1);
    values = zeros(numel(data),3);
    for i =1:numel(data)
        v = round((data(i)-mini)/(maxi-mini)*nb_cols);
        
        if v>nb_cols
            v=nb_cols;
        end
        if v<1
            v=1;
        end
        
        values(i,:) = cmap(v,:);
        
    end

end

