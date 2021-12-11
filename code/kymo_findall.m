function [handles] = kymo_findall(handles)

%% Matlab version


found = dir(fullfile(uigetdir(), ['**' filesep 'movie_max_kymo.tif']));
all_folders = {found.folder};
handles.current_kymo = 1;
filtered_folders = {};

for i = 1:numel(all_folders)
    
    f = all_folders{i};
    
    meta_file = dir([f filesep '..' filesep '..' filesep '*.csv']);
    % Filtering step
    if isfield(handles,'edit_filter_files')
        filter_str=handles.edit_filter_files.String;
        if ~isempty(filter_str) && isempty(strfind(meta_file.name,{filter_str}))
            continue
        end
    end
    

    metadata_file = [f filesep '..' filesep '..' filesep meta_file.name];
    if isfile(metadata_file)
        LP = read_metadata_csv(metadata_file);
    else
        error(['Metadata file ' metadata_file ' not found'])
    end
    filtered_folders = [filtered_folders f];
end

handles.all_kymos = filtered_folders;
numel(handles.all_kymos)
handles.current_kymo = 1;
end