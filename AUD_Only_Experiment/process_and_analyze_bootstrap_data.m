function [data_included, data_leftout, prob_Right, prob_Left, audInfo, slope_dynamicrange, LR_xdata, LR_ydata, LR_curve_xvals, LR_curve_yvals] = process_and_analyze_bootstrap_data(dataout, n_rows_included, save_name)
    % PROCESS_AND_ANALYZE_BOOTSTRAP_DATA Processes and analyzes a single permutations trial data for bootstrapping procedure.
    %
    % This function takes in a dataset, randomly splits it into two subsets,
    % processes the included data to extract coherence information, analyzes
    % the data by trial direction, and plots psychometric curves.
    %
    % Inputs:
    %   dataout - A matrix containing the data to be processed and analyzed.
    %   n_rows_included - The number of rows to include in the first subset.
    %   save_name - A string specifying the name to be used for saving plots.
    %
    % Outputs:
    %   data_included - The subset of data included for analysis (90% of total).
    %   data_leftout - The subset of data left out from analysis (10% of total).
    %   prob_Right - The probability of right trials.
    %   prob_Left - The probability of left trials.
    %   audInfo - The processed trial information.
    %   slope_dynamicrange - The slope of the dynamic range from the psychometric plot.
    %   LR_xdata - The x-data for the left-right psychometric curve.
    %   LR_ydata - The y-data for the left-right psychometric curve.
    %   LR_curve_xvals - The x-values of the psychometric curve.
    %   LR_curve_yvals - The y-values of the psychometric curve.

    % Generate a random permutation of row indices
    rand_indices = randperm(size(dataout, 1));
    
    % Select 90% of the rows for the first array
    data_included = dataout(rand_indices(1:n_rows_included), :);
    
    % Select the remaining 10% of the rows
    data_leftout = dataout(rand_indices(n_rows_included + 1:end), :);
    
    % Extract coherence information and calculate probabilities
    audInfo = process_trial_information(data_included);
    
    % Split and analyze data by trial direction
    [prob_Right, prob_Left, audInfo] = analyze_directional_data(data_included, audInfo);
    
    % Plot psychometric curves and extract statistical parameters
    [~, ~, ~, slope_dynamicrange, ~, LR_xdata, LR_ydata, LR_curve_xvals, LR_curve_yvals] = psychometric_plotter(dataout, prob_Right, prob_Left, audInfo, save_name, 'red');

    %% local functions
function audInfo = process_trial_information(dataout)
    audInfo.coherences = unique(cell2mat(dataout(:,8)))';
    [audInfo.cohFreq] = cohFreq_finder(dataout, audInfo);
end

function [prob_Right, prob_Left, audInfo] = analyze_directional_data(dataout,audInfo)
    [Right_dataout, Left_dataout] = direction_splitter(dataout);
    audInfo.cohFreq_right = cohFreq_finder(Right_dataout, audInfo);
    audInfo.cohFreq_left = cohFreq_finder(Left_dataout, audInfo);
    prob_Right = directional_probability(Right_dataout, audInfo);
    prob_Left = directional_probability(Left_dataout, audInfo);
end
end
