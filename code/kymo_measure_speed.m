function [ handles ] = kymo_measure_speed( handles )

    if ~isempty(handles.kymo_lines)
        for i =1:numel(handles.kymo_lines)
            
            handles.kymo_lines{i}.calc_speed(handles);
        end
    end
    if ~isempty(handles.right_edge)&&~isempty(handles.left_edge)
        handles.spindle_length = handles.right_edge.x - handles.left_edge.x;
    end
end

