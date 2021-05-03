function [  ] = kymo_plot_mts( handles, aligned )
    
    dt = handles.info.timestep/60;
    res = handles.info.resolution;
    
    if ~isempty(handles.kymo_lines)
        for i =1:numel(handles.kymo_lines)
                
                obj = handles.kymo_lines{i};
                len = obj.mt_length(handles)*res;
                y = obj.y*dt;
                
                varar = {'LineWidth',2};
                if handles.currentline==i
                    varar = {'LineWidth',5};
                end
                if obj.isleft
                    plot(handles.ax_extra,y-aligned*y(1),len,'green',varar{:});
                else
                    plot(handles.ax_extra,y-aligned*y(1),len,'magenta',varar{:});
                end
                p.Color(4) = 0.8;
        end


    end
    
        
end

