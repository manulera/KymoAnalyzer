function [] = kymo_extraplot_profile(handles)
    t = round(get(handles.slider1,'Value'));
    col_ord = get(gca,'ColorOrder');
    
    xx = double(handles.kymo(t,:));
%     xx = double(mean(handles.kymo(t-1:t+1,:)));
    
    % Just to not see the outside in the plot
    xx(xx==0)=nan;
    plot(handles.ax_extra,xx,'LineWidth',2)
    
    plot(handles.ax_extra,imgaussfilt(xx,2),'LineWidth',2)
    
%     small_kymo = handles.kymo;
%     small_kymo = imgaussfilt(small_kymo,2);
%     xx = small_kymo(t,:);
    
    
    
    
    
    if ~isempty(handles.left_edge)
        % edge lines
        left_line = interp1(handles.left_edge.y,handles.left_edge.x,t,'pchip');
        right_line = interp1(handles.right_edge.y,handles.right_edge.x,t,'pchip');
        plot(handles.ax_extra,[left_line left_line],[handles.int_low_lim,handles.int_high_lim],'color','green','LineWidth',2)
        plot(handles.ax_extra,[right_line right_line],[handles.int_low_lim,handles.int_high_lim],'color','magenta','LineWidth',2)

        % lines corresponding to tracks
        for i = 1:numel(handles.kymo_lines)
            kl = handles.kymo_lines{i};
            if kl.y(1)<t && kl.y(end)>t
                line = interp1(kl.y,kl.x,t,'pchip');
                color_ind = mod(i,size(col_ord,1));
                if ~color_ind
                    color_ind=size(col_ord,1);
                end
                plot(handles.ax_extra,[line line],[handles.int_low_lim,handles.int_high_lim],'LineWidth',2,'color',col_ord(color_ind,:))
            end
        end
    end
end