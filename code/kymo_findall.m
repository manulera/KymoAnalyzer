function [handles] = kymo_findall(handles)

[~,out] = system(['find ' uigetdir() ' -type d -name "kymo_matlab??"']);

all_files = strsplit(out);
empty_ones = cellfun('isempty',all_files);
all_files = all_files(~empty_ones);
% Filter for LP and timestep
all_files2 = {};
for i = 1:numel(all_files)
    f = all_files{i};
    meta_file = dir([f filesep '..' filesep '..' filesep '*.csv']);
    if isempty(strfind(meta_file.name,'TP4907'))
        continue
    end

    metadata_file = [f filesep '..' filesep '..' filesep meta_file.name];
    if isfile(metadata_file)
        LP = read_metadata_csv(metadata_file);
    else
        error(['Metadata file ' metadata_file ' not found'])
    end
    
    
    info = kymo_read_info(f);
    if round(info.timestep)~=4 || LP~=22.5
        continue
    else
        all_files2 = [all_files2 f]; 
    end
    
    
end

handles.all_kymos = all_files2;
handles.current_kymo = 1;
end