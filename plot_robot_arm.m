function plot_robot_arm(ax, L1, L2, q1, q2, trajectory)
    % Calculate the position of the joints
    x1 = L1 * cos(q1);
    y1 = L1 * sin(q1);
    x2 = x1 + L2 * cos(q1 + q2);
    y2 = y1 + L2 * sin(q1 + q2);

    % Plot the trajectory
    plot(ax, trajectory(1, :), trajectory(2, :), 'r-', 'LineWidth', 1);
    hold(ax, 'on');

    % Plot the robot arm
    plot(ax, [0, x1], [0, y1], 'b-', 'LineWidth', 2);
    plot(ax, [x1, x2], [y1, y2], 'g-', 'LineWidth', 2);
    scatter(ax, [0, x1, x2], [0, y1, y2], 'ko', 'filled');
    
    % Set the axis limits and labels
    xlim(ax, [-L1-L2, L1+L2]);
    ylim(ax, [-L1-L2, L1+L2]);
    xlabel(ax, 'X');
    ylabel(ax, 'Y');
    title(ax, 'Robot Arm Position');
    
    % Release the hold on the axes
    hold(ax, 'off');
end