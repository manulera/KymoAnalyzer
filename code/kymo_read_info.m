function [info] = kymo_read_info(path)
    info = struct('resolution',[],'timestep',[]);
    
    aa =imfinfo([path filesep 'movie.tif']);
    info.resolution = 1./aa(1).XResolution;
    
    raw = aa(1).ImageDescription;
    raw = split(raw,newline);
    
    
    % Get the time interval between images
    for i = 1:numel(raw)
        if isempty(raw{i})
            continue
        end
        sp = split(raw{i},'=');
        if strcmp(sp{1},'finterval')
            info.timestep=str2double(sp{2});
            break
        end
    end
    
    
    
end

