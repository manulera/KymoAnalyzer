function [] = kymo_export_speeds( handles )


x_ind = [];
y_ind = [];
dt = handles.info.timestep/60;
res = handles.info.resolution;

for i = 1:numel(handles.kymo_lines)
    kl = handles.kymo_lines{i};
    x_ind(end+1) = handles.spindle_length(round(kl.y(1)))*res;
    y_ind(end+1) = kl.speed*res/dt;    
end
speed = movmean(diff(handles.spindle_length),60)*res/dt;
len = handles.spindle_length*res;
folder = handles.all_kymos{handles.current_kymo}(1:end-4);
filename1 = [folder filesep 'speed_spindle.csv'];
filename2 = [folder filesep 'speed_microtubules.csv'];
csvwrite(filename1,[len(1:end-1)' speed']);
csvwrite(filename2,[x_ind' y_ind']);
handles.pathfile
