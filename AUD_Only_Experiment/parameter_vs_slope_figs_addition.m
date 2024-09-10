function parameter_vs_slope_figs_addition(dataTable, color, labelSuffix)
% parameter_vs_slope_figs_addition Adds data to existing figures with specified color or creates new figures.
%
% This function takes in a table with data and adds the data to the existing
% figures in a specified color. If the figures do not exist, it creates new
% figures with the appropriate subplots and plotting conventions. The function
% ensures that the data is added following the same conventions as the data
% already plotted. It is flexible enough to handle cases where the data in the
% table only corresponds to a couple of conditions or is only from one subject.
%
% Parameters:
% ----------
% dataTable : table
%     A table containing the data to be added to the figures. The table
%     should include the following columns: 'velocity', 'duration',
%     'displacement', 'subjectID', 'slope', 'slope_std'.
%
% color : char
%     A character specifying the color to be used for the lines and markers
%     when adding the data to the figures.
%
% labelSuffix : char
%     A character string to be used as part of the figure legend labels.
%
% Examples:
% --------
% newData = table(...);  % Create or load your data table
% addDataToFigures(newData, 'orange', 'subject1');
%
% This will add the new data to the existing figures using orange lines and
% markers and the specified label suffix or create the figures if they do not exist.
%
% Notes:
% -----
% The function handles the creation of the figures and subplots if they do not
% already exist.

% Sort and filter the input table to not include 8 degree conditions
dataTable = dataTable(dataTable.displacement ~= 8, :);

if any(dataTable.session ~= dataTable.session(1))
    % Identify the slope column
    slope_column_idx = find(strcmp(dataTable.Properties.VariableNames, 'slope'));

    % Identify session and session_num columns, if they exist
    session_column_idx = find(strcmp(dataTable.Properties.VariableNames, 'session'));
    session_num_column_idx = find(strcmp(dataTable.Properties.VariableNames, 'session_num'));
    predicted_slopes_column_idx = find(strcmp(dataTable.Properties.VariableNames, 'predicted_slopes'));

    % Create a list of columns to ignore
    ignore_columns = [slope_column_idx, session_column_idx, session_num_column_idx,predicted_slopes_column_idx];

    % Identify the non-slope, non-session, and non-session_num columns
    non_slope_columns = dataTable(:, setdiff(1:width(dataTable), ignore_columns));

    % Find unique rows based on the non-slope, non-session, and non-session_num columns
    [unique_rows, ~, idx_group] = unique(non_slope_columns, 'rows');

    % Determine the number of repetitions per condition
    n_repetitions = sum(idx_group == 1);

    % Initialize arrays to hold the averaged slopes and their standard deviations
    averaged_slopes = zeros(height(unique_rows), 1);
    slope_std = zeros(height(unique_rows), 1);

    % Loop over each unique condition to compute the average slope and standard deviation
    for i_condition = 1:height(unique_rows)
        % Extract the slopes corresponding to the current unique condition
        slopes_for_i_condition = dataTable.slope(idx_group == i_condition);

        % Calculate the average and standard deviation of the slopes
        averaged_slopes(i_condition) = mean(slopes_for_i_condition);
        slope_std(i_condition) = std(slopes_for_i_condition);
    end

    % Add the averaged slopes and slope standard deviation to the unique rows
    new_dataTable = [unique_rows, table(averaged_slopes, slope_std)];
    new_dataTable.slope=new_dataTable.averaged_slopes;
    dataTable=new_dataTable;
end
% Display the  table
disp(dataTable);

% Separate data for subjects
baData = dataTable(strcmpi(dataTable.subjectID, 'ba'), :);
alvData = dataTable(strcmpi(dataTable.subjectID, 'alv'), :);

% Sorting data based on conditions
velocity_5995_ba = sortrows(baData(baData.velocity == 59.95, :), 'displacement');
velocity_5995_alv = sortrows(alvData(alvData.velocity == 59.95, :), 'displacement');
duration_0834_ba = sortrows(baData(baData.duration == 0.834, :), 'displacement');
duration_0834_alv = sortrows(alvData(alvData.duration == 0.834, :), 'displacement');
displacement_22_ba = sortrows(baData(baData.displacement == 22, :), 'velocity');
displacement_22_alv = sortrows(alvData(alvData.displacement == 22, :), 'velocity');

% Sorting for the third plot
displacement_22_ba_duration = sortrows(displacement_22_ba, 'duration');
displacement_22_alv_duration = sortrows(displacement_22_alv, 'duration');
velocity_5995_ba_duration = sortrows(velocity_5995_ba, 'duration');
velocity_5995_alv_duration = sortrows(velocity_5995_alv, 'duration');

% Check if the figure exists, if not, create it

figExist = ishandle(1) && strcmp(get(1, 'Type'), 'figure');
if ~figExist
    figure('Color', 'white', 'Position', [100, 100, 1600, 600]); % Adjust the figure size
     subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02], [0.05 0.04], [0.03 0.02]);
   
    for i_condition = 1:3
        subplot(1, 3, i_condition);
    end
end

% Plot 1: Slope vs Displacement
figure(1);
     subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02], [0.05 0.04], [0.03 0.02]);

