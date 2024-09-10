x_axis_condition='displacement'; %duration, velocity displacement are other options
save_fig=1; %set to 1 if you want the figure to be saved
plotting_round=2 ; %if plotting multiple parameters on a plot, set one top first parameter and 2 for the other
error_bars=1;
fig_save_path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/';
if plotting_round==1
    switch x_axis_condition
        case 'velocity'
            % constant displacement
            ba_path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_displacement/';
            alv_path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_displacement/';

            if error_bars==1
                ba_data_save_path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/errorbar_figs/dynamic_range_slope_dis22/';
                alv_data_save_path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/errorbar_figs/dynamic_range_slope_dis22/';

            else
                ba_data_save_path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/dynamic_range_slope_dis22/';
                alv_data_save_path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/dynamic_range_slope_dis22/';

            end
        case 'duration'
            % constant displacement
            ba_path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_displacement/';
            alv_path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_displacement/';

            if error_bars==1
                ba_data_save_path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/errorbar_figs/dynamic_range_slope_dis22/';
                alv_data_save_path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/errorbar_figs/dynamic_range_slope_dis22/';

            else
                ba_data_save_path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/dynamic_range_slope_dis22/';
                alv_data_save_path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/dynamic_range_slope_dis22/';

            end
        case 'displacement'
            % constant duration
            ba_path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_duration/';
            alv_path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_duration/';

            if error_bars==1
                ba_data_save_path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/errorbar_figs/dynamic_range_slope_dur834ms/';
                alv_data_save_path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/errorbar_figs/dynamic_range_slope_dur834ms/';

            else
                ba_data_save_path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/dynamic_range_slope_dur834ms/';
                alv_data_save_path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/dynamic_range_slope_dur834ms/';

            end
    end
else
    switch x_axis_condition
        case 'velocity'
            % constant duration
            ba_path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_duration/';
            alv_path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_duration/';

            if error_bars==1
                ba_data_save_path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/errorbar_figs/dynamic_range_slope_dur834ms/';
                alv_data_save_path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/errorbar_figs/dynamic_range_slope_dur834ms/';

            else
                ba_data_save_path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/dynamic_range_slope_dur834ms/';
                alv_data_save_path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/dynamic_range_slope_dur834ms/';
            end
        case 'duration'
            % constant velocity
            ba_path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_velocity/';
            alv_path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_velocity/';

            if error_bars==1
                ba_data_save_path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/errorbar_figs/dynamic_range_slope_vel59.95/';
                alv_data_save_path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/errorbar_figs/dynamic_range_slope_vel59.95/';

            else
                ba_data_save_path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/dynamic_range_slope_vel59.95/';
                alv_data_save_path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/dynamic_range_slope_vel59.95/';

            end
        case 'displacement'
            % constant velocity
            ba_path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_velocity/';
            alv_path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_velocity/';

            if error_bars==1
                ba_data_save_path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/errorbar_figs/dynamic_range_slope_vel59.95/';
                alv_data_save_path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/errorbar_figs/dynamic_range_slope_vel59.95/';

            else
                ba_data_save_path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/dynamic_range_slope_vel59.95/';
                alv_data_save_path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/dynamic_range_slope_vel59.95/';

            end
    end
end

%% Baron
[~,ba_data_save_path_existing_files] = get_datafile_info(ba_data_save_path);
ba_all_condition_paths=getSubfolders(ba_path);
for i_condition=1:length(ba_all_condition_paths)
    pathParts = strsplit(ba_all_condition_paths{i_condition}, filesep);
    lastFolder = pathParts{end};
    ba_data_file_already_exists = any(contains(ba_data_save_path_existing_files, lastFolder));
    if ~ba_data_file_already_exists
        condition_path=[ba_all_condition_paths{i_condition},'/'];
        [ba_condition_std_gaussian_scaled, ba_condition_slope_at_50_percent_scaled, ~, ba_condition_slope_dynamicrange,ba_condition_save_name] = analyze_combined_auditory_blocks(condition_path,ba_data_save_path);
        close all;
    end
