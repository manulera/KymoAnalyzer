function [kl_data,spindle_data] = loadKymosFromMatFile(matfile, t_res, x_res)
    
    % Load the kymographs saved as output of collectKymos()
    load(matfile)
    length_variables={'length_start','length_catast','rescue_respect2center',...
    'catast_respect2center','netgrowth','length_spindle_start','length_spindle_catast',...
    'elongation','ave_spindle_length','ave_mt_length'};
    time_variables={'duration'};
    speed_variables={'speed'};
    length_cells = {'length','length_respect2center'};
    kl_data{:,length_variables}=kl_data{:,length_variables}*x_res;
    kl_data{:,time_variables}=kl_data{:,time_variables}*t_res;
    kl_data{:,speed_variables}=kl_data{:,speed_variables}*x_res/t_res;
    kl_data{:,length_cells}=cellfun(@(x) x_res*x,kl_data{:,length_cells},'un',0);

    % Eliminate those from the categories
    kl_data.condition_set = removeCategories(categorical(kl_data.condition_set));
    kl_data.condition_name = removeCategories(categorical(kl_data.condition_name));

    % kl_data.condition_name = reordercats(kl_data.condition_name,{'ctrl','klp9D','cdc25-22','ase1D','ctrl37C'});
    % kl_data.condition_set = reordercats(kl_data.condition_set,{'ctrl_1','klp9D_1','ctrl_2','cdc25-22_2','ctrl_3','ase1D_3','ctrl37C_1'});
    

    %% Create extra columns
    nb_obs = size(kl_data,1);
    kl_data.elongation_in_time=cell(nb_obs,1);
    kl_data.time=cell(nb_obs,1);
    kl_data.net_growth_intime = cell(nb_obs,1);
    kl_data.ave_len_respect2center = zeros(nb_obs,1);
    kl_data.rescue_respect2pole = zeros(nb_obs,1);
    kl_data.rescue_respect2membrane = zeros(nb_obs,1);
    kl_data.rescue_inside_membrane = cell(nb_obs,1);
    kl_data.unique_id = cell(nb_obs,1);
    kl_data.custom_category = cell(nb_obs,1);
    kl_data.speed_norm=zeros(nb_obs,1);
    for i =1:nb_obs
        kl_data.unique_id{i} = num2str(i);
        kl = kl_data.kl(i);
        kl_data.elongation_in_time{i} = (kl_data.length{i} - kl_data.length{i}(1));
        kl_data.time{i} = (0:(numel(kl_data.length{i})-1))*t_res;
        kl_data.net_growth_intime{i} = abs(kl.x-kl.x(1))*x_res;
        kl_data.ave_len_respect2center(i) = mean(kl_data.length_respect2center{i});
        kl_data.rescue_respect2pole(i) = kl_data.length_spindle_start(i)-kl_data.length{i}(1);
        % Distance to the closest pole (not just the opposite)
        kl_data.rescue_respect2pole(i) = min([kl_data.length{i}(1),kl_data.length_spindle_start(i)-kl_data.length{i}(1)]);
        
        % There should never be more than one
        corresponding_spindle = strcmp(spindle_data.mat_file,kl_data.mat_file{i});

        if sum(corresponding_spindle)~=1
            error('multiple spindles with the same matfile or matfile not found on spindles')
        end

        sp = spindle_data(corresponding_spindle,:);
        
        %% Membrane
        
        kl_data.rescue_inside_membrane{i} = '';
        kl_data.rescue_respect2membrane(i) = nan;

        % If the rescue occurs before the splitting of the membrane
        if any(strcmp('left_membrane',sp.Properties.VariableNames)) && ~isempty(sp.left_membrane{1})

            if sp.left_membrane{1}.y(1)>kl.y(1)
                kl_data.rescue_inside_membrane{i} = 'before';
                kl_data.rescue_respect2membrane(i) = nan;
            else
                % The index of the membrane line that corresponds to the time
                % of rescue
    %             figure()
    %             hold on
    %             plot(sp.right_membrane{1}.x,sp.right_membrane{1}.y)
    %             plot(sp.left_membrane{1}.x,sp.left_membrane{1}.y)
    %             plot(sp.right_edge{1}.x,sp.right_edge{1}.y)
    %             plot(sp.left_edge{1}.x,sp.left_edge{1}.y)
    %             plot(kl.x,kl.y)
                index_membrane = find(sp.left_membrane{1}.y==kl.y(1));
                
                % Old way (without wrapping)
%                 if kl.isleft
%                     membrane_edge = sp.left_membrane{1}.x(index_membrane);
%                     kl_data.rescue_respect2membrane(i) = membrane_edge - kl.x(1);
%                 else
%                     membrane_edge = sp.right_membrane{1}.x(index_membrane);
%                     kl_data.rescue_respect2membrane(i) = kl.x(1) - membrane_edge;
%                 end
%                 if kl_data.rescue_respect2membrane(i)<=0
%                     kl_data.rescue_inside_membrane{i} = 'inside';
%                 else
%                     kl_data.rescue_inside_membrane{i} = 'outside';
%                 end
                left_edge = sp.left_membrane{1}.x(index_membrane);
                right_edge = sp.right_membrane{1}.x(index_membrane);
                starting_point = kl.x(1);
                
                if starting_point>left_edge && starting_point<right_edge
                    kl_data.rescue_inside_membrane{i} = 'inside';
                    kl_data.rescue_respect2membrane(i) = -min([starting_point - left_edge, right_edge - starting_point]);
                else
                    kl_data.rescue_inside_membrane{i} = 'outside';
                    if starting_point<=left_edge
                        kl_data.rescue_respect2membrane(i) = left_edge-starting_point;
                    else
                        kl_data.rescue_respect2membrane(i) = starting_point-right_edge;
                    end
                     
                end
                
                
                
                
            end
        else
            disp(sp.mat_file{1})
        end
        
        %% Annotations
        % I don't really understand why this inconsistent behaviour happens
        if isfield(sp,'annotations') && iscell(sp.annotations) && ~isempty(sp.annotations)
            sp.annotations = sp.annotations{1};
        end
        
        if any(strcmp('annotations',sp.Properties.VariableNames)) && isfield(sp.annotations,'category')
            kl_data.custom_category{i} = sp.annotations.category;
        end
    end
    %% Condition normalization
        
    for cond = unique(kl_data.condition_set)'
        logi = kl_data.condition_set==cond & kl_data.speed>0;
        kl_data.speed_norm(logi) = kl_data.speed(logi)./mean(kl_data.speed(logi));
    end
    %%
    kl_data.rescue_respect2membrane = kl_data.rescue_respect2membrane*x_res;
    kl_data.speed_min = kl_data.speed*60;
    kl_data.rescue_inside_membrane = categorical(kl_data.rescue_inside_membrane);
end

