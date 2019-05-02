function [info] = kymo_read_info(filename)
    info = struct('resolution',[],'timestep',[],'condition',[]);
    
    fid = fopen(filename);
    
    tline = fgetl(fid);
    while ischar(tline)
        out = split(tline," ");
        info = setfield(info,out{1},out{2});
        tline = fgetl(fid);
    end
    
    info.resolution = str2double(info.resolution);
    info.timestep = str2double(info.timestep);
    
end

