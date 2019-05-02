function [] = kymo_extraplot_profile(handles)
    t = round(get(handles.slider1,'Value'))
    xx = handles.kymo(t,:);
    
    plot(xx,'LineWidth',2)
    
    if ~isempty(handles.left_edge)
        % edge lines
        left_line = interp1(handles.left_edge.y,handles.left_edge.x,t,'pchip');
        right_line = interp1(handles.right_edge.y,handles.right_edge.x,t,'pchip');
        plot([left_line left_line],[handles.int_low_lim,handles.int_high_lim],'color','green','LineWidth',2)
        plot([right_line right_line],[handles.int_low_lim,handles.int_high_lim],'color','magenta','LineWidth',2)

        % lines corresponding to tracks
        for i = 1:numel(handles.kymo_lines)
            kl = handles.kymo_lines{i};
            if kl.y(1)<t && kl.y(end)>t
                line = interp1(kl.y,kl.x,t,'pchip');
                plot([line line],[handles.int_low_lim,handles.int_high_lim],'LineWidth',2)
            end
        end
    end
end