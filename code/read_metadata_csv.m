function [] = read_metadata_csv(file)

    fid = fopen(file);
    tline = fgetl(fid);
    while ischar(tline)
        find_them = {'Exposure Time','Laser_Intensity_491','NZSteps','Gain'};
        for f =find_them
            if contains(tline,f{1}) && ~contains(tline,'Trans BF')
                disp(tline)
                break
            end
        end
        tline = fgetl(fid);
    end
    fclose(fid);
    
end