end

[ba_slope_dynamicrange,ba_std_cumgaus_scaled,ba_totalfiles_names] = load_data_for_parameter_performance_plot(ba_data_save_path);
[ba_bootstrap_slopes,ba_bootstrap_mean_slopes,ba_bootstrap_std_slopes,ba_bootstrap_median_slopes,~] = load_bootstrap_data_for_parameter_performance_plot(ba_data_save_path);
[ba_velocities, ba_displacements,ba_durations] = extract_file_parameters(ba_totalfiles_names);
% Sort ba and get the sorted indices
switch x_axis_condition
    case 'velocity'
        [sorted_ba_xvals, ba_idx] = sort(ba_velocities);

    case 'duration'
        [sorted_ba_xvals, ba_idx] = sort(ba_durations);

    case 'displacement'
        [sorted_ba_xvals, ba_idx] = sort(ba_displacements);
end

% Use the indices to rearrange ba_slope_dynamicrange and ba_std_cumgaus_scaled
sorted_ba_slope_dynamicrange = ba_slope_dynamicrange(ba_idx);
sorted_ba_std_cumgaus_scaled = ba_std_cumgaus_scaled(ba_idx);
sorted_ba_bootstrap_median_slopes=ba_bootstrap_median_slopes(ba_idx);
sorted_ba_bootstrap_mean_slopes=ba_bootstrap_mean_slopes(ba_idx);
sorted_ba_bootstrap_std_slopes=ba_bootstrap_std_slopes(ba_idx);
%% Alvarez
[~,alv_data_save_path_existing_files] = get_datafile_info(alv_data_save_path);
alv_all_condition_paths=getSubfolders(alv_path);
for i_condition=1:length(alv_all_condition_paths)
    pathParts = strsplit(alv_all_condition_paths{i_condition}, filesep);
    lastFolder = pathParts{end};
    alv_data_file_already_exists = any(contains(alv_data_save_path_existing_files, lastFolder));
    if ~alv_data_file_already_exists
        condition_path=[alv_all_condition_paths{i_condition},'/'];
        [alv_condition_std_gaussian_scaled, alv_condition_slope_at_50_percent_scaled, ~, alv_condition_slope_dynamicrange,alv_condition_save_name] = analyze_combined_auditory_blocks(condition_path,alv_data_save_path);
        close all;
    end
end

[alv_slope_dynamicrange,alv_std_cumgaus_scaled,alv_totalfiles_names] = load_data_for_parameter_performance_plot(alv_data_save_path);
[alv_bootstrap_slopes,alv_bootstrap_mean_slopes,alv_bootstrap_std_slopes,alv_bootstrap_median_slopes,~] = load_bootstrap_data_for_parameter_performance_plot(alv_data_save_path);

[alv_velocities, alv_displacements,alv_durations] = extract_file_parameters(alv_totalfiles_names);
% Sort x axis parameter and get the sorted indices
switch x_axis_condition
    case 'velocity'
        [sorted_alv_xvals, alv_idx] = sort(alv_velocities);

    case 'duration'
        [sorted_alv_xvals, alv_idx] = sort(alv_durations);

    case 'displacement'
        [sorted_alv_xvals, alv_idx] = sort(alv_displacements);
end

% Use the indices to rearrange data and stats data arrays
sorted_alv_slope_dynamicrange = alv_slope_dynamicrange(alv_idx);
sorted_alv_std_cumgaus_scaled = alv_std_cumgaus_scaled(alv_idx);
sorted_alv_bootstrap_median_slopes=alv_bootstrap_median_slopes(alv_idx);
sorted_alv_bootstrap_mean_slopes=alv_bootstrap_mean_slopes(alv_idx);
sorted_alv_bootstrap_std_slopes=alv_bootstrap_std_slopes(alv_idx);

%% Create figure
if plotting_round==1
    fig = figure('Name', 'Combined Plots');
end
%fig.Position = [100, 100, 1200, 600]; % Adjust figure size

