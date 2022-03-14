for membrane = {'before','outside','inside'}
    membrane = membrane{1};
    for condition = categories(this_data.condition_name)
        condition = condition{1};
        for exper = unique(this_data.experiment_names)'
            exper = exper{1};
            ind = this_data.condition==condition & this_data.position == membrane & strcmp(this_data.experiment,exper);
            fprintf('%s %s %s, %u\n',exper, membrane, condition,sum(ind));
        end
    end
end