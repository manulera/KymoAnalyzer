function [ handles ] = kymo_measure_speed( handles )

    if ~isempty(handles.kymo_lines)
        for i =1:numel(handles.kymo_lines)
            handles.kymo_lines{i}.calc_speed();
        end
    end
    siz = size(handles.kymo,1);
    handles.spindle_length = handles.right_edge.interpolate(siz) - handles.left_edge.interpolate(siz);
    
end

