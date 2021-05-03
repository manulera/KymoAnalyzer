function [  ] = kymo_extraplot( handles, what )
    
    dt = handles.info.timestep/60;
    res = handles.info.resolution;
    yl1 = 0;
    yl2 = inf;
    
    hold(handles.ax_extra,'off')
    cla(handles.ax_extra)
    hold(handles.ax_extra,'on')
    
    switch what
    
        case 'microtubules aligned'
            kymo_plot_mts(handles,1)
        case 'microtubules not aligned'   
            kymo_plot_mts(handles,0)
        case 'speeds'
            if isempty(handles.spindle_length)
                return;
            end
            for i = 1:numel(handles.kymo_lines)
                kl = handles.kymo_lines{i};
                scatter(handles.ax_extra,kl.y(1)*dt,kl.speed*res/dt)
            end
            speed = movmean(diff(handles.spindle_length),60);
            t = (1:numel(speed))*dt;
            plot(handles.ax_extra,t,speed*res/dt)
        case 'spindle'
            if isempty(handles.spindle_length)
                return;
            end
            t = (1:numel(handles.spindle_length))*dt;
            plot(handles.ax_extra,t,handles.spindle_length*res);
        case 'profile'
            kymo_extraplot_profile(handles);
            yl1=handles.int_low_lim;
            yl2= handles.int_high_lim;
%             ylim([yl1,yl2])
        case 'movie'
            t = round(get(handles.slider1,'Value'));
            imshow(handles.movie(:,:,t),[handles.int_low_lim,handles.int_high_lim],'Parent',handles.ax_extra)
            drawKymoLinesOnFrame(handles,t)
            return
            
    end
    xlim([0,inf])
    ylim([0,inf])
%     ylim([yl1,yl2])
end