% First subplot
%subplot(1, 2, 1); % 1 row, 2 columns, 1st subplot
switch x_axis_condition
    case 'duration'
        sorted_alv_xvals=sorted_alv_xvals/1000;
        sorted_ba_xvals=sorted_ba_xvals/1000;

end
if plotting_round==1
    if error_bars==1
        errorbar(sorted_alv_xvals, sorted_alv_bootstrap_mean_slopes,sorted_alv_bootstrap_std_slopes, 'ko-', 'LineWidth', 7,'MarkerSize',15,'MarkerFaceColor','k');
        hold on;
        errorbar(sorted_ba_xvals, sorted_ba_bootstrap_mean_slopes, sorted_ba_bootstrap_std_slopes,'mo-', 'LineWidth', 7,'MarkerSize',15,'MarkerFaceColor','m');
    
    else
        plot(sorted_alv_xvals, sorted_alv_slope_dynamicrange, 'ko-', 'LineWidth', 7,'MarkerSize',25,'MarkerFaceColor','k');
        hold on;
        plot(sorted_ba_xvals, sorted_ba_slope_dynamicrange, 'mo-', 'LineWidth', 7,'MarkerSize',25,'MarkerFaceColor','m');

    end
    legend('Alvarez','Baron', 'Location', 'Best', 'Interpreter', 'none');
end
if plotting_round==2
    if error_bars==1
        errorbar(sorted_alv_xvals, sorted_alv_bootstrap_mean_slopes,sorted_alv_bootstrap_std_slopes, 'k+:', 'LineWidth', 7,'MarkerSize',15,'MarkerFaceColor','k');
        hold on;
        errorbar(sorted_ba_xvals, sorted_ba_bootstrap_mean_slopes, sorted_ba_bootstrap_std_slopes,'m+:', 'LineWidth', 7,'MarkerSize',15,'MarkerFaceColor','m');
    else
        plot(sorted_alv_xvals, sorted_alv_slope_dynamicrange, 'k+:', 'LineWidth', 7,'MarkerSize',25);
        hold on;
        plot(sorted_ba_xvals, sorted_ba_slope_dynamicrange, 'm+:', 'LineWidth', 7,'MarkerSize',25);
    end
