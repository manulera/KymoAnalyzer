create_binim=0;
if create_binim==0
    % Create a binary image
    Dasize = [25,25];
    binim=zeros(Dasize);
    close all
    figure;
    ax=gca;
    while true
        imagesc(binim, [0,1])
        hold on 
        plot([0,25],[12.5,12.5],'w')
        plot([12.5,12.5],[0,25],'w')
        axis equal
        set(gca,'xtick',0.5:1:Dasize(1));
        set(gca,'ytick',0.5:1:Dasize(1));
        set(gca,'xticklabel',[])
        set(gca,'yticklabel',[])
        grid on
        hold on
        ax.GridLineStyle = '-';
        ax.GridColor = [1 1 1];
        coords = floor(ginput(1)+0.5);
        if any(coords<=0) || any(coords>Dasize(1))
            break
        end
        binim(coords(2),coords(1))=abs(1-binim(coords(2),coords(1))); 
        cla
    end
    close all
elseif create_binim==1
    array_in=load('Porquelast');
    binim=imresize(array_in.binim7,0.25);
    Dasize = size(binim);  
    binim=bwperim(binim);
    
end
binimplot=binim;
binim=fliplr(flipud(binim));
[y,x] = ind2sub(Dasize,find(binim));
[yplot,xplot] = ind2sub(Dasize,find(flipud(binimplot)));
output_array=[x y];
output_array(:,1)=abs(Dasize(1)-output_array(:,1));

size_clue=[length(output_array),Dasize(1)];
csvwrite('binim',[size_clue; output_array])
