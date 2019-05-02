function [  ] = kymo_plot_mts( handles, aligned )
    
%     figure 
%     hold on
    dt = handles.info.timestep/60;
    res = handles.info.resolution;
    if handles.shifted
        if handles.butt_left_right.Value && ~isempty(handles.kymo_lines)
            for i =1:numel(handles.kymo_lines)
                    obj = handles.kymo_lines{i};
                    y = obj.y*dt;
                    x_shift_left = obj.x_shift_left*res;
                    x_shift_right = obj.x_shift_right*res;
                    varar = {'LineWidth',2};
                    if handles.currentline==i
                        varar = {'LineWidth',5};
                    end
                    if obj.isleft
                        plot(y-aligned*y(1),-(x_shift_left-x_shift_left(1)),'green',varar{:});
                    else
                        plot(y-aligned*y(1),x_shift_right-x_shift_right(1),'magenta',varar{:});
                    end
                    p.Color(4) = 0.8;
            end


        end
    end
        
end