end
% Set plot labels and styling for the first subplot
switch x_axis_condition
    case 'velocity'
        title_text='Effect of Auditory Motion Displacement vs. Duration';
        xlabel('Velocity (degrees/second)');
        legend('Alv Constant Displacement (22°)','Ba Constant Displacement (22°)','Alv Constant Duration (0.834s)','Ba Constant Duration (0.834s)', 'Location', 'Best', 'Interpreter', 'none');
        % if plotting_round==1
        %     save([fig_save_path 'alv_constantdisplacement_velocityxaxis_slopes'],'sorted_alv_xvals','sorted_alv_bootstrap_mean_slopes','sorted_alv_bootstrap_std_slopes');
        %     save([fig_save_path 'ba_constantdisplacement_velocityxaxis_slopes'],'sorted_ba_xvals','sorted_ba_bootstrap_mean_slopes','sorted_ba_bootstrap_std_slopes');
        % 
        % else
        %     save([fig_save_path 'alv_constantduration_velocityxaxis_slopes'],'sorted_alv_xvals','sorted_alv_bootstrap_mean_slopes','sorted_alv_bootstrap_std_slopes');
        %     save([fig_save_path 'ba_constantduration_velocityxaxis_slopes'],'sorted_ba_xvals','sorted_ba_bootstrap_mean_slopes','sorted_ba_bootstrap_std_slopes');
        % 
        % end
    case 'duration'
        title_text='Effect of Auditory Motion Displacement vs. Velocity';
        xlabel('Duration (seconds)');
        legend('Alv Constant Displacement (22°)','Ba Constant Displacement (22°)','Alv Constant Velocity (59.95°/s)','Ba Constant Velocity (59.95°/s)', 'Location', 'Best', 'Interpreter', 'none');
        % if plotting_round==1
        %     save([fig_save_path 'alv_constantdisplacement_durationxaxis_slopes'],'sorted_alv_xvals','sorted_alv_bootstrap_mean_slopes','sorted_alv_bootstrap_std_slopes');
        %     save([fig_save_path 'ba_constantdisplacement_durationxaxis_slopes'],'sorted_ba_xvals','sorted_ba_bootstrap_mean_slopes','sorted_ba_bootstrap_std_slopes');
        % 
        % else
        %     save([fig_save_path 'alv_constantvelocity_durationxaxis_slopes'],'sorted_alv_xvals','sorted_alv_bootstrap_mean_slopes','sorted_alv_bootstrap_std_slopes');
        %     save([fig_save_path 'ba_constantvelocity_durationxaxis_slopes'],'sorted_ba_xvals','sorted_ba_bootstrap_mean_slopes','sorted_ba_bootstrap_std_slopes');
        % 
        % end
    case 'displacement'
        title_text='Effect of Auditory Motion Duration vs. Velocity';
        xlabel('Displacement (degrees)');
        legend('Alv Constant Duration (0.834s)','Ba Constant Duration (0.834s)','Alv Constant Velocity (59.95°/s)','Ba Constant Velocity (59.95°/s)', 'Location', 'Best', 'Interpreter', 'none');
        % if plotting_round==1
        %     save([fig_save_path 'alv_constantduration_displacementxaxis_slopes'],'sorted_alv_xvals','sorted_alv_bootstrap_mean_slopes','sorted_alv_bootstrap_std_slopes');
        %     save([fig_save_path 'ba_constantduration_displacementxaxis_slopes'],'sorted_ba_xvals','sorted_ba_bootstrap_mean_slopes','sorted_ba_bootstrap_std_slopes');
        % else
        %     save([fig_save_path 'alv_constantvelocity_displacementxaxis_slopes'],'sorted_alv_xvals','sorted_alv_bootstrap_mean_slopes','sorted_alv_bootstrap_std_slopes');
        %     save([fig_save_path 'ba_constantvelocity_displacementxaxis_slopes'],'sorted_ba_xvals','sorted_ba_bootstrap_mean_slopes','sorted_ba_bootstrap_std_slopes');
        % 
        % end
end
title(title_text, 'Interpreter', 'none');
if error_bars==1
    ylabel('Sensitivity (Mean Psychometric Function Slope)');
else
    ylabel('Sensitivity (Psychometric Function Slope)');

end
grid on;
ax = gca;
ax.FontSize = 22;
% ylim([0.5 2.6])
% ylim([0.5 3])
%ylim([0.4 3])
ylim([0 3])

%legend('Alvarez','Baron', 'Location', 'Best', 'Interpreter', 'none');

% % Second subplot
% subplot(1, 2, 2); % 1 row, 2 columns, 2nd subplot
% plot(sorted_alv_xvals(2:end), sorted_alv_std_cumgaus_scaled(2:end), 'go-', 'LineWidth', 3);
% hold on;
% plot(sorted_ba_xvals(2:end), sorted_ba_std_cumgaus_scaled(2:end), 'mo-', 'LineWidth', 3);
%
% % Set plot labels and styling for the second subplot
% title('Alv and Ba changes in scaled std vs. velocity 052024', 'Interpreter', 'none');
% xlabel('Velocity (degrees/s)');
% ylabel('std scaled with lapse rates');
% %ylim([0 0.25]);
% grid on;
% ax = gca;
% ax.FontSize = 22;
% legend('Alvarez','Baron', 'Location', 'Best', 'Interpreter', 'none');

poster_quality_figure();
if save_fig==1
    fig=gcf;
    if error_bars==1
         set(findobj('Type', 'line'),'MarkerSize',17)

        saveas(fig, [fig_save_path title_text 'with Error Bars.png']);
        saveas(fig, [fig_save_path title_text 'with Error Bars.fig']);
    else
        saveas(fig, [fig_save_path title_text '.png']);
        saveas(fig, [fig_save_path title_text '.fig']);
    end
end
