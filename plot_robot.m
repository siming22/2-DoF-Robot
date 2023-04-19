function plot_robot(ax, L1, L2, q1, q2, x, y)
    % Check that q1 is not zero
    if q1 == 0
        q1 = eps; % Add a small value to avoid division by zero
    end
    
    % Calculate the positions of the robot arm segments
    p1 = [0, 0];
    p2 = [L1*cos(q1), L1*sin(q1)];
    p3 = [x, y];
    
    % Clear the existing plot
    cla(ax);
    
    % Plot the robot arm segments
    plot(ax, [p1(1), p2(1)], [p1(2), p2(2)], 'b-', 'LineWidth', 2);
    plot(ax, [p2(1), p3(1)], [p2(2), p3(2)], 'r-', 'LineWidth', 2);
    
    % Set the axis limits
    xlim(ax, [-L1-L2, L1+L2]);
    ylim(ax, [-L1-L2, L1+L2]);
    
    % Set the axis aspect ratio to equal
    axis(ax, 'equal');
end