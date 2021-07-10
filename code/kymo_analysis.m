function varargout = kymo_analysis(varargin)
% KYMO_ANALYSIS MATLAB code for kymo_analysis.fig
%      KYMO_ANALYSIS, by itself, creates a new KYMO_ANALYSIS or raises the existing
%      singleton*.
%
%      H = KYMO_ANALYSIS returns the handle to a new KYMO_ANALYSIS or the handle to
%      the existing singleton*.
%
%      KYMO_ANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KYMO_ANALYSIS.M with the given input arguments.
%
%      KYMO_ANALYSIS('Property','Value',...) creates a new KYMO_ANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before kymo_analysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to kymo_analysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help kymo_analysis

% Last Modified by GUIDE v2.5 26-Apr-2021 14:11:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @kymo_analysis_OpeningFcn, ...
                   'gui_OutputFcn',  @kymo_analysis_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before kymo_analysis is made visible.
function kymo_analysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to kymo_analysis (see VARARGIN)

% You can pass a list of paths
if numel(varargin)==1
    paths_in = varargin{1};
    real_paths = cell(1,numel(paths_in));
    for i = 1:numel(paths_in)
        real_paths{i} = fileparts(paths_in{i});
    end
    handles.all_kymos = real_paths;
    handles.current_kymo = 1;
end
handles.output = hObject;
handles.version = 1.0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes kymo_analysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = kymo_analysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in butt_left.
function butt_left_Callback(hObject, eventdata, handles)
handles.left_edge = kymo_line(size(handles.kymo,1));
handles.left_edge.extend_edge(size(handles.kymo,1));
handles = kymo_measure_speed(handles);
guidata(hObject, handles);    


% --- Executes on button press in butt_right.
function butt_right_Callback(hObject, eventdata, handles)
handles.right_edge = kymo_line(size(handles.kymo,1));
handles.right_edge.extend_edge(size(handles.kymo,1));
handles = kymo_measure_speed(handles);
guidata(hObject, handles);


% --- Executes on button press in butt_addline.
function butt_addline_Callback(hObject, eventdata, handles)
handles = kym_addline(handles);
kym_show(handles);
guidata(hObject, handles);



% --- Executes on button press in butt_prev.
function butt_prev_Callback(hObject, eventdata, handles)
handles = kymo_move(handles,-1);
kym_show(handles);
guidata(hObject, handles);


% --- Executes on button press in butt_next.
function butt_next_Callback(hObject, eventdata, handles)
handles = kymo_move(handles,1);
kym_show(handles);
guidata(hObject, handles);



% --- Executes on button press in butt_remove.
function butt_remove_Callback(hObject, eventdata, handles)
handles.kymo_lines(handles.currentline)=[];
handles = kymo_move(handles,0);
kym_show(handles);
guidata(hObject, handles);


% --- Executes on button press in butt_import.
function butt_import_Callback(hObject, eventdata, handles)
handles = kym_import(handles);
kym_show(handles);
guidata(hObject, handles);

% --- Executes on button press in butt_save.
function butt_save_Callback(hObject, eventdata, handles)
kymo_save(handles);



% --- Executes on button press in butt_load.
function butt_load_Callback(hObject, eventdata, handles)
handles = kymo_load(handles);
handles = kymo_post_load(handles);
handles.shifted=0;
kym_show(handles);
guidata(hObject, handles);



function edit_low_lim_Callback(hObject, eventdata, handles)
handles.int_low_lim = str2double(get(hObject,'String'));
kym_show(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit_low_lim_CreateFcn(hObject, eventdata, handles)
handles.int_low_lim = str2double(get(hObject,'String'));
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);



function edit_high_lim_Callback(hObject, eventdata, handles)
handles.int_high_lim = str2double(get(hObject,'String'));
kym_show(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit_high_lim_CreateFcn(hObject, eventdata, handles)
handles.int_high_lim = str2double(get(hObject,'String'));
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);


% --- Executes on button press in tog_current.
function tog_current_Callback(hObject, eventdata, handles)
kym_show(handles);


% --- Executes on button press in butt_findkymos.
function butt_findkymos_Callback(hObject, eventdata, handles)
handles = kymo_findall(handles);
guidata(hObject, handles);


% --- Executes on button press in butt_next_kymo.
function butt_next_kymo_Callback(hObject, eventdata, handles)
handles = kymo_select(handles,1);
kym_show(handles);
guidata(hObject, handles);


% --- Executes on button press in butt_prev_kymo.
function butt_prev_kymo_Callback(hObject, eventdata, handles)
handles = kymo_select(handles,-1);
kym_show(handles);
guidata(hObject, handles);


% --- Executes on button press in butt_pick_line.
function butt_pick_line_Callback(hObject, eventdata, handles)
handles = kymo_select_close(handles);
kym_show(handles);
guidata(hObject, handles);


% --- Executes on button press in butt_align_left.
function butt_align_left_Callback(hObject, eventdata, handles)
handles = kymo_align_pole(handles,1);
kym_show(handles);
guidata(hObject, handles);


% --- Executes on button press in butt_align_right.
function butt_align_right_Callback(hObject, eventdata, handles)
handles = kymo_align_pole(handles,0);
kym_show(handles);
guidata(hObject, handles);

% --- Executes on button press in butt_align_center.
function butt_align_center_Callback(hObject, eventdata, handles)
handles.shifted=0;
kym_show(handles);
guidata(hObject, handles);

% --- Executes on button press in butt_assign_left.
function butt_assign_left_Callback(hObject, eventdata, handles)
[handles] = kymo_reassing_line(handles,1);
kym_show(handles);
guidata(hObject, handles);


% --- Executes on button press in butt_assing_right.
function butt_assing_right_Callback(hObject, eventdata, handles)
[handles] = kymo_reassing_line(handles,0);
kym_show(handles);
guidata(hObject, handles);


% --- Executes on button press in butt_left_right.
function butt_left_right_Callback(hObject, eventdata, handles)
kym_show(handles);
guidata(hObject, handles);



% --- Executes on key press with focus on butt_prev and none of its controls.
function butt_prev_KeyPressFcn(hObject, eventdata, handles)
tus=get(gcf,'currentkey');

    



% --- Executes on key press with focus on butt_next and none of its controls.
function butt_next_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to butt_next (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in butt_measure_speed.
function butt_measure_speed_Callback(hObject, eventdata, handles)
handles = kymo_measure_speed(handles);
guidata(hObject, handles);


% --- Executes on selection change in menu_plot.
function menu_plot_Callback(hObject, eventdata, handles)
value=handles.menu_plot.String{handles.menu_plot.Value};

if strcmp('movie',value)
    handles=kymo_load_smart_kymo(handles);
end
guidata(hObject, handles);
kym_show(handles);

% --- Executes during object creation, after setting all properties.
function menu_plot_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butt_export_speeds.
function butt_export_speeds_Callback(hObject, eventdata, handles)
i = 0;
start = handles.current_kymo;
while i~=start
    if handles.shifted
        kymo_export_speeds(handles);
    end
    handles = kymo_select(handles,1);
    i = handles.current_kymo;
end
    

% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
message='';
switch eventdata.Key
    case 'a'
        handles = kymo_move(handles,-1);
    case 'd'
        handles = kymo_move(handles,+1);
    case 'f'    
        handles = kym_addline(handles);
    case 'q'
        % Special line
        handles = kym_addline(handles,1);
    case 'e'
        % Shrinking line
        handles = kym_addline(handles,2);
    case 'leftarrow'    
        [handles] = kymo_reassing_line(handles,1);
    case 'rightarrow'    
        [handles] = kymo_reassing_line(handles,0);
    case 'x'    
        handles.kymo_lines(handles.currentline)=[];
        handles = kymo_move(handles,0);
    case 's'    
        kymo_save(handles);
        message='Data saved';
    case 'space'
        handles = kymo_select(handles,1);
    case '1'
        handles = kymo_add_membrane_lines(handles,1);
    case '2'
        handles = kymo_add_membrane_lines(handles,0);
    case 'w'
        handles = kymo_select_close(handles);
end

kym_show(handles);
text(handles.ax_main,10,10,message,'Color','yellow','FontSize',20)
guidata(hObject, handles);


% --- Executes on button press in butt_print_info.
function butt_print_info_Callback(hObject, eventdata, handles)
kymo_print_info(handles);


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
handles.currentt=round(get(handles.slider1,'Value'));
kym_show(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in menu_kymo.
function menu_kymo_Callback(hObject, eventdata, handles)

handles.kymo = imread([handles.pathfile filesep handles.menu_kymo.String{handles.menu_kymo.Value}]);
kym_show(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function menu_kymo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_kymo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butt_open_video.
function butt_open_video_Callback(hObject, eventdata, handles)
if handles.tog_memb.Value
    system(['open ' handles.pathfile filesep 'probs_membrane.tif']);
    cd(handles.pathfile);
else
    system(['open ' handles.pathfile filesep 'movie.tif']);
    % system(['open ' handles.pathfile]);
    % repeatSmartKymo(handles.pathfile);
    cd(handles.pathfile);
    system(['open ' handles.pathfile filesep 'movie_membrane.tif']);
    % check_fits('movie.tif','linear_fits_smooth.txt','mask.tif');
end



% --- Executes on button press in butt_special_line.
function butt_special_line_Callback(hObject, eventdata, handles)
handles = kym_addline(handles,1);
kym_show(handles);
guidata(hObject, handles);


% --- Executes on button press in butt_shrinking_line.
function butt_shrinking_line_Callback(hObject, eventdata, handles)
handles = kym_addline(handles,2);
kym_show(handles);
guidata(hObject, handles);



function edit_xlim_low_Callback(hObject, eventdata, handles)
% hObject    handle to edit_xlim_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_xlim_low as text
%        str2double(get(hObject,'String')) returns contents of edit_xlim_low as a double
kym_show(handles);

% --- Executes during object creation, after setting all properties.
function edit_xlim_low_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_xlim_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_xlim_high_Callback(hObject, eventdata, handles)
% hObject    handle to edit_xlim_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_xlim_high as text
%        str2double(get(hObject,'String')) returns contents of edit_xlim_high as a double
kym_show(handles);


% --- Executes during object creation, after setting all properties.
function edit_xlim_high_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_xlim_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butt_special_kymo.
function butt_special_kymo_Callback(hObject, eventdata, handles)
if ~isfield(handles,'kymo_is_special')
    handles.kymo_is_special=1;
else
    handles.kymo_is_special=~handles.kymo_is_special;
end
guidata(hObject, handles);
kym_show(handles);

function edit_filter_files_Callback(hObject, eventdata, handles)
% hObject    handle to edit_filter_files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_filter_files as text
%        str2double(get(hObject,'String')) returns contents of edit_filter_files as a double


% --- Executes during object creation, after setting all properties.
function edit_filter_files_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_filter_files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butt_membrane_left.
function butt_membrane_left_Callback(hObject, eventdata, handles)
handles = kymo_add_membrane_lines(handles,1);
guidata(hObject, handles);

% --- Executes on button press in butt_membrane_right.
function butt_membrane_right_Callback(hObject, eventdata, handles)
handles = kymo_add_membrane_lines(handles,0);
guidata(hObject, handles);


% --- Executes on button press in tog_memb.
function tog_memb_Callback(hObject, eventdata, handles)
guidata(hObject, handles);
