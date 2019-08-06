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

% Last Modified by GUIDE v2.5 29-Jul-2019 10:49:13

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
    axes(handles.axes_main)
    cla
    imshow(handles.movie(:,:,t).*handles.mask,[],'InitialMagnification','fit')
    hold on
    pars = handles.fits(t,:);
    x = linspace(-150,150);
    y = x.^2*pars(4);
    
    theta = -pars(1);
    R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    coords = [x; y]' * R;
    x = coords(:,1);
    y = coords(:,2);
    x = x+pars(2);
    y = y+pars(3);
    
    plot(x,y)
    scatter(pars(2),pars(3))



% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
