function [  ] = countEvents( this_data )
fprintf('\n>>>\n')    
for cate = unique(this_data.condition_name)'
        logi = this_data.condition_name==cate;
        this = this_data(logi,:);
        nb_kymos = numel(unique(this.mat_file));
        clear_duration = sum(this.is_special ==0);
        growing_events = sum(this.is_special ~=2);
        shrinking_events = sum(this.is_special ==2);
        nb_shrinking_kymos = numel(unique(this.mat_file(this.is_special ==2)));
        fprintf('%s\n   nb kymographs:%d\n   growing events: %d\n     > of which clear: %d\n   shrinking events:%d\n      > shrinking kymographs:%d\n',cate,nb_kymos,growing_events,clear_duration,shrinking_events,nb_shrinking_kymos)
    end 
end

