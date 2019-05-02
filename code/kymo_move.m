function [handles] = kymo_move(handles, move)
wrapN = @(x) (1 + mod(x-1, numel(handles.kymo_lines)));

handles.currentline = wrapN(handles.currentline+move);
end

