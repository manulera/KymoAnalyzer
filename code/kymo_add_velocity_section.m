function [handles] = kymo_add_velocity_section(handles)
    % Select a subset of the kymograph that will be used to calculate the
    % elongation velocity of the spindle (mainly to exclude when mitosis
    % has ended, and the metaphase part of the kymograph).
    axes(handles.ax_main)
    
    [x,y] = getpts();
    % It can only contain two values (the start and the end of the section)
    if numel(y)~=2
        return
    end
    
    % In case you click outside
    if y(1)<1
        y(1)=1;
    end
    
    if y(2)>size(handles.kymo,1)
        y(2)=size(handles.kymo,1);
    end
    handles.velocity_section = round(y);
    
end

