function varargout = check_fits(varargin)
% CHECK_FITS MATLAB code for check_fits.fig
%      CHECK_FITS, by itself, creates a new CHECK_FITS or raises the existing
%      singleton*.
%
%      H = CHECK_FITS returns the handle to a new CHECK_FITS or the handle to
%      the existing singleton*.
%
%      CHECK_FITS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHECK_FITS.M with the given input arguments.
%
%      CHECK_FITS('Property','Value',...) creates a new CHECK_FITS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before check_fits_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to check_fits_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help check_fits

% Last Modified by GUIDE v2.5 12-Feb-2021 12:12:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @check_fits_OpeningFcn, ...
                   'gui_OutputFcn',  @check_fits_OutputFcn, ...
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


% --- Executes just before check_fits is made visible.
function check_fits_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
handles.file_name = varargin{1};
handles.fits_name = varargin{2};
if numel(varargin)==3
    handles.mask = ~logical(readTiff(varargin{3}));
else
    handles.mask = 1;
end
handles.fits = dlmread(handles.fits_name,' ');
handles.movie = readTiff(handles.file_name);
tlen = size(handles.movie,3);
set(handles.slider1,'Max',tlen);
set(handles.slider1,'Min',1);
set(handles.slider1,'Value',1);
set(handles.slider1,'SliderStep',[1, 1]/(tlen-1));
handles.butt_dots.Value=1;
handles.kymo_lines=[];
handles.left_edge=[];
handles.right_edge=[];
if isfile('kymo_save.mat')
    loaded=load('kymo_save.mat');
    handles.kymo_lines = loaded.out.kymo_lines;
    handles.left_edge= loaded.out.left_edge;
    handles.right_edge= loaded.out.right_edge;
    movie_sub = handles.movie;
    
    nb_frames = size(handles.movie,3);
    background = zeros(1,nb_frames);
    for i = 1:nb_frames
        d = handles.movie(:,:,i);
        background(i) = mean(d(:));
        movie_sub(:,:,i) = d-background(i);
    end
    [handles.xc,handles.yc]=imageCenterOfMass(max(movie_sub,[],3).*handles.mask);
    linear_fits_smooth = dlmread('linear_fits_smooth.txt',' ');
    
    [im_profiles,xx_profiles,yy_profiles] = profilesFromLines2(handles.movie,linear_fits_smooth,'mean');
    [handles.centers] = findIndexClosestPoint2Polyline(xx_profiles,yy_profiles,handles.xc,handles.yc);
    
end

if isfile('smart_kymo.mat')
    handles.smart_kymo = load('smart_kymo.mat');
end

if isfile('spbs.txt')
    handles.spbs = csvread('spbs.txt');
else
    handles.spbs = nan(size(handles.movie,3),4);
end

guidata(hObject, handles);

% UIWAIT makes check_fits wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = check_fits_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
    t = round(get(handles.slider1,'Value'));
    axes(handles.ax_extra)
    cla
    int_edges= [str2num(handles.textedit_low_int.String),str2num(handles.textedit_high_int.String)];
    imshow(handles.movie(:,:,t).*handles.mask,int_edges,'InitialMagnification','fit')
    hold on
    drawKymoLinesOnFrame(handles,t);
    scatter(handles.spbs(t,1),handles.spbs(t,2),'r')
    scatter(handles.spbs(t,3),handles.spbs(t,4),'g')




% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in butt_dots.
function butt_dots_Callback(hObject, eventdata, handles)
% hObject    handle to butt_dots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of butt_dots



function textedit_low_int_Callback(hObject, eventdata, handles)
% hObject    handle to textedit_low_int (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textedit_low_int as text
%        str2double(get(hObject,'String')) returns contents of textedit_low_int as a double


% --- Executes during object creation, after setting all properties.
function textedit_low_int_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textedit_low_int (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function textedit_high_int_Callback(hObject, eventdata, handles)
% hObject    handle to textedit_high_int (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textedit_high_int as text
%        str2double(get(hObject,'String')) returns contents of textedit_high_int as a double


% --- Executes during object creation, after setting all properties.
function textedit_high_int_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textedit_high_int (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
