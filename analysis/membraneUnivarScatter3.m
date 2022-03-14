function [ default_order ] = membraneUnivarScatter3( this_data,ticks,colors,ylim_val,y_pos, text_below, settings )
    % ylim_val [0,3], y_pos = -0.7
    % We squish the groups together in the x axis
    tick_pos = [1,2,3,4.5,5.5,6.5,8,9,10];
    
    if nargin < 7 || isempty(settings)
        univar_settings = {'MarkerFaceColor',colors};
        whiskers_settings = {'Whiskers','lines','SEMColor','k','StdColor','k','MarkerEdgeColor','white','LineWidth',1,'PointSize',40};
        univar_settings =  [whiskers_settings univar_settings {'xCenters',tick_pos}];
    else
        univar_settings = [settings {'xCenters',tick_pos}];
    end

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
    xlim([0,11])
    
    hold on
    if ~isempty(text_below)
        plot([1,3],[y_pos,y_pos],'k')
        plot([4.5,6.5],[y_pos,y_pos],'k')
        plot([8,10],[y_pos,y_pos],'k')
        text(2,y_pos,text_below{1},'VerticalAlignment','top','HorizontalAlignment','center','fontsize',18)
        text(5.5,y_pos,text_below{2},'VerticalAlignment','top','HorizontalAlignment','center','fontsize',18)
        text(9,y_pos,text_below{3},'VerticalAlignment','top','HorizontalAlignment','center','fontsize',18)
    end
    ax = gca;               % get the current axis
    ax.Clipping = 'off';
    
end

