function [handles] = kymo_select(handles, move)
    
    wrapN = @(x) (1 + mod(x-1, numel(handles.all_kymos)));
    
    handles.current_kymo = wrapN(handles.current_kymo+move);
    handles = kymo_load(handles, handles.all_kymos{handles.current_kymo});
    handles = kymo_post_load(handles);
    handles.shifted=0;
    handles.menu_plot.Value=1;
    
    % Apply the membrane settings in case
    handles = kymo_membrane_settings(handles);
%     kymo_print_info(handles);
%     handles.info.timestep=1;
%     handles.info.resolution=1;
end

