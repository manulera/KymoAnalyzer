[~,out] = system(['echo ./*/*/kymos/kymo??/*mat']);
all_files = strsplit(out);
empty_ones = cellfun('isempty',all_files);
all_files = all_files(~empty_ones);

for j = 1:numel(all_files)
    f = all_files{j};
    load(f);
    for i = 1:numel(out.kymo_lines)
        if isempty(out.kymo_lines{i}.isleft)
            out.kymo_lines{i}.isleft = 1;
            out.kymo_lines{i} = out.kymo_lines{i}.hard_copy(out.kymo_lines{i});
        end
    end

    save(f,'out');
end