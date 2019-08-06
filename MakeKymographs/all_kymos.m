dirs = dir;
for i = 1:numel(dirs)
    if contains(dirs(i).name,'kymo_matlab')
        makeKymographs(dirs(i).name);
    end
end