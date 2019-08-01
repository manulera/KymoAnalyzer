function [ handles ] = kymo_measure_speed( handles )

    if ~isempty(handles.kymo_lines)
        for i =1:numel(handles.kymo_lines)
            
            handles.kymo_lines{i}.calc_speed(handles);
        end
    end
    handles.spindle_length = handles.right_edge.x - handles.left_edge.x;
end

