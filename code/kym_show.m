function [] = kym_show(handles)
    
    
    kymo_extraplot(handles, handles.menu_plot.String{handles.menu_plot.Value})
    
    %% Plot the main axis
    hold(handles.ax_main,'off')
    cla(handles.ax_main)
    
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
    imshow(ima,[handles.int_low_lim, handles.int_high_lim],'InitialMagnification','Fit','Parent',handles.ax_main)
    hold(handles.ax_main,'on')
    ss = size(ima);
    xlim_low = 0;
    xlim_high = inf;
    
    if ~isempty(handles.edit_xlim_low.String)
        xlim_low = str2double(handles.edit_xlim_low.String);
    end
    if ~isempty(handles.edit_xlim_high.String)
        xlim_high = str2double(handles.edit_xlim_high.String);
    end
    xlim([xlim_low,xlim_high])
    hold(handles.ax_main,'on')
    if isfield(handles,'kymo_is_special') && handles.kymo_is_special
        text(handles.ax_main,[0],[5],'SPECIAL','Color','RED')
    end
    t = round(get(handles.slider1,'Value'));
    % plot horizontal line marking the time in the kymograph
    plot(handles.ax_main,[2,size(handles.kymo,2)-1],[t t],'color','yellow')
    
    % plot 2 horizontal lines marking the velocity section in the
    % kymograph
    if isfield(handles,'velocity_section')
        for ii = 1:2
            plot(handles.ax_main,[2,size(handles.kymo,2)-1],handles.velocity_section(ii)*[1 1],'color','green')
        end
    end
    
    plot(handles.ax_main,[10,10],[10,300/handles.info.timestep],'Linewidth',4,'color','yellow')
    text(handles.ax_main,[10],[5],'5 min','Color','yellow')
    text(handles.ax_main,[30],[5],num2str(t),'Color','yellow')
    text(handles.ax_main,size(handles.kymo,2)-20,5,sprintf('%u/%u',handles.current_kymo,numel(handles.all_kymos)),'Color','yellow')
    if ~isempty(handles.left_edge)
        handles.left_edge.plot_line(shifter,handles.ax_main,'green','LineWidth',1);
    end
    if ~isempty(handles.right_edge)
        handles.right_edge.plot_line(shifter,handles.ax_main,'magenta','LineWidth',1);
    end
    
    if isfield(handles,'left_membrane')
        handles.left_membrane.plot_line(shifter,handles.ax_main,'green','LineWidth',1);
    end
    if isfield(handles,'right_membrane')
        handles.right_membrane.plot_line(shifter,handles.ax_main,'magenta','LineWidth',1);
    end
    
    if handles.tog_current.Value && ~isempty(handles.kymo_lines)
        p = handles.kymo_lines{handles.currentline}.plot_line(shifter,handles.ax_main,'LineWidth',3);
        p.Color(4) = 0.8;
    elseif handles.butt_left_right.Value && ~isempty(handles.kymo_lines)
        
        for i =1:numel(handles.kymo_lines)
            kl = handles.kymo_lines{i};
            if kl.isleft
                p = kl.plot_line(shifter,handles.ax_main,'green','LineWidth',3);
            else
                p = kl.plot_line(shifter,handles.ax_main,'magenta','LineWidth',3);
            end
            if kl.is_special~=2 && kl.speed<0
                kl.scatter_first(shifter,handles.ax_main);
            end
            p.Color(4) = 0.8;
        end
        p = handles.kymo_lines{handles.currentline}.plot_line(shifter,handles.ax_main,'red','LineWidth',5);
        
    else
        col_ord = get(gca,'ColorOrder');
        for i =1:numel(handles.kymo_lines)
            color_ind = mod(i,size(col_ord,1));
            if ~color_ind
                color_ind=size(col_ord,1);
            end
            p = handles.kymo_lines{i}.plot_line(shifter,handles.ax_main,'LineWidth',3,'color',col_ord(color_ind,:));
            p.Color(4) = 0.8;
        end
        if ~isempty(handles.kymo_lines)
            p = handles.kymo_lines{handles.currentline}.plot_line(shifter,handles.ax_main,'red','LineWidth',5);
        end
    end
    
    
    
end

