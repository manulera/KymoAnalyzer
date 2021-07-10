found = dir(fullfile('.', ['**' filesep 'movie.tif']));
found_folders = {found.folder};

folders2do = {};
for i = 1:numel(found_folders)
    last_kymo = [found_folders{i} filesep 'movie_bleach_corrected_gauss2_max_kymo.tif'];
    if exist(last_kymo,'file')==2
        fprintf('* Skipped: %s\n',found_folders{i})
        continue
    end
    folders2do = [folders2do found_folders(i)];
    % If you want to only do the ones without parabolla (when wekaing the others)
%     parabolla_frame=csvread([found_folders{i} filesep 'settings.txt']);
%     if parabolla_frame~=0
%         continue
%     end
    
end

for i = 1:numel(folders2do)
    fprintf('> Doing kymograph %u of %u: %s\n',i,numel(folders2do),folders2do{i})
    makeKymographs(folders2do{i});
    fprintf('done \n')
end