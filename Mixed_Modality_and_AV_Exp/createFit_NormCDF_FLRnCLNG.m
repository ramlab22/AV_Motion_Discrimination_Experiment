function [fig, mu, std_gaussian, xData, yData, curve_xvals, curve_yvals] = createFit_NormCDF_FLRnCLNG(coh_list, probability_rightward_response, audInfo, save_name, fig_color)
    % CREATEFIT_NORMCDF_FLRnCLNG creates a psychometric function fit for given data.
    % This function accounts for floor and ceiling effects in the data, which are not
    % typically considered in a standard Gaussian distribution. The model utilizes
    % the Error Function (ERF) for curve fitting and exhibits Weibull-like behavior.
    % However, the parameters of the curve (threshold and slope) may not directly
    % correspond to the mean and standard deviation of a Gaussian distribution.
    %
    % Inputs:
    %   coh_list  - List of coherences.
    %   probability_rightward_response - Proportion rightward responses for each coherence.
    %   audInfo   - Auditory information structure.
    %   save_name - Name of the file for saving the figure and data.
    %   fig_color - Color of the figure ('blue' or 'red') red typically for auditory, blue typically for visual.
    %
    % Outputs:
    %   fig           - Handle to the created figure.
    %   mu            - Estimated mean of the distribution.
    %   std_gaussian  - Estimated standard deviation of the Gaussian.
    %   xData         - X-axis data used for curve fitting.
    %   yData         - Y-axis data used for curve fitting.
    %   curve_xvals   - X-values for the fitted curve.
    %   curve_yvals   - Y-values for the fitted curve.
    %
    % Example:
    %   [fig, mu, std_gaussian, xData, yData, curve_xvals, curve_yvals] = 
    %       createFit_NormCDF_FLRnCLNG(coh_list, pc, audInfo, 'myFigure', 'blue');
    
    % Determine figure modality based on color
    switch fig_color
        case 'blue'
            fig_modality = 'Visual';
        case 'red'
            fig_modality = 'Auditory';
    end

    % Prepare data for curve fitting
    [xData, yData] = prepareCurveData(coh_list, probability_rightward_response);

    % Initialize parameters for fitting
    mu = mean(yData);
    sigma = std(yData);
    floor_value = min(yData);
    ceiling_value = max(yData);
    parms = [mu, sigma, floor_value, ceiling_value];

    % Define modified normal CDF function with floor and ceiling
    normalcdf_fun_mod = @(b, x) b(3) + (b(4) - b(3)) * (1 + erf((x - b(1)) ./ (b(2) * sqrt(2)))) / 2;

    % Optimization settings
    opts = optimset('MaxFunEvals', 50000, 'MaxIter', 10000);
    lb = [-Inf, -Inf, min(yData), -Inf];  % Lower bounds for parameters
    ub = [Inf, Inf, max(yData), Inf];     % Upper bounds for parameters

    % Fit the model with bounds
    mdl = lsqcurvefit(@(b, x) normalcdf_fun_mod(b, x), parms, xData, yData, lb, ub, opts);

    % Generate values for plotting the fitted curve
    curve_xvals = min(xData(:)):.01:max(xData(:));
    curve_yvals = normalcdf_fun_mod(mdl, curve_xvals);

    % Extract and calculate relevant statistics
    mu = mdl(1);  % Mean of the distribution
    std_gaussian = mdl(2);  % Standard deviation of the Gaussian
    dy_dx = diff(curve_yvals) ./ diff(curve_xvals);  % Slope of the CDF curve
    slope = mean(dy_dx);  % Average slope
    slope_at_50_percent = 1 / (std_gaussian * sqrt(2 * pi));  % Slope at 50% response

    % Process trial frequencies for each coherence
    sizes_L = flip(audInfo.cohFreq_left(2,:)');  % Frequencies for left responses
    sizes_R = audInfo.cohFreq_right(2,:)';       % Frequencies for right responses
    all_sizes = nonzeros(vertcat(sizes_L, sizes_R));

    % Adjust size array to match the length of xData
    if length(xData) ~= length(all_sizes)
        all_sizes = all_sizes(1:length(xData));
    end

    % Plotting the fit and data
    fig = figure('Name', 'Psychometric Function');
    scatter(xData, yData, all_sizes, fig_color, 'LineWidth', 2);
    hold on;
    plot(curve_xvals, curve_yvals, fig_color, 'LineWidth', 2.5);
    
    % Set plot labels and styling
    title(sprintf('%s Psych. Func. L&R\n%s', fig_modality, save_name), 'Interpreter', 'none');
    xlabel('Coherence ((+)Rightward, (-)Leftward)', 'Interpreter', 'none');
    ylabel('Proportion Rightward Response', 'Interpreter', 'none');
    xlim([-max(xData(:)) max(xData(:))]);
    ylim([0 1]);
    grid on;
    ax = gca; 
    ax.FontSize = 22;

    % Displaying additional information on the plot
    text(0, .15, "mu: " + mu, 'FontSize', 22);
    text(0, .1, "std cummulative gaussian: " + std_gaussian, 'FontSize', 22);
    text(0, .2, "slope at 50 percent: " + slope_at_50_percent, 'FontSize', 22);
    text(0, .25, "overall slope: " + slope, 'FontSize', 22);
    text(0, .3, "n_trials: " + sum(all_sizes), 'FontSize', 22, 'Interpreter', 'none');

    % Add legend to the plot
    legend('% Rightward Resp. vs. Coherence', 'NormCDF', 'Location', 'NorthWest', 'Interpreter', 'none');

    % Save figure and data
    save(save_name, 'save_name', 'xData', 'yData', 'mdl');
end
