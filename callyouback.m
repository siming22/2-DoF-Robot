
function varargout = callyouback(varargin)
% CALLYOUBACK MATLAB code for callyouback.fig
%      CALLYOUBACK, by itself, creates a new CALLYOUBACK or raises the existing
%      singleton*.
%
%      H = CALLYOUBACK returns the handle to a new CALLYOUBACK or the handle to
%      the existing singleton*.
%
%      CALLYOUBACK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALLYOUBACK.M with the given input arguments.
%
%      CALLYOUBACK('Property','Value',...) creates a new CALLYOUBACK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before callyouback_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to callyouback_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help callyouback

% Last Modified by GUIDE v2.5 18-Apr-2023 17:49:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @callyouback_OpeningFcn, ...
                   'gui_OutputFcn',  @callyouback_OutputFcn, ...
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


% --- Executes just before callyouback is made visible.
function callyouback_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to callyouback (see VARARGIN)

% Choose default command line output for callyouback
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes callyouback wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = callyouback_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function editPx_Callback(hObject, eventdata, handles)
% hObject    handle to editPx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editPx as text
%        str2double(get(hObject,'String')) returns contents of editPx as a double


% --- Executes during object creation, after setting all properties.
function editPx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editPy_Callback(hObject, eventdata, handles)
% hObject    handle to editPy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editPy as text
%        str2double(get(hObject,'String')) returns contents of editPy as a double


% --- Executes during object creation, after setting all properties.
function editPy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get target coordinates from the input text boxes
Px = str2double(get(handles.editPx, 'String'));
Py = str2double(get(handles.editPy, 'String'));

% Define robot arm parameters (e.g., lengths of links)
L1 = 1;
L2 = 1;

% Get the current joint angles
global q1 q2;


% Calculate the current end effector position
x2_current = L1 * cos(q1) + L2 * cos(q1 + q2);
y2_current = L1 * sin(q1) + L2 * sin(q1 + q2);

% Calculate joint angles using inverse kinematics for the target position
q2_target = acos((Px^2 + Py^2 - L1^2 - L2^2) / (2 * L1 * L2));
q1_target = atan2(Py, Px) - atan2(L2 * sin(q2_target), L1 + L2 * cos(q2_target));

% Set the desired step size and calculate the number of steps
step_size = 0.01; % You can adjust the step size as needed
distance = sqrt((Px - x2_current)^2 + (Py - y2_current)^2);
num_steps = ceil(distance / step_size);

% Ensure num_steps is a positive integer
if num_steps <= 0
    num_steps = 1;
end

%%%

% Iterate through the trajectory steps
trajectory = [linspace(x2_current, Px, num_steps); linspace(y2_current, Py, num_steps)];
for i = 1:num_steps
    % Calculate joint angles using inverse kinematics for the current trajectory point
    Px_step = trajectory(1, i);
    Py_step = trajectory(2, i);
    q2_step = acos((Px_step^2 + Py_step^2 - L1^2 - L2^2) / (2 * L1 * L2));
    q1_step = atan2(Py_step, Px_step) - atan2(L2 * sin(q2_step), L1 + L2 * cos(q2_step));

    % Update the global joint angles
    global q1 q2;
    q1 = q1_step;
    q2 = q2_step;

    % Update the joint angles displayed in the GUI (in degrees)
    set(handles.textQ1_degrees, 'String', sprintf('q1: %.2f°', rad2deg(q1)));
    set(handles.textQ2_degrees, 'String', sprintf('q2: %.2f°', rad2deg(q2)));
    
    % Update the joint angles displayed in the GUI
    set(handles.textQ1, 'String', sprintf('q1: %.2f rad', q1));
    set(handles.textQ2, 'String', sprintf('q2: %.2f rad', q2));
    
    % Plot the robot arm and trajectory
    plot_robot_arm(handles.axes1, L1, L2, q1_step, q2_step, trajectory(:, 1:i));
    pause(0.01); % Add a small delay for smooth animation
end
