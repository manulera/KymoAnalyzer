function [handles] = kym_import(handles,target)
    if nargin<2    
        [handles.tif_file,handles.pathfile] = uigetfile('*.tif','Open kymograph');
    end
    handles.shifted = false;
    handles.kymo = imread([handles.pathfile filesep handles.tif_file]);
    
    handles.info = kymo_read_info(handles.pathfile);
    
    handles.kymo_lines = {};
    handles.currentline = 1;
    handles.left_edge = [];
    handles.right_edge = [];
    handles.spindle_length = [];
end

