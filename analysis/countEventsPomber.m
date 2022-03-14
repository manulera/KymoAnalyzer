function [  ] = countEventsPomber( this_data )
fprintf('\n>>>\n')    
for cate = unique(this_data.condition)'
        logi = this_data.condition==cate;
        fprintf('%s\n',cate);
        this = this_data(logi,:);
        this_cell_exps = unique(this.cell_experiment);
        for i = 1:numel(this_cell_exps)
            logi2 = strcmp(this_cell_exps{i},this.cell_experiment);
            fprintf('  >  %u %s\n',sum(logi2),this_cell_exps{i})
        end
        
    end 
end

