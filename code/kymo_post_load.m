function [handles] = kymo_post_load(handles)
    tlen = size(handles.kymo,1);    
    set(handles.slider1,'Max',tlen);
    set(handles.slider1,'Min',1);
    set(handles.slider1,'Value',1);
    set(handles.slider1,'SliderStep',[1, 1]/tlen);
    handles.text_path.String = handles.pathfile;
end

