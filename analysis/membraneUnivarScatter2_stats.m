function [  ] = membraneUnivarScatter2_stats(lm , category_order, l1, l_step)
    if isempty(l1)
        l1 = 2.9;
    end
    if isempty(l_step)
        l_step = 0.24;
    end
    
    
    
    l2 = l1+l_step;
    l3 = l2+l_step;

    plot([1,2],[l1,l1],'k')
    plot([3.5,4.5],[l1,l1],'k')
    plot([6,7],[l1,l1],'k')
    plot([1.5,4],[l2,l2],'k')
    plot([1.5,6.5],[l3,l3],'k')
    
    categ_row = categorical(lm.Coefficients.Row);
    
    condition_before = sprintf('condition_%s',category_order{2});
    condition_outside = sprintf('condition_%s:position_outside',category_order{2});
    condition_inside = sprintf('condition_%s:position_inside',category_order{2});
    
    pval_outside = convertPval2Text(lm.Coefficients.pValue(categ_row=='position_outside'));
    pval_inside = convertPval2Text(lm.Coefficients.pValue(categ_row=='position_inside'));
    pval_condition_before = convertPval2Text(lm.Coefficients.pValue(categ_row==condition_before));
    pval_condition_outside = convertPval2Text(lm.Coefficients.pValue(categ_row==condition_outside));
    pval_condition_inside = convertPval2Text(lm.Coefficients.pValue(categ_row==condition_inside));
    
    fontsize_text= 16;
    text(mean([1,2]),l1,pval_condition_before,'VerticalAlignment','bottom','HorizontalAlignment','center','fontsize',fontsize_text)
    
    text(mean([1.5,4]),l2,pval_outside,'VerticalAlignment','bottom','HorizontalAlignment','center','fontsize',fontsize_text)
    text(mean([1.5,6.5]),l3,pval_inside,'VerticalAlignment','bottom','HorizontalAlignment','center','fontsize',fontsize_text)
    

    text(mean([3.5,4.5]),l1,pval_condition_outside,'VerticalAlignment','bottom','HorizontalAlignment','center','fontsize',fontsize_text)
    text(mean([6,7]),l1,pval_condition_inside,'VerticalAlignment','bottom','HorizontalAlignment','center','fontsize',fontsize_text)


end

