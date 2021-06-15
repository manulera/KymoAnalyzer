function [] = drawKymoLinesOnFrame(handles,t)
    
    pars = handles.fits(t,:);
    x = linspace(-150,150);
    y = x.^2*pars(4);
    
    theta = -(pars(1));
    R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    coords = [x; y]' * R;
    x = coords(:,1);
    y = coords(:,2);
    x = x+pars(2);
    y = y+pars(3);
    
    movie_size=size(handles.movie);
    rem = (x>movie_size(2)|x<1)|(y>movie_size(1)|y<1);
    x(rem)=[];
    y(rem)=[];
    
    plot(handles.ax_extra,x,y)
%     scatter(pars(2),pars(3),'yellow')

    text(20,20,num2str(t),'Fontsize',20,'Color','yellow')
    
    if ~isempty(handles.left_edge)
        % Reference point of the kymograph
        scatter(handles.ax_extra,handles.xc,handles.yc,'red')
        
        [xx,yy]=kymo2coord(t,{handles.left_edge},handles.smart_kymo);
        scatter(handles.ax_extra,xx,yy,'green');
        [xx,yy]=kymo2coord(t,{handles.right_edge},handles.smart_kymo);
        scatter(handles.ax_extra,xx,yy,'magenta');
        
        [xx,yy]=kymo2coord(t,handles.kymo_lines,handles.smart_kymo);

        scatter(handles.ax_extra,xx,yy,100,'yellow');
    end
    
    if isfield(handles,'left_membrane') && isfield(handles,'right_membrane') && ~isempty(handles.left_membrane)
        [xx,yy]=kymo2coord(t,{handles.left_membrane},handles.smart_kymo);
        scatter(handles.ax_extra,xx,yy,'green');
        [xx,yy]=kymo2coord(t,{handles.right_membrane},handles.smart_kymo);
        scatter(handles.ax_extra,xx,yy,'magenta');
    end
    
end

