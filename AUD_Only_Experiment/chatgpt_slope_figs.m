% Data
slope = [1.2535, 1.1632, 1.2857, 1.4827, 1.6939, 1.9942, 0.9438, 1.0364, 1.2811, 1.3688, 1.8106, 1.7191, 1.427, 1.263, 1.9879, 2.4939, 1.1704, 1.455, 1.6208, 1.8783, 1.0431, 1.2, 1.0881, 1.0333, 1.0143, 1.2908];
velocity = [9.59, 26.38, 43, 59.95, 76.74, 93.5, 9.59, 26.38, 43, 59.95, 76.74, 93.5, 59.95, 59.95, 59.95, 59.95, 59.95, 59.95, 59.95, 59.95, 36.61, 20, 16.9, 36.61, 20, 16.9];
duration = [0.834, 0.834, 0.834, 0.834, 0.834, 0.834, 0.834, 0.834, 0.834, 0.834, 0.834, 0.834, 0.367, 0.601, 1.1, 1.3, 0.367, 0.601, 1.1, 1.3, 0.601, 1.1, 1.3, 0.601, 1.1, 1.3];
displacement = [8, 22, 36, 50, 66, 78, 8, 22, 36, 50, 66, 78, 22, 36, 66, 78, 22, 36, 66, 78, 22, 22, 22, 22, 22, 22];
subjectID = {'Ba', 'Ba', 'Ba', 'Ba', 'Ba', 'Ba', 'Alv', 'Alv', 'Alv', 'Alv', 'Alv', 'Alv', 'Ba', 'Ba', 'Ba', 'Ba', 'Alv', 'Alv', 'Alv', 'Alv', 'Ba', 'Ba', 'Ba', 'Alv', 'Alv', 'Alv'};
slope_std = [0.1108, 0.0471, 0.0209, 0.0164, 0.02, 0.0299, 0.0505, 0.0378, 0.0248, 0.0213, 0.0257, 0.0207, 0.0357, 0.0217, 0.0281, 0.0481, 0.0249, 0.0213, 0.0208, 0.026, 0.029, 0.0401, 0.0381, 0.0236, 0.0292, 0.0453];

% Filtered data without 8 degree displacement and 165 degree/s velocity
mask = displacement ~= 8 & velocity ~= 165.4;
slope = slope(mask);
velocity = velocity(mask);
duration = duration(mask);
displacement = displacement(mask);
subjectID = subjectID(mask);
slope_std = slope_std(mask);

% Separate data for subjects
ba_mask = strcmp(subjectID, 'Ba');
alv_mask = strcmp(subjectID, 'Alv');

% Data for 'Ba'
ba_slope = slope(ba_mask);
ba_velocity = velocity(ba_mask);
ba_duration = duration(ba_mask);
ba_displacement = displacement(ba_mask);
ba_slope_std = slope_std(ba_mask);

% Data for 'Alv'
alv_slope = slope(alv_mask);
alv_velocity = velocity(alv_mask);
alv_duration = duration(alv_mask);
alv_displacement = displacement(alv_mask);
alv_slope_std = slope_std(alv_mask);

% Sort data
[~, ba_idx] = sort(ba_displacement);
[~, alv_idx] = sort(alv_displacement);
[~, ba_idx_vel] = sort(ba_velocity);
[~, alv_idx_vel] = sort(alv_velocity);
[~, ba_idx_dur] = sort(ba_duration);
[~, alv_idx_dur] = sort(alv_duration);

ba_displacement_sorted = ba_displacement(ba_idx);
ba_slope_sorted = ba_slope(ba_idx);
ba_slope_std_sorted = ba_slope_std(ba_idx);
alv_displacement_sorted = alv_displacement(alv_idx);
alv_slope_sorted = alv_slope(alv_idx);
alv_slope_std_sorted = alv_slope_std(alv_idx);

