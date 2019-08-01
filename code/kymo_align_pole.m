function [ handles ] = kymo_align_pole( handles,left_pole )
    

if left_pole
    kl = handles.left_edge;
    handles.shifted = 1;
else
    kl = handles.right_edge;
    handles.shifted = -1;
end

new_kymo=shiftKymo(handles.kymo,round(kl.x),left_pole);


handles.kymo_shifted = new_kymo;

end

