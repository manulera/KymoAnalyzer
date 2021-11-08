function [ default_order ] = membraneUnivarScatter2( this_data,ticks,colors,ylim_val,y_pos )
    % ylim_val [0,3], y_pos = -0.7
    % We squish the groups together in the x axis
    tick_pos = [1,2,3.5,4.5,6,7];
    
    univar_settings = {'MarkerFaceColor',colors};
    whiskers_settings = {'Whiskers','lines','SEMColor','k','StdColor','k','MarkerEdgeColor','white','LineWidth',1,'PointSize',40};
    univar_settings =  [whiskers_settings univar_settings {'xCenters',tick_pos}];
    
    
    
    [~,y,default_order,~,hh]=UnivarScatter(this_data(:,{'composed_condition','speed_min'}),univar_settings{:}); 
    
    xticks(tick_pos)
    set(gca,'xticklabel',ticks)
    
    ax = gca;
    ax.XAxis.FontSize = 18;
    xtickangle(20)
    xticks(tick_pos)
    set(gca,'xticklabel',ticks)
    ax = gca;
    ax.XAxis.FontSize = 18;
    xtickangle(20)
    
    
    ylim(ylim_val)
    xlim([0,8])
    
    hold on
    plot([1,2],[y_pos,y_pos],'k')
    plot([3.5,4.5],[y_pos,y_pos],'k')
    plot([6,7],[y_pos,y_pos],'k')
    text(1.5,y_pos,'before','VerticalAlignment','top','HorizontalAlignment','center','fontsize',18)
    text(4,y_pos,'outside','VerticalAlignment','top','HorizontalAlignment','center','fontsize',18)
    text(6.5,y_pos,'inside','VerticalAlignment','top','HorizontalAlignment','center','fontsize',18)
    ax = gca;               % get the current axis
    ax.Clipping = 'off';
    
end

