function [handles] = kymo_select_close(handles)
    
[x,y] = getpts;
x = mean(x);
y = mean(y);
dists = zeros(1,numel(handles.kymo_lines));
for i =1:numel(handles.kymo_lines)
    dists(i) = (mean(handles.kymo_lines{i}.x) - x)^2 + (mean(handles.kymo_lines{i}.y) - y)^2;
end

[~,handles.currentline] = min(dists);
end

