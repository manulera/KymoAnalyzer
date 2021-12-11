function [data2predict] = membraneUnivarScatter2_errors(this_data,default_order,lm)
    xticks_values = xticks();
    % Calculate the mean and CI interval of the mean
    data2predict = unique(this_data(:,{'condition','position','experiment','cell','composed_condition'}));
    [data2predict.prediction,data2predict.predictionCI,data2predict.DF] = predict(lm,data2predict,'DFMethod','satterthwaite','Conditional',false);
    data2predict(:,{'experiment','cell'})=[];
    data2predict = unique(data2predict);
    data2predict.predictionBar = data2predict.prediction-data2predict.predictionCI(:,1);
    for i = 1:numel(default_order)
        which_row = default_order{i}==data2predict.composed_condition;
        y = data2predict.prediction(which_row);
        y_err = data2predict.predictionBar(which_row);
        errorbar(xticks_values(i),y,y_err,'.','MarkerSize',20,'Color','black','HandleVisibility','off','LineWidth',3)
    %     plot(xticks_values(i)+[-0.1,0.1],[y y],'LineWidth',3,'Color','Black')
    end
end

