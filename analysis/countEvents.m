function [  ] = countEvents( this_data )
fprintf('\n>>>\n')
has_membrane = any(~isnan(this_data.rescue_respect2membrane));
if has_membrane
    this_data.position = this_data.rescue_inside_membrane;
    this_data.position = reordercats(this_data.position,{'before','outside','inside'});
end
this_data.condition = this_data.condition_name;
this_data.cell = this_data.mat_file;
this_data.experiment = this_data.experiment_names;

for cate = unique(this_data.condition_name)'
        logi = this_data.condition_name==cate;
        this = this_data(logi,:);
        nb_kymos = numel(unique(this.mat_file));
        clear_duration = sum(this.is_special ==0);
        growing_events = sum(this.is_special ~=2);
        shrinking_events = sum(this.is_special ==2);
        nb_shrinking_kymos = numel(unique(this.mat_file(this.is_special ==2)));
        fprintf('%s\n   nb kymographs:%d\n   growing events: %d\n     > of which clear: %d\n   shrinking events:%d\n      > shrinking kymographs:%d\n',cate,nb_kymos,growing_events,clear_duration,shrinking_events,nb_shrinking_kymos)
        this = this(this.is_special ~=2,:);
        exper = grp2idx(this.experiment_names);
        fprintf('   Per experiment:\n')
        for i = unique(exper)'
            logi2 = exper==i;
            this2 = this(logi2,:);
            nb_kymos = numel(unique(this2.mat_file));
            nb_events = sum(logi2);
            fprintf('      > exp %u: %u kymos, %u events -> %s\n',i,nb_kymos,nb_events,num2str(countcats(categorical(this2.mat_file))'));
            if has_membrane
                for ii = categories(this2.position)'
                    logi3 = this2.position==ii;
                    fprintf('         >> ave_speed %s: %.2f; n=%u\n',ii{1},mean(this2.speed_min(logi3)),sum(logi3));
                end
            end
        end
        
    end 
end

