function [] = kym_show(handles)
    
    
    axes(handles.ax_extra)    
    hold off
    cla
    hold on
    kymo_extraplot(handles, handles.menu_plot.String{handles.menu_plot.Value})
    
    axes(handles.ax_main)
    hold off
    cla
    
    if handles.shifted
        ima = handles.kymo_shifted;
        if handles.shifted>0
            shifter = -handles.left_edge.x;
        else
            shifter = -handles.right_edge.x+size(handles.kymo,2);
        end
    else
        shifter = zeros(1,size(handles.kymo,1));
        ima = handles.kymo;
    end
    imshow(ima,[handles.int_low_lim, handles.int_high_lim],'InitialMagnification','Fit')
%     ss = size(ima);
%     xlim([100,ss(2)-100])
    hold on
    t = round(get(handles.slider1,'Value'));
    plot([2,size(handles.kymo,2)-1],[t t],'color','yellow')
    plot([10,10],[10,300/handles.info.timestep],'Linewidth',4,'color','yellow')
    text([10],[5],'5 min','Color','yellow')
    if ~isempty(handles.left_edge)
        handles.left_edge.plot_line(shifter,'green','LineWidth',1);
    end
    if ~isempty(handles.right_edge)
        handles.right_edge.plot_line(shifter,'magenta','LineWidth',1);
    end
    
    if handles.tog_current.Value && ~isempty(handles.kymo_lines)
        p = handles.kymo_lines{handles.currentline}.plot_line(shifter,'LineWidth',3);
        p.Color(4) = 0.8;
    elseif handles.butt_left_right.Value && ~isempty(handles.kymo_lines)
        
        for i =1:numel(handles.kymo_lines)
            kl = handles.kymo_lines{i};
            if kl.isleft
                p = kl.plot_line(shifter,'green','LineWidth',3);
            else
                p = kl.plot_line(shifter,'magenta','LineWidth',3);
            end
            p.Color(4) = 0.8;
        end
        p = handles.kymo_lines{handles.currentline}.plot_line(shifter,'red','LineWidth',5);
        
    else
        col_ord = get(gca,'ColorOrder');
        for i =1:numel(handles.kymo_lines)
            color_ind = mod(i,size(col_ord,1));
            if ~color_ind
                color_ind=size(col_ord,1);
            end
            p = handles.kymo_lines{i}.plot_line(shifter,'LineWidth',3,'color',col_ord(color_ind,:));
            p.Color(4) = 0.8;
        end
        if ~isempty(handles.kymo_lines)
            p = handles.kymo_lines{handles.currentline}.plot_line(shifter,'red','LineWidth',5);
        end
    end
    
    
    
end

