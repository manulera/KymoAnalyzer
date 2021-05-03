function [handles] = kymo_add_membrane_lines(handles,isleft)
    % [] = kymo_add_membrane_lines(handles,isleft)
    
    % Define the usual kymoline
    the_line = kymo_line(size(handles.kymo,1));

    if isleft
        handles.left_membrane = the_line;
    else
        handles.right_membrane = the_line;
    end
    
    % Combine left and right into a single region starting at the same
    % timepoint
    if isfield(handles,'left_membrane') && isfield(handles,'right_membrane')
        
        % We store the first timepoint where we detect the edge
        first_timepoint = min([handles.left_membrane.y(1),handles.right_membrane.y(1)]);
        
        % We extend both edges
        handles.left_membrane.extend_edge(size(handles.kymo,1))
        handles.right_membrane.extend_edge(size(handles.kymo,1))
        
        % We keep only from the first timepoint, but we extend until the
        % end
        keep = first_timepoint:size(handles.kymo,1);
        
        handles.left_membrane.x = handles.left_membrane.x(keep);
        handles.left_membrane.y = handles.left_membrane.y(keep);
        
        handles.right_membrane.x = handles.right_membrane.x(keep);
        handles.right_membrane.y = handles.right_membrane.y(keep);
    end
    
end