ba_velocity_sorted = ba_velocity(ba_idx_vel);
ba_slope_vel_sorted = ba_slope(ba_idx_vel);
ba_slope_std_vel_sorted = ba_slope_std(ba_idx_vel);
alv_velocity_sorted = alv_velocity(alv_idx_vel);
alv_slope_vel_sorted = alv_slope(alv_idx_vel);
alv_slope_std_vel_sorted = alv_slope_std(alv_idx_vel);

ba_duration_sorted = ba_duration(ba_idx_dur);
ba_slope_dur_sorted = ba_slope(ba_idx_dur);
ba_slope_std_dur_sorted = ba_slope_std(ba_idx_dur);
alv_duration_sorted = alv_duration(alv_idx_dur);
alv_slope_dur_sorted = alv_slope(alv_idx_dur);
alv_slope_std_dur_sorted = alv_slope_std(alv_idx_dur);

% Plotting
figure;

% Plot 1: Slope vs Displacement
subplot(1, 3, 1);
errorbar(ba_displacement_sorted, ba_slope_sorted, ba_slope_std_sorted, 'b--^',  'MarkerSize', 10,'LineWidth',5);
hold on;
errorbar(alv_displacement_sorted, alv_slope_sorted, alv_slope_std_sorted, 'g--^',  'MarkerSize', 10,'LineWidth',5);
errorbar(ba_displacement_sorted, ba_slope_sorted, ba_slope_std_sorted, 'b-o', 'MarkerSize', 10,'LineWidth',5);
errorbar(alv_displacement_sorted, alv_slope_sorted, alv_slope_std_sorted, 'g-o', 'MarkerSize', 10,'LineWidth',5);
xlabel('Displacement (degrees)');
ylabel('Slope');
title('Slope vs Displacement');
grid on;
legend('Ba velocity 59.95 (duration changing)', 'Alv velocity 59.95 (duration changing)', 'Ba duration 0.834(velocity changing)', 'Alv duration 0.834 (velocity changing)');

% Plot 2: Slope vs Velocity
subplot(1, 3, 2);
errorbar(ba_velocity_sorted, ba_slope_vel_sorted, ba_slope_std_vel_sorted, 'b:d',  'MarkerSize', 10,'LineWidth',5);
hold on;
errorbar(alv_velocity_sorted, alv_slope_vel_sorted, alv_slope_std_vel_sorted, 'g:d',  'MarkerSize', 10,'LineWidth',5);
errorbar(ba_velocity_sorted, ba_slope_vel_sorted, ba_slope_std_vel_sorted, 'b-o', 'MarkerSize', 10,'LineWidth',5);
errorbar(alv_velocity_sorted, alv_slope_vel_sorted, alv_slope_std_vel_sorted, 'g-o', 'MarkerSize', 10,'LineWidth',5);
xlabel('Velocity (degrees/s)');
title('Slope vs Velocity');
grid on;
legend('Ba displacement 22 (duration changing)', 'Alv displacement 22 (duration changing)', 'Ba duration 0.834 (displacement changing)', 'Alv duration 0.834 (displacement changing)');

% Plot 3: Slope vs Duration
subplot(1, 3, 3);
errorbar(ba_duration_sorted, ba_slope_dur_sorted, ba_slope_std_dur_sorted, 'b:d',  'MarkerSize', 10,'LineWidth',5);
hold on;
errorbar(alv_duration_sorted, alv_slope_dur_sorted, alv_slope_std_dur_sorted, 'g:d',  'MarkerSize', 10,'LineWidth',5);
errorbar(ba_duration_sorted, ba_slope_dur_sorted, ba_slope_std_dur_sorted, 'b--^',  'MarkerSize', 10,'LineWidth',5);
errorbar(alv_duration_sorted, alv_slope_dur_sorted, alv_slope_std_dur_sorted, 'g--^',  'MarkerSize', 10,'LineWidth',5);
xlabel('Duration (seconds)');
title('Slope vs Duration');
grid on;
legend('Ba displacement 22 (velocity changing)', 'Alv displacement 22 (velocity changing)', 'Ba velocity 59.95 (displacement changing)', 'Alv velocity 59.95 (displacement changing)');

% Adjust layout
resizeFigures();