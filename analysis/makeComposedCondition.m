function [ this_data, colors, category_order2, ticks ] = makeComposedCondition( this_data, color_dict, category_order )
    %% Make a new categorical variable combining rescue_inside and condition_name
    this_data.composed_condition = this_data.rescue_inside_membrane;
    
    for i =1:size(this_data,1)
        this_data.composed_condition(i) = sprintf('%s %s',this_data.rescue_inside_membrane(i), this_data.condition_name(i));
    end
    this_data.composed_condition = categorical(this_data.composed_condition);
    this_data.composed_condition = removeCategories(this_data.composed_condition);
    
    colors = [];
    category_order2 = {};
    ticks = {};
    for membrane = {'before','outside','inside'}
        membrane = membrane{1};
        for condition = category_order
            condition = condition{1};
            colors = [colors; color_dict(condition)];
            category_order2 = [category_order2 sprintf('%s %s',membrane, condition)];
            ticks = [ticks; condition];
        end
    end

    this_data.composed_condition = reordercats(this_data.composed_condition,category_order2);
    

end

