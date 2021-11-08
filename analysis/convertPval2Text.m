function [ text_value ] = convertPval2Text( pval )
    
    if pval>0.05
        text_value = 'n.s.';
    else
        text_value = sprintf('p=%.1E',pval);
    end

end

