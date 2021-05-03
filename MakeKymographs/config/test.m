
fid=fopen('config_mal3D.json');
line= fgetl(fid);

config = struct();
while ischar(line)
    
    line = line(~isspace(line));
    pair=strsplit(line,':');
    keyword = pair{1};
    value = pair{2};
    config.(keyword) = value;
    line= fgetl(fid);
    
end

