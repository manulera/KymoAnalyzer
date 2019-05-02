function [ handles ] = kymo_align_pole( handles,left_pole )
    

if left_pole
    kl = handles.left_edge;
else
    kl = handles.right_edge;
end

interp_shift = kl.interpolate(size(handles.kymo,1));
%%

siz = size(handles.kymo);
new_kymo = zeros(size(handles.kymo));

if left_pole
    for i =1:size(new_kymo,1)
        new_line = handles.kymo(i,interp_shift(i):end);
        new_kymo(i,1:numel(new_line))=new_line;
    end
else
    for i =1:size(new_kymo,1)
        new_line = handles.kymo(i,1:interp_shift(i));
        new_kymo(i,end-numel(new_line)+1:end)=new_line;
    end
end

figure
imshow(new_kymo,[handles.int_low_lim,handles.int_high_lim])
hold on
for i = 1:numel(handles.kymo_lines)
    shift = interp1(kl.y,kl.x,handles.kymo_lines{i}.y,'pchip');
    
        
    if left_pole
        handles.kymo_lines{i}= handles.kymo_lines{i}.shift(-shift);
    else
        handles.kymo_lines{i}= handles.kymo_lines{i}.shift(siz(2)-shift);
    end
    
    if handles.kymo_lines{i}.isleft && ~left_pole
        handles.kymo_lines{i}.x_shift_left = handles.kymo_lines{i}.x_shift;
    elseif ~handles.kymo_lines{i}.isleft && left_pole 
        handles.kymo_lines{i}.x_shift_right = handles.kymo_lines{i}.x_shift;
    end
    
    this = handles.kymo_lines{i};

    if handles.butt_left_right.Value
        if this.isleft
            p = this.plot_shift('green','LineWidth',3);
        else
            p = this.plot_shift('magenta','LineWidth',3);
        end
    else
        p = this.plot_shift();
    end
    p.Color(4) = 0.8;
    
end
handles.shifted = 1;



    
    


end

