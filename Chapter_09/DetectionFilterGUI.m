function varargout = DetectionFilterGUI(varargin)
%% DETECTIONFILTERGUI MATLAB code for DetectionFilterGUI.fig
%      DETECTIONFILTERGUI, by itself, creates a new DETECTIONFILTERGUI or raises the existing
%      singleton*.
%
%      H = DETECTIONFILTERGUI returns the handle to a new DETECTIONFILTERGUI or the handle to
%      the existing singleton*.
%
%      DETECTIONFILTERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DetectionFilterGUI.M with the given input arguments.
%
%      DETECTIONFILTERGUI('Property','Value',...) creates a new DETECTIONFILTERGUI or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DetectionFilterGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DetectionFilterGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DetectionFilterGUI

% Last Modified by GUIDE v2.5 08-May-2015 14:13:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DetectionFilterGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @DetectionFilterGUI_OutputFcn, ...
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


% --- Executes just before DetectionFilterGUI is made visible.
function DetectionFilterGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DetectionFilterGUI (see VARARGIN)

% Choose default command line output for DetectionFilterGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes DetectionFilterGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DetectionFilterGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function duration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function duration_Callback(hObject, eventdata, handles)
% hObject    handle to duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of duration as text
%        str2double(get(hObject,'String')) returns contents of duration as a double
duration = str2double(get(hObject, 'String'));
if isnan(duration)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new duration value
handles.filterdata.duration = duration;
guidata(hObject,handles)
UpdateGains(hObject, [], handles);


% --- Executes during object creation, after setting all properties.
function input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function input_Callback(hObject, eventdata, handles)
% hObject    handle to input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input as text
%        str2double(get(hObject,'String')) returns contents of input as a double
input = str2double(get(hObject, 'String'));
if isnan(input)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new input value
handles.filterdata.input = input;
guidata(hObject,handles)

% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
% hObject    handle to calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global inputFSent
global tachFSent

% get the data from the handles
u = handles.filterdata.input;
duration = handles.filterdata.duration;
tachF = handles.filterdata.tachF;
uF = handles.filterdata.uF;
dT = handles.filterdata.dT;

% initialize the simulation states and arrays
n  = ceil(duration/dT);
x  = [0;0];
d  = RHSAirTurbine;
dF = handles.filterdata.dF;
dF = DetectionFilter('reset',dF);
xP = zeros(4,n);
t  = (0:n-1)*dT;
dP = floor(n/100);

% prepare for plotting during the simulation
[tt,tL] = TimeLabel(duration);
tF = tt/duration;
axes(handles.states)
cla
hold on
axes(handles.residuals)
cla
hold on
xlabel(tL)

for k = 1:n
  if inputFSent
    inputFSent = false;
    data = guidata(hObject);
    uF = data.filterdata.uF;
  end
  if tachFSent
    tachFSent = false;
    data = guidata(hObject);
    tachF = data.filterdata.tachF;
  end
  y       = [x(1);tachF*x(2)]; % Sensor failure
  xP(:,k) = [x;dF.r];
  dF = DetectionFilter('update',u,y,dF);
  d.u = uF*u; % Actuator failure
  x   = RungeKutta( @RHSAirTurbine, t(k), x, dT, d );
  if rem(k,dP)==0
    plot(handles.states,tF*t(k), xP(1,k),'b.' );
    plot(handles.states,tF*t(k), xP(2,k),'r.' );
    plot(handles.residuals,tF*t(k), xP(3,k), 'b.' );
    plot(handles.residuals,tF*t(k), xP(4,k), 'r.' );
    drawnow
  end
end

% Plot the states and residuals
axes(handles.states)
plot(tF*t, xP(1:2,:) )
legend('p','\omega')
axes(handles.residuals)
plot(tF*t, xP(3:4,:) )
legend('r_p','r_{\omega}')


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

initialize_gui(gcbf, handles, true);

% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)

global tachFSent
global inputFSent

% If the filterdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.
if isfield(handles, 'filterdata') && ~isreset
    return;
end

handles.filterdata.duration = 1000;
handles.filterdata.input  = 100;
handles.filterdata.tau1  = 0.3;
handles.filterdata.tau2  = 0.3;
handles.filterdata.tachF  = 1.0;
handles.filterdata.uF  = 1.0;
handles.filterdata.dT = 0.1; % sec
handles.filterdata.dF = [];

set(handles.duration, 'String', handles.filterdata.duration);
set(handles.input,  'String', handles.filterdata.input);
set(handles.tau1,  'String', handles.filterdata.tau1);
set(handles.tau2,  'String', handles.filterdata.tau2);
set(handles.uF,  'String', handles.filterdata.uF);
set(handles.tachF,  'String', handles.filterdata.tachF);
set(handles.gains, 'String', '[]');

tachFSent = false;
inputFSent = false;

% Update handles structure
guidata(handles.figure1, handles);
UpdateGains(handles.figure1, [], handles);


% --- Executes on button press in sendTach.
function sendTach_Callback(hObject, eventdata, handles)
% hObject    handle to sendTach (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global tachFSent
tachFSent = true;

% --- Executes on button press in sendInput.
function sendInput_Callback(hObject, eventdata, handles)
% hObject    handle to sendInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global inputFSent
inputFSent = true;

function tachF_Callback(hObject, eventdata, handles)
% hObject    handle to tachF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tachF as text
%        str2double(get(hObject,'String')) returns contents of tachF as a double
tachF = str2double(get(hObject, 'String'));
if isnan(tachF)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new input value
handles.filterdata.tachF = tachF;
guidata(hObject,handles)



% --- Executes during object creation, after setting all properties.
function tachF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tachF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function uF_Callback(hObject, eventdata, handles)
% hObject    handle to uF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of uF as text
%        str2double(get(hObject,'String')) returns contents of uF as a double
uF = str2double(get(hObject, 'String'));
if isnan(uF)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new input value
handles.filterdata.uF = uF;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function uF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tau1_Callback(hObject, eventdata, handles)
% hObject    handle to tau1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tau1 = str2double(get(hObject, 'String'));
if isnan(tau1)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new duration value
handles.filterdata.tau1 = tau1;
guidata(hObject,handles)
UpdateGains(hObject,[],handles);


% --- Executes during object creation, after setting all properties.
function tau1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tau1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tau2_Callback(hObject, eventdata, handles)
% hObject    handle to tau2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tau2 as text
%        str2double(get(hObject,'String')) returns contents of tau2 as a double
tau2 = str2double(get(hObject, 'String'));
if isnan(tau2)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new duration value
handles.filterdata.tau2 = tau2;
guidata(hObject,handles)
UpdateGains(hObject,[],handles);


% --- Executes during object creation, after setting all properties.
function tau2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tau2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- update and display gains. called by other callbacks.
% the gains depend on tau1 and tau2
function UpdateGains(hObject, eventdata, handles)

tau1 = handles.filterdata.tau1;
tau2 = handles.filterdata.tau2;
dT = handles.filterdata.dT;

d = RHSAirTurbine;
dF = DetectionFilter('initialize',d,[tau1;tau2],dT);
handles.filterdata.dF = dF;
set(handles.gains, 'String', num2str(dF.d,3));
guidata(hObject,handles)
