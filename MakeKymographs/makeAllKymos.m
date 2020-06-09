found = dir(fullfile('.', ['**' filesep 'movie.tif']));
found_folders = {found.folder};
for i = 1:numel(found_folders)
    last_kymo = [found_folders{i} filesep 'movie_bleach_corrected_gauss2_max_kymo.tif'];
    if exist(last_kymo,'file')==2
        continue
    end
    fprintf('> Doing kymograph: %s\n',found_folders{i})
    makeKymographs(found_folders{i});
    fprintf('done \n')
end