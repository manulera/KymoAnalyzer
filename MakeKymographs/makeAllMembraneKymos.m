found = dir(fullfile('.', ['**' filesep 'movie_membrane.tif']));
found_folders = {found.folder};
for i = 1:numel(found_folders)
    last_kymo = [found_folders{i} filesep 'probs_membrane_kymo.tif'];
    if exist(last_kymo,'file')==2
        fprintf('* Skipped: %s\n',found_folders{i})
        continue
    end
    fprintf('> Doing kymograph %u of %u: %s\n',i,numel(found_folders),found_folders{i})
    repeatKymographs(found_folders{i},1);
    fprintf('done \n')
end