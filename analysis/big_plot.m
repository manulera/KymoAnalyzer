[~,out] = system(['echo ./*/*/kymos/kymo??/*s.csv']);
all_files = strsplit(out);
empty_ones = cellfun('isempty',all_files);
all_files = all_files(~empty_ones);

figure('Position',[100,100,550,550])
hold on

all_individual = [];
for i = 1:numel(all_files)
    
    folder = all_files{i}(1:end-22);
    spindle = csvread([folder filesep 'speed_spindle.csv']);
    individual = csvread([folder filesep 'speed_microtubules.csv']);
    all_individual = [all_individual; individual];
    %plot(spindle(:,1),spindle(:,2))
    scatter(individual(:,1),individual(:,2),300,'.')
    corrcoef(individual(:,1),individual(:,2))
end

[xx,yy,ys,ystd] = bin_ave_line(all_individual(:,1),all_individual(:,2),1:12);

for i = 1:numel(xx)
    x = [xx(i) xx(i)];
    y = [yy(i)-ys(i),yy(i)+ys(i)];
    y2 = [yy(i)-ystd(i),yy(i)+ystd(i)];
    plot(x,y2,'LineWidth',4,'Color','black')
    plot(x,y,'LineWidth',4,'Color',[0.7 0.7 0.7])
end
set(gca,'FontSize',20)
plot(xx,yy,'LineWidth',4,'Color','Black')
xlim([4,12])
xlabel('Spindle Length (\mum)')
ylabel('Elongation speed(\mum /min)')
print2eps('big_plot.eps')
