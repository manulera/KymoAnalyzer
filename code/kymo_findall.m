function [handles] = kymo_findall(handles)

[~,out] = system(['echo ' uigetdir() '/*/*/*/*/kymos/kymo??.tif']);
all_files = strsplit(out);
empty_ones = cellfun('isempty',all_files);
handles.all_kymos = all_files(~empty_ones);
handles.current_kymo = 1;
end

