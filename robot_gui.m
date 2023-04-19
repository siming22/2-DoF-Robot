

function robot_gui
% Create a figure and axes for the GUI
f = figure('Visible','off','Position',[360,500,450,285]);
ax = axes('Units','pixels','Position',[50,60,300,200]);

% Create input boxes for the target point
uicontrol('Style','text','String','Target Point','Position',[325,220,80,20]);
uicontrol('Style','text','String','Px:','Position',[325,200,20,20]);
px_box = uicontrol('Style','edit','Position',[345,200,60,20]);
uicontrol('Style','text','String','Py:','Position',[325,180,20,20]);
py_box = uicontrol('Style','edit','Position',[345,180,60,20]);

% Create buttons for calculating the joint angles and trajectory
uicontrol('Style','pushbutton','String','Calculate','Position',[325,140,80,20],...
    'Callback',@calculate_callback);
uicontrol('Style','pushbutton','String','Trajectory','Position',[325,100,80,20],...
    'Callback',@trajectory_callback);

% Initialize the robot arm
L1 = 1; L2 = 0.5;
q1 = 0; q2 = 0;
% Define the time step delta
delta = 0.1;
x = L1*cos(q1) + L2*cos(q1+q2);
y = L1*sin(q1) + L2*sin(q1+q2);
plot_robot(ax, L1, L2, q1, q2, x, y);

% Make the GUI visible
f.Visible = 'on';



end



% Callback function for the calculate button
function calculate_callback(hObject,eventdata)

    % Define px_box and py_box as global variables
    global px_box py_box;
    global L1 L2 q2 q1 ax;
   delta = 0.1;


    % Get the target point from the input boxes
    px = str2double(get(px_box, 'String'));
    py = str2double(get(py_box, 'String'));
    
    % Calculate the joint angles
    q1 = atan2(py, px) - atan2(L2*sin(q2), L1+L2*cos(q2));
    q2 = acos((px*cos(q1) + py*sin(q1) - L1) / L2);
    
    % Update the robot arm plot
    x = L1*cos(q1) + L2*cos(q1+q2);
    y = L1*sin(q1) + L2*sin(q1+q2);
    plot_robot(ax, L1, L2, q1, q2, x, y);
end

function trajectory_callback(hObject, eventdata)
    % Declare L1, L2, delta, ax, and trajectory as global variables
    global L1 L2 delta ax trajectory;
    
    % Declare px_box, py_box, and n_box as global variables
    global px_box py_box n_box;
    
    % Get the target point from the input boxes
    px = str2double(get(px_box, 'String'));
    py = str2double(get(py_box, 'String'));
    
    % Get the number of points from the input box
    n = round(str2double(get(n_box, 'String')));
    
    % Calculate the joint angles
    q1 = atan2(py, px) - atan2(L2*sin(q2), L1+L2*cos(q2));
    q2 = acos((px*cos(q1) + py*sin(q1) - L1) / L2);
    
    % Calculate the trajectory points
    t = linspace(0, delta, n);
    x = L1*cos(q1) + L2*cos(q1+q2);
    y = L1*sin(q1) + L2*sin(q1+q2);
    dx = -delta/(L2*sin(q2))*(sin(q1+q2));
    dy = delta/L2*sin(q2)*cos(q1+q2);
    trajectory = [x + dx*t; y + dy*t];
    
    % Update the robot arm plot
    plot_robot(ax, L1, L2, q1, q2, x, y);
    
    % Plot the trajectory
    hold(ax, 'on');
    plot(ax, trajectory(1,:), trajectory(2,:), 'g-', 'LineWidth', 1);
    hold(ax, 'off');
end