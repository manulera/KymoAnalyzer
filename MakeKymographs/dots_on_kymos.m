
dd = dir(['.' filesep '*_kymo.tif']);
for i =1:numel(dd)
    input_file = dd(i).name;
    
    kymo = imread(input_file);
    figure
    
    imshow(kymo,[],'InitialMagnification','fit')
    hold on
    mini = mean(kymo(:));
    maxi = double(quantile(kymo(:),0.9));
    for j = 1:size(kymo,1)
        inds = find(islocalmax(imgaussfilt(kymo(j,:),2)));
        values = kymo(j,inds);
        weight = set_cmap(values,parula,mini,maxi);
        scatter(inds,j*ones(size(inds)),50,weight,'.')
    end
    
    
    title(input_file)
    
    
end