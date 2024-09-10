function [std_gaussian_scaled, slope_at_50_percent_scaled, fig_both, slope_dynamicrange,save_name] = analyze_combined_auditory_blocks(Path,data_save_path)
    [~, save_name] = deduce_analysis_save_info(Path);
    % Retrieve data from the auditory blocks
try
    n_permutations=100;
    data_proportion_to_include=0.9;
    [bootstrap_slopes,bootstrap_slope_sd, bootstrap_slope_mean,bootstrap_slope_SE,bootstrap_slope_median,save_name]=BootstrapUnisensorySlopeStats(Path,n_permutations,data_proportion_to_include);
     [x_scattervals, y_scattervals, x_curvevals, y_curvevals, std_gaussian_per_date, slope_per_date, slope_at_50_percent_per_date, date_key,master_dataout] = get_unisensory_figdata_values(Path);
    % [slope_variability_SE, std_gaussian_variability_SE, slope_at_50_percent_variability_SE, slope_sd, std_gaussian_sd, slope_at_50_percent_sd] = jackknifeTaskPerformance(slope_per_date, std_gaussian_per_date, slope_at_50_percent_per_date);
 catch
    bootstrap_slopes='NaN';
    bootstrap_slope_sd='NaN';
    bootstrap_slope_mean='NaN';
    bootstrap_slope_SE='NaN';
% 
% 
 end
    % Combine the data across the blocks
    [dataout, c, totalfiles_names] = combine_data_acrossblocks(Path);

    % Set parameters for further processing
    desired_n_trials_per_coh = 400;
    % dataout = filter_trials_by_number(desired_n_trials_per_coh, dataout);

    % Initialize auditory information
    audInfo.coherences = unique(cell2mat(dataout(2:end, 8)))';
    [audInfo.cohFreq] = cohFreq_finder(dataout, audInfo);

    total_trials = size(dataout, 1) - 1;
    num_regular_trials = total_trials;
    num_catch_trials = 0; % No catch trials included

    % Calculate success rates
    prob = coherence_probability(dataout, audInfo);

    % Split data by direction
    [Right_dataout, Left_dataout] = direction_splitter(dataout);
    audInfo.cohFreq_right = cohFreq_finder(Right_dataout, audInfo);
    audInfo.cohFreq_left = cohFreq_finder(Left_dataout, audInfo);
    prob_Right = directional_probability(Right_dataout, audInfo);
    prob_Left = directional_probability(Left_dataout, audInfo);

    % Plot psychometric function
    [x_scatter, y_scatter, fig_both, slope_dynamicrange, std_gaussian_scaled,xData, yData, curve_xvals, curve_yvals] = psychometric_plotter(dataout, prob_Right, prob_Left, audInfo, save_name, 'red');
    ax = gca;
    hold on

    % % Compute slope at 50%
     slope_at_50_percent_scaled = 1 / (std_gaussian_scaled * sqrt(2 * pi));
    % dy_dx = diff(LR_curve_yvals) ./ diff(LR_curve_xvals);
    % overall_slope = mean(dy_dx);

    % Save data and figures
    save(fullfile(data_save_path, [save_name, '.mat']))
    resizeFigures()
    saveas(fig_both, fullfile(Path, [save_name, '.png']))
    saveas(fig_both, fullfile(Path, [save_name, '.fig']))
    % save(fullfile(data_save_path, [save_name, '_may24.mat']))
    % resizeFigures()
    % saveas(fig_both, fullfile(Path, [save_name, '_may24.png']))
    % saveas(fig_both, fullfile(Path, [save_name, '_may24.fig']))
    % save_name=[save_name,'_may24'];
    % Return outputs
   
  % std_gaussian_variability_SE
  % slope_at_50_percent_variability_SE
  % slope_variability_SE
end
