%% BOXANIMATIONGUI MATLAB code for BoxAnimationGUI.fig
%      BOXANIMATIONGUI, by itself, creates a new BOXANIMATIONGUI or raises the existing
%      singleton*.
%
%      H = BOXANIMATIONGUI returns the handle to a new BOXANIMATIONGUI or the handle to
%      the existing singleton*.
%
%      BOXANIMATIONGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BOXANIMATIONGUI.M with the given input arguments.
%
%      BOXANIMATIONGUI('Property','Value',...) creates a new BOXANIMATIONGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BoxAnimationGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BoxAnimationGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
%% See also: GUIDE, GUIDATA, GUIHANDLES

function varargout = BoxAnimationGUI(varargin)

% Edit the above text to modify the response to help BoxAnimationGUI

% Last Modified by GUIDE v2.5 25-Aug-2015 15:10:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BoxAnimationGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @BoxAnimationGUI_OutputFcn, ...
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

% --- Executes just before BoxAnimationGUI is made visible.
function BoxAnimationGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BoxAnimationGUI (see VARARGIN)

% ADDED CUSTOM CODE FOR RECIPE
% Design the box
x   = 3;
y   = 2;
z   = 1;
f   = [2 3 6;3 7 6;3 4 8;3 8 7;4 5 8;4 1 5;2 6 5;2 5 1;1 3 2;1 4 3;5 6 7;5 7 8];
v = [-x  x  x -x -x  x  x -x;...
     -y -y  y  y -y -y  y  y;...
     -z -z -z -z  z  z  z  z]'/2;

% Create the figure
h = figure('name','Box');
p = patch('vertices',v,'faces',f,'facecolor',[0.5 0.5 0.5],...
          'linestyle','none','facelighting','gouraud');
ax = gca;
set(ax,'DataAspectRatio',[1 1 1],'DataAspectRatioMode','manual')
grid on
axis([-3 3 -3 3 -3 3])
xlabel('x')
ylabel('y')
zlabel('z')
view(3)
light('position',[0 0 1]);

% Choose default command line output for BoxAnimationGUI
handles.output = hObject;

% Additional variables required
handles.data.box = p;
handles.data.vertices = v;
handles.data.axis = ax;
handles.data.figure = h;
% END CUSTOM CODE

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BoxAnimationGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BoxAnimationGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function pauseDur_Callback(hObject, eventdata, handles)
% hObject    handle to pauseDur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pauseDur as text
%        str2double(get(hObject,'String')) returns contents of pauseDur as a double

% ADDED CUSTOM CODE FOR RECIPE
pauseDur = str2double(get(hObject,'String'));
% Optional: add checking of pause value; can't be negative
handles.data.pauseVal = pauseDur;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function pauseDur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pauseDur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% ADDED CUSTOM CODE FOR RECIPE
pauseDur = str2double(get(hObject,'String'));
% Optional: add checking of pause value; can't be negative
handles.data.pauseVal = pauseDur;
guidata(hObject, handles);


% --- Executes on button press in startButton.
function startButton_Callback(hObject, eventdata, handles)
% hObject    handle to startButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ADDED CUSTOM CODE FOR RECIPE
dT = handles.data.pauseVal; % pause duration from our edit box
p = handles.data.box;       % handle to the patch object
v0 = handles.data.vertices; % initial vertices, before rotation
ax = handles.data.axis;     % axis, for updating title

n = 1000;
a = linspace(0,8*pi,n);

c = cos(a);
s = sin(a);

for k = 1:n
  b   = [c(k) 0 s(k);0 1 0;-s(k) 0 c(k)];
  vK  = (b*v0')';
  set(p,'vertices',vK);
  if rem(k,25)==0
    title(ax,sprintf('Angle: %.5g deg',a(k)*180/pi));
  end
  pause(dT); 
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);

% ADDED CUSTOM CODE FOR RECIPE
delete(handles.data.figure)
