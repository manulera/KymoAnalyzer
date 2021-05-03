function [handles] = kymo_reassing_line(handles,isleft)
    
    handles.kymo_lines{handles.currentline}.isleft = isleft;
    handles.kymo_lines{handles.currentline}.calc_speed(handles);
end

