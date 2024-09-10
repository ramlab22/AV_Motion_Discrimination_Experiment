% Assuming the table is named 'dataTable' and has the following columns:
% velocity, duration, displacement, subjectID, slopes, slope_std

% Filter out conditions with 8 degree displacement
filteredTable = dataTable(dataTable.displacement ~= 8, :);

% Separate data for subjects
baData = filteredTable(strcmp(filteredTable.subjectID, 'ba'), :);
alvData = filteredTable(strcmp(filteredTable.subjectID, 'alv'), :);

% Sorting data based on conditions without 8 degree displacement
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

% Creating the figure with subplots
figure('Color', 'white', 'Position', [100, 100, 1400, 600]) % Adjust the figure size

% Plot 1: Slope vs Displacement
subplot(1, 3, 1)
hold on
errorbar(velocity_5995_ba.displacement, velocity_5995_ba.slope, velocity_5995_ba.slope_std, 'b-^', 'LineWidth', 2, 'MarkerSize', 8, 'LineStyle', '--', 'DisplayName', 'ba (duration changing)')
errorbar(duration_0834_ba.displacement, duration_0834_ba.slope, duration_0834_ba.slope_std, 'b-o', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'ba (velocity changing)')
errorbar(velocity_5995_alv.displacement, velocity_5995_alv.slope, velocity_5995_alv.slope_std, 'g-^', 'LineWidth', 2, 'MarkerSize', 8, 'LineStyle', '--', 'DisplayName', 'alv (duration changing)')
errorbar(duration_0834_alv.displacement, duration_0834_alv.slope, duration_0834_alv.slope_std, 'g-o', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'alv (velocity changing)')
xlabel('Displacement (degrees)')
ylabel('Slope')
title('Slope vs Displacement')
legend('Location', 'Best')
grid on
hold off

% Plot 2: Slope vs Velocity
subplot(1, 3, 2)
hold on
errorbar(displacement_22_ba.velocity, displacement_22_ba.slope, displacement_22_ba.slope_std, 'b-d', 'LineWidth', 2, 'MarkerSize', 8, 'LineStyle', ':', 'DisplayName', 'ba (duration changing)')
errorbar(duration_0834_ba.velocity, duration_0834_ba.slope, duration_0834_ba.slope_std, 'b-o', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'ba (displacement changing)')
errorbar(displacement_22_alv.velocity, displacement_22_alv.slope, displacement_22_alv.slope_std, 'g-d', 'LineWidth', 2, 'MarkerSize', 8, 'LineStyle', ':', 'DisplayName', 'alv (duration changing)')
errorbar(duration_0834_alv.velocity, duration_0834_alv.slope, duration_0834_alv.slope_std, 'g-o', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'alv (displacement changing)')
xlabel('Velocity (degrees/s)')
title('Slope vs Velocity')
legend('Location', 'Best')
grid on
hold off

% Plot 3: Slope vs Duration
subplot(1, 3, 3)
hold on
errorbar(displacement_22_ba_duration.duration, displacement_22_ba_duration.slope, displacement_22_ba_duration.slope_std, 'b-d', 'LineWidth', 2, 'MarkerSize', 8, 'LineStyle', ':', 'DisplayName', 'ba (velocity changing)')
errorbar(velocity_5995_ba_duration.duration, velocity_5995_ba_duration.slope, velocity_5995_ba_duration.slope_std, 'b-^', 'LineWidth', 2, 'MarkerSize', 8, 'LineStyle', '--', 'DisplayName', 'ba (displacement changing)')
errorbar(displacement_22_alv_duration.duration, displacement_22_alv_duration.slope, displacement_22_alv_duration.slope_std, 'g-d', 'LineWidth', 2, 'MarkerSize', 8, 'LineStyle', ':', 'DisplayName', 'alv (velocity changing)')
errorbar(velocity_5995_alv_duration.duration, velocity_5995_alv_duration.slope, velocity_5995_alv_duration.slope_std, 'g-^', 'LineWidth', 2, 'MarkerSize', 8, 'LineStyle', '--', 'DisplayName', 'alv (displacement changing)')
xlabel('Duration (seconds)')
title('Slope vs Duration')
legend('Location', 'Best')
grid on
hold off

% Adjusting subplot spacing
subplot(1, 3, 1)
pos = get(gca, 'Position');
set(gca, 'Position', [pos(1)-0.05, pos(2), pos(3)+0.05, pos(4)])

subplot(1, 3, 2)
pos = get(gca, 'Position');
set(gca, 'Position', [pos(1)-0.05, pos(2), pos(3)+0.05, pos(4)])

subplot(1, 3, 3)
pos = get(gca, 'Position');
set(gca, 'Position', [pos(1)-0.05, pos(2), pos(3)+0.05, pos(4)])
