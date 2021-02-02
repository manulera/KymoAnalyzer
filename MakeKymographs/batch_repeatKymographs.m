dirlist= dir();
for i = 1:numel(dirlist)
    if isfile([dirlist(i).name filesep 'settings.txt'])
        repeatKymographs(dirlist(i).name);
    end
end