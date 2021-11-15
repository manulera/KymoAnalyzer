function [ handles ] = kymo_load(handles,path)
    
% Locate save file
if nargin<2
    [file, path] = uigetfile('*.mat','Locate the .mat file of saved data');
else
    handles.pathfile = path;
    handles.tif_file = 'movie_bleach_corrected_gauss1_max_kymo.tif';
    
    file = 'kymo_save.mat';    
    handles = kym_import(handles, path);
    if ~isfile([path filesep file])
%         handles = kym_import(handles, path);
        return
    end
end


if file==0
    return
end

path
load([path filesep file])

% Copy all the fields from fout except for these
rem_fields = {'all_kymos','pathfile','current_kymo','mini_video','tif_file'};
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
handles = kymo_membrane_settings(handles);
handles.kymo = imread([handles.pathfile filesep handles.tif_file]);
handles.int_high_lim = str2double(handles.edit_high_lim.String);
handles.int_low_lim = str2double(handles.edit_low_lim.String);
handles.info = kymo_read_info(handles.pathfile);

% handles = kymo_update(handles);
