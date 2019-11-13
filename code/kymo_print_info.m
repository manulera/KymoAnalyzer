function [] = kymo_print_info(h)
    
    meta_file = dir([h.pathfile filesep '..' filesep '..' filesep '*.csv']);
    read_metadata_csv([h.pathfile filesep '..' filesep '..' filesep meta_file.name]);
    disp(['Timestep: ' num2str(h.info.timestep)])
end