subplot(1, 3, 1);

hold on;
if ~isempty(velocity_5995_ba)
    errorbar(velocity_5995_ba.displacement, velocity_5995_ba.slope, velocity_5995_ba.slope_std, ...
        '^-', 'LineWidth', 2, 'MarkerSize', 8, 'LineStyle', '--', 'DisplayName', ['Ba (duration changing) ', labelSuffix], 'Color', color);
end
if ~isempty(duration_0834_ba)
    errorbar(duration_0834_ba.displacement, duration_0834_ba.slope, duration_0834_ba.slope_std, ...
        'o-', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', ['Ba (velocity changing) ', labelSuffix], 'Color', color);
end
if ~isempty(velocity_5995_alv)
    errorbar(velocity_5995_alv.displacement, velocity_5995_alv.slope, velocity_5995_alv.slope_std, ...
        '^-', 'LineWidth', 2, 'MarkerSize', 8, 'LineStyle', '--', 'DisplayName', ['Alv (duration changing) ', labelSuffix], 'Color', color);
end
if ~isempty(duration_0834_alv)
    errorbar(duration_0834_alv.displacement, duration_0834_alv.slope, duration_0834_alv.slope_std, ...
        'o-', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', ['Alv (velocity changing) ', labelSuffix], 'Color', color);
end
xlabel('Displacement (degrees)');
ylabel('Slope');
title('Slope vs Displacement');
legend('Location', 'southeast');
ylim([0.8 2.6]);
grid on;
%hold off;

% Plot 2: Slope vs Velocity
subplot(1, 3, 2);
 hold on;
if ~isempty(displacement_22_ba)
    errorbar(displacement_22_ba.velocity, displacement_22_ba.slope, displacement_22_ba.slope_std, ...
        'd-', 'LineWidth', 2, 'MarkerSize', 8, 'LineStyle', ':', 'DisplayName', ['Ba (duration changing) ', labelSuffix], 'Color', color);
end
if ~isempty(duration_0834_ba)
    errorbar(duration_0834_ba.velocity, duration_0834_ba.slope, duration_0834_ba.slope_std, ...
        'o-', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', ['Ba (displacement changing) ', labelSuffix], 'Color', color);
end
if ~isempty(displacement_22_alv)
    errorbar(displacement_22_alv.velocity, displacement_22_alv.slope, displacement_22_alv.slope_std, ...
        'd-', 'LineWidth', 2, 'MarkerSize', 8, 'LineStyle', ':', 'DisplayName', ['Alv (duration changing) ', labelSuffix], 'Color', color);
end
if ~isempty(duration_0834_alv)
    errorbar(duration_0834_alv.velocity, duration_0834_alv.slope, duration_0834_alv.slope_std, ...
        'o-', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', ['Alv (displacement changing) ', labelSuffix], 'Color', color);
end
xlabel('Velocity (degrees/s)');
title('Slope vs Velocity');
legend('Location', 'southeast');
ylim([0.8 2.6]);

grid on;
%hold off;

% Plot 3: Slope vs Duration
subplot(1, 3, 3);
 hold on;
if ~isempty(displacement_22_ba_duration)
    errorbar(displacement_22_ba_duration.duration, displacement_22_ba_duration.slope, displacement_22_ba_duration.slope_std, ...
        'd-', 'LineWidth', 2, 'MarkerSize', 8, 'LineStyle', ':', 'DisplayName', ['Ba (velocity changing) ', labelSuffix], 'Color', color);
end
if ~isempty(velocity_5995_ba_duration)
    errorbar(velocity_5995_ba_duration.duration, velocity_5995_ba_duration.slope, velocity_5995_ba_duration.slope_std, ...
        '^-', 'LineWidth', 2, 'MarkerSize', 8, 'LineStyle', '--', 'DisplayName', ['Ba (displacement changing) ', labelSuffix], 'Color', color);
end
if ~isempty(displacement_22_alv_duration)
    errorbar(displacement_22_alv_duration.duration, displacement_22_alv_duration.slope, displacement_22_alv_duration.slope_std, ...
        'd-', 'LineWidth', 2, 'MarkerSize', 8, 'LineStyle', ':', 'DisplayName', ['Alv (velocity changing) ', labelSuffix], 'Color', color);
end
if ~isempty(velocity_5995_alv_duration)
    errorbar(velocity_5995_alv_duration.duration, velocity_5995_alv_duration.slope, velocity_5995_alv_duration.slope_std, ...
        '^-', 'LineWidth', 2, 'MarkerSize', 8, 'LineStyle', '--', 'DisplayName', ['Alv (displacement changing) ', labelSuffix], 'Color', color);
end
xlabel('Duration (s)');
title('Slope vs Duration');
legend('Location', 'southeast');
ylim([0.8 2.6]);
grid on;
%hold off;
% set(slope_vs_displacement, 'Position', [0.1, 0.7, 0.85, 0.25]);
% set(slope_vs_velocity, 'Position', [0.1, 0.4, 0.85, 0.25]);
% set(slope_vs_duration, 'Position', [0.1, 0.1, 0.85, 0.25]);