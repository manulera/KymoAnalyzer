function [value_laser] = read_metadata_csv(file)
    value_laser = 0;
    fid = fopen(file);
    tline = fgetl(fid);
    while ischar(tline)
        find_them = {'Exposure Time','Laser_Intensity_491','NZSteps','Gain'};
        for f =find_them
            if contains(tline,f{1}) && ~contains(tline,'Trans BF')
                if strcmp(f{1},'Laser_Intensity_491')
                    dummy = split(tline,',');
                    value_laser = str2double(dummy{2});
                end
                disp(tline)
                break
            end
        end
        tline = fgetl(fid);
    end
    fclose(fid);
    
end

