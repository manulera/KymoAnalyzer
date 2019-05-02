function [handles] = kymo_select(handles, move)
    
    wrapN = @(x) (1 + mod(x-1, numel(handles.all_kymos)));
    handles.current_kymo = wrapN(handles.current_kymo+move);
    handles = kymo_load(handles, handles.all_kymos{handles.current_kymo});
    handles = kymo_post_load(handles);
    kymo_print_info(handles);
end

