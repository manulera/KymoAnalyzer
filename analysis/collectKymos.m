function [kl_data,spindle_data] = collectKymos(sets,conditions,strain_numbers,warning_if)

% We extract the spindle data and the kymolines data in different arrays

spindle_data = {};
kl_data = {};

for set_i = 1:numel(sets)
    set_i
    this_set = sets{set_i};
    culture_folders= {};
    
    dirs = dir([this_set filesep '*' filesep]);
    for j = 1:numel(dirs)
        if dirs(j).name(1)~='.'
            culture_folders = [culture_folders [dirs(j).folder filesep dirs(j).name]];
        end
    end
    
    
    for exp_i = 1:numel(culture_folders)
        [~,out] = system(['find ' culture_folders{exp_i} ' -type f -name "kymo_save.mat"']);
        mat_files = strsplit(out);
        if strcmp(mat_files{1},'find:')
            % If none has been found
            continue
        end

        empty_ones = cellfun('isempty',mat_files);
        mat_files = mat_files(~empty_ones);

        % Folder name corresponds to the name of the directory where the .nd
        % file and the tifs are, which always has the name of the train in it.
        for mat_i = 1:numel(mat_files)
            folder_name = split(mat_files{mat_i},filesep);
            
            folder_name = folder_name{end-3};
            matfile_folder_path = fileparts(mat_files{mat_i});
            found = false;
            for z = 1:numel(conditions)
                % Names should be exclusive (For instance, one should check for
                % TP1057_37 before TP1057), hence the break
                if ~isempty(strfind(folder_name,strain_numbers{z}))
                    condition_i = z;
                    found=true;
                    break
                end
            end
            if ~found
                error(['Folder missnamed: ' mat_files{mat_i}])
            end

            % .mat files contain struct named 'out', that's why we here create an
            % empty one before, mostly for typehinting in the script
            out = struct();
%             fprintf('-> loading:%s %s\n',conditions{condition_i},mat_files{mat_i});
            load(mat_files{mat_i})        
            
            % The directory where the mat file is
            mat_file_folder = fileparts(mat_files{mat_i});
            meta_file = dir([mat_file_folder filesep '..' filesep '..' filesep '*.csv']);
            
            % Extract laser power to verify that the settings are always the same
            % for laser power and timestep
            LP = read_metadata_csv([meta_file.folder filesep meta_file.name]);   
            if round(out.info.timestep)~=warning_if.time_step || LP~=warning_if.LP
                warning('different settings: %s\n',meta_file.folder);
                continue
            end
            
            % We measure the speed of elongation of the spindle on the region where
            % we have detected kymo_lines only.
            spindle_speed = spindle_speed_where_comets(out.spindle_length,out.kymo_lines);
            left_membrane = [];
            right_membrane = [];
            if isfield(out,'left_membrane') && isfield(out,'right_membrane')
                left_membrane = out.left_membrane;
                right_membrane = out.right_membrane;
            end
            % In case we have specified annotations for the whole kymograph
            annotations = struct();
            annotations_file = [matfile_folder_path filesep 'annotation.txt'];
            
            if isfile(annotations_file)
                annotations = readConfigFile(annotations_file);
            end
            
            % Spindle data
            sp_data_this = {spindle_speed, out.spindle_length, out.left_edge,out.right_edge,set_i,exp_i,condition_i,mat_i,mat_files{mat_i},left_membrane,right_membrane,annotations};
            spindle_data = [spindle_data;sp_data_this];
        
            % Kl data
            for k = 1:numel(out.kymo_lines)
                kl = out.kymo_lines{k};
                if kl.speed<0 && ~kl.is_special
                    warning([mat_files{mat_i} ' has negative speeds']);
                end
                mt_length=kl.mt_length(out);
                length_start = mt_length(1);
                length_end = mt_length(end);
                
                mt_lengthVscenter=kl.mt_length_from_center(out);
                length_startVscenter = mt_lengthVscenter(1);
                length_endVscenter = mt_lengthVscenter(end);
                
                net_growth = kl.net_growth();
                
                sp_length_start = out.spindle_length(kl.y(1));
                sp_length_end = out.spindle_length(kl.y(end));
                duration = numel(kl.x);
                kl_speed = kl.speed;
                if isempty(kl.is_special)
                    kl.is_special=0;
                end
                special_kymo = isfield(out,'kymo_is_special') && out.kymo_is_special;
                
                
                kl_data_this = {mt_length,length_start,length_end,mt_lengthVscenter,length_startVscenter,length_endVscenter,...
                    net_growth,sp_length_start,sp_length_end,...
                    duration,kl_speed,kl,set_i,exp_i,condition_i,mat_i,mat_files{mat_i},kl.is_special,special_kymo};
                kl_data = [kl_data;kl_data_this];
            end
        end

    end
    
end
%%
spindle_data = cell2table(spindle_data,'VariableNames',{'speed','length','left_edge','right_edge','set_id','exp_id','condition_id','kymo_id','mat_file','left_membrane','right_membrane','annotations'});
kl_data = cell2table(kl_data,'VariableNames',{'length','length_start','length_catast','length_respect2center','rescue_respect2center','catast_respect2center' ...
    'netgrowth','length_spindle_start','length_spindle_catast',...
    'duration', 'speed','kl','set_id','exp_id','condition_id','kymo_id','mat_file','is_special','special_kymo'});
%%

% Add the empty column with the name of the condition
kl_data.condition_name = cell(size(kl_data,1),1);
kl_data.condition_set = cell(size(kl_data,1),1);
spindle_data.condition_name = cell(size(spindle_data,1),1);
spindle_data.condition_set = cell(size(spindle_data,1),1);

for i = 1:numel(conditions)
    kl_data{kl_data.condition_id==i,'condition_name'} = conditions(i);
    spindle_data{spindle_data.condition_id==i,'condition_name'} = conditions(i);
end


kl_data.condition_name = categorical(kl_data.condition_name);
spindle_data.condition_name = categorical(spindle_data.condition_name);

% Column containing the set and condition

for i = 1:size(kl_data,1)
    
    set_i = num2str(kl_data.set_id(i));
    
    kl_data.condition_set{i}=[char(kl_data.condition_name(i)) '_' set_i];
end
for i = 1:size(spindle_data,1)
    
    set_i = num2str(spindle_data.set_id(i));
    
    spindle_data.condition_set{i}=[char(spindle_data.condition_name(i)) '_' set_i];
end


kl_data.elongation = kl_data.length_catast-kl_data.length_start;
kl_data.ave_spindle_length = mean([kl_data.length_spindle_catast,kl_data.length_spindle_start],2);
kl_data.ave_mt_length = mean([kl_data.length_start,kl_data.length_catast],2);