function [  ] = kymo_save( handles )

%% Create a structure containing relevant variables
f = fields(handles);
% All the variable types we dont want to store
exclude_class = {'matlab.ui.Figure','matlab.ui.control.UIControl','matlab.graphics.axis.Axes','matlab.ui.Figure'};
exclude_field = {'movie','mask','smart_kymo','all_kymos','pathfile'};
out = struct();
for i = 1:numel(f)
    name = f{i};    
    if ~any(strcmp(class(handles.(name)),exclude_class))&&~any(strcmp(name,exclude_field))
        out.(name) = handles.(name);
    end
end

%% Make the directory to store the analysis

% Check if directory exists

% Save handles
save([handles.pathfile filesep 'kymo_save.mat'],'out')


