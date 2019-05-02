function [  ] = kymo_save( handles )

%% Create a structure containing relevant variables
f = fields(handles);
% All the variable types we dont want to store
exclude = {'matlab.ui.Figure','matlab.ui.control.UIControl','matlab.graphics.axis.Axes','matlab.ui.Figure'};
out = struct();
for i = 1:numel(f)
    name = f{i};    
    if ~any(strcmp(class(handles.(name)),exclude))
        out.(name) = handles.(name);
    end
end

%% Make the directory to store the analysis

% Check if directory exists
dirname = [out.pathfile filesep out.tif_file(1:end-4)];
if ~isdir(dirname)
    mkdir(dirname)
end



% Save handles
save([dirname filesep 'kymo_save.mat'],'out')
warndlg('Data saved')

