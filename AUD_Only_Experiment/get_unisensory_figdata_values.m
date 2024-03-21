function [x_scattervals, y_scattervals, x_curvevals, y_curvevals, mu_per_date, std_gaussian_per_date, slope_per_date, slope_at_50_percent_per_date, date_key] = get_unisensory_figdata_values(Path)
%GET_UNISENSORY_FIGDATA_VALUES Extracts and processes unisensory figure data for visualization.
%
% This function processes data from a specified directory to produce values for
% scatter plots and curve plots based on unisensory trial data, organized by
% unique dates. It computes statistical parameters of the psychometric curves
% for each date, facilitating the analysis of sensory perception accuracy
% across different coherence levels.
%
% Inputs:
%   Path - A string specifying the directory path where the trial data files
%          are located.
%
% Outputs:
%   x_scattervals - Cell array of x-values for scatter plots, each cell for a unique date.
%   y_scattervals - Cell array of y-values for scatter plots, each cell for a unique date.
%   x_curvevals - Cell array of x-values for curve plots, each cell for a unique date.
%   y_curvevals - Cell array of y-values for curve plots, each cell for a unique date.
%   mu_per_date - Array of mean values of the Gaussian fit for each date's psychometric curve.
%   std_gaussian_per_date - Array of standard deviations of the Gaussian fit for each date's curve.
%   slope_per_date - Array of slopes for the psychometric curve at each date.
%   slope_at_50_percent_per_date - Array of slopes at the 50% threshold for each date's curve.
%   date_key - Cell array of strings, with each string being a unique date extracted from the filenames.

% Retrieve and organize file information based on unique dates
[~, totalfiles_names] = get_datafile_info(Path);
unique_dates_totalfiles_names = groupFilesByDate(totalfiles_names);
master_dataout = combineDataByUniqueDates(Path, unique_dates_totalfiles_names);
[date_key, ~] = get_unique_dates(unique_dates_totalfiles_names);
n_unique_dates = length(master_dataout(1,:));

% Analyze data for each unique date
for i_date = 1:n_unique_dates
    save_name = cellfun(@(x) x(1:10), unique_dates_totalfiles_names(i_date, 1), 'UniformOutput', false);
    save_name = save_name{1};
    dataout = master_dataout{i_date};

    % Extract trial information and calculate probabilities
    audInfo = process_trial_information(dataout);
    
    % Split and analyze data by trial direction
    [prob_Right, prob_Left, audInfo] = analyze_directional_data(dataout,audInfo);
    
    % Plot psychometric curves and extract statistical parameters
    [mu, std_gaussian, slope, slope_at_50_percent, LR_xdata, LR_ydata, LR_curve_xvals, LR_curve_yvals] = plot_and_analyze_psychometric_curve(prob_Right, prob_Left, audInfo, save_name);

    % Store results for the current date
    store_plot_values(i_date, LR_xdata, LR_ydata, LR_curve_xvals, LR_curve_yvals, mu, std_gaussian, slope, slope_at_50_percent);
end

    function audInfo = process_trial_information(dataout)
        audInfo.coherences = unique(cell2mat(dataout(2:end,8)))';
        [audInfo.cohFreq] = cohFreq_finder(dataout, audInfo);
    end

    function [prob_Right, prob_Left, audInfo] = analyze_directional_data(dataout,audInfo)
        [Right_dataout, Left_dataout] = direction_splitter(dataout);
        audInfo.cohFreq_right = cohFreq_finder(Right_dataout, audInfo);
        audInfo.cohFreq_left = cohFreq_finder(Left_dataout, audInfo);
        prob_Right = directional_probability(Right_dataout, audInfo);
        prob_Left = directional_probability(Left_dataout, audInfo);
    end

    function [mu, std_gaussian, slope, slope_at_50_percent, LR_xdata, LR_ydata, LR_curve_xvals, LR_curve_yvals] = plot_and_analyze_psychometric_curve(prob_Right, prob_Left, audInfo, save_name)
        [~, ~, ~, mu, std_gaussian, LR_xdata, LR_ydata, LR_curve_xvals, LR_curve_yvals] = psychometric_plotter(prob_Right, prob_Left, audInfo, save_name, 'red');
        slope_at_50_percent = 1 / (std_gaussian * sqrt(2 * pi));
        dy_dx = diff(LR_curve_yvals) ./ diff(LR_curve_xvals);
        slope = mean(dy_dx(~isnan(dy_dx))); % Exclude NaN values that may result from division by zero
    end

    function store_plot_values(i_date, LR_xdata, LR_ydata, LR_curve_xvals, LR_curve_yvals, mu, std_gaussian, slope, slope_at_50_percent)
        x_scattervals{i_date} = LR_xdata;
        y_scattervals{i_date} = LR_ydata;
        x_curvevals{i_date} = LR_curve_xvals';
        y_curvevals{i_date} = LR_curve_yvals';
        mu_per_date(i_date) = mu;
        std_gaussian_per_date(i_date) = std_gaussian;
        slope_per_date(i_date) = slope;
        slope_at_50_percent_per_date(i_date) = slope_at_50_percent;
    end
end
