function [handles] = kym_import(handles,target)
    if nargin<2    
        [handles.tif_file,handles.pathfile] = uigetfile('*.tif','Open kymograph');
    end
    handles.shifted = false;
    handles.kymo = imread([handles.pathfile filesep handles.tif_file]);
    st = {};
    d = dir(handles.pathfile);
    for i =1:numel(d)
        if contains(d(i).name,'kymo.tif')
            st = [st d(i).name];
        end
    end
    
    handles.menu_kymo.String=st;
    handles.info = kymo_read_info(handles.pathfile);
%     handles.info.resolution=0.06;
%     handles.info.timestep=4;
    handles.kymo_lines = {};
    handles.special_lines = {};
    handles.currentline = 1;
    handles.left_edge = [];
    handles.right_edge = [];
    handles.spindle_length = [];
    handles.kymo_is_special = false;
    
    if isfield(handles,'left_membrane')
        handles = rmfield(handles,'left_membrane');
    end
    if isfield(handles,'right_membrane')
        handles = rmfield(handles,'right_membrane');
    end
    if isfield(handles,'velocity_section')
        handles = rmfield(handles,'velocity_section');
    end
        
end

