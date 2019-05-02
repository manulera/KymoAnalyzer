function [ handles ] = kymo_load(handles,path)
    
% Locate save file
if nargin<2
    [file, path] = uigetfile('*.mat','Locate the .mat file of saved data');
else
    target_dir = path(1:end-4);
    [handles.pathfile,name,ext] = fileparts(path);
    handles.tif_file = [name,ext];
    if isdir(target_dir)
        path = target_dir;
        file = 'kymo_save.mat';    
    else
        handles = kym_import(handles, path);
        return
    end
end


if file==0
    return
end
path
load([path filesep file])
info_file = [handles.pathfile filesep 'info.txt'];

% Copy all the fields from out except for these
rem_fields = {'all_kymos','pathfile','current_kymo','mini_video'};
for r = rem_fields
    if isfield(out,r{1})
        out = rmfield(out,r{1});
    end
end
f = fields(out);
for i = 1:numel(f)
    handles.(f{i}) = out.(f{i});
end
if ~isfield(handles,'shifted')
    handles.shifted = false;
end
if isfile(info_file)
    handles.info = kymo_read_info(info_file);
else
    handles.info = [];
end