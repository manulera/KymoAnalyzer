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
    if isempty(strfind(meta_file.name,'TP1057'))
        continue
    end
    
    LP = read_metadata_csv([f filesep '..' filesep '..' filesep meta_file.name]);
    
    
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