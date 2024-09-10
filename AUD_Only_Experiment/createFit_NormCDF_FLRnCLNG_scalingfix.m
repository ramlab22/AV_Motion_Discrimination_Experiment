function [fig, slope_dynamicrange, std_gaussian_scaled, xData, yData, curve_xvals, curve_yvals] = createFit_NormCDF_FLRnCLNG_scalingfix(dataout,coh_list, probability_rightward_response, audInfo, save_name, fig_color)
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
    % Process trial frequencies for each coherence
    sizes_L = flip(audInfo.cohFreq_left(2,:)');  % Frequencies for left responses
    sizes_R = audInfo.cohFreq_right(2,:)';       % Frequencies for right responses
    all_sizes = nonzeros(vertcat(sizes_L, sizes_R));

    % when this function is run on data combined across multiple days (therefore more than 250 trials 
    % per coherence) remove coherences and corresponding data with insufficient data quantity to be 
    % worth including
   if any(all_sizes > 250)
        sufficient_quantity_data_idx=find(all_sizes > 50);
        all_sizes=all_sizes(sufficient_quantity_data_idx,1);
        xData=xData(sufficient_quantity_data_idx,1);
        yData=yData(sufficient_quantity_data_idx,1);
        coh_list=coh_list(sufficient_quantity_data_idx,1);
    end
    % get actual prob right resp for 0% coherence trials and replace with that value
    % for both "leftward" and "rightward" 0% coherence
    if any(coh_list == 0)
        [prop_Rresp_zerocoh] = propRresp_catchtrials(dataout, audInfo) ;
        catch_idx=find(xData==0);
        
        prop_Rresp_zerocoh_array = prop_Rresp_zerocoh/100 * ones(size(catch_idx));
        yData(catch_idx,1)=prop_Rresp_zerocoh_array;

        dotsize_zerocoh_array =  sum(all_sizes(catch_idx)) * ones(size(catch_idx));
        all_sizes(catch_idx,1)=dotsize_zerocoh_array;
    end
% % Define the values to catch
% extreme_vals = [0.707, 1, -0.707, -1];    
% % Define a tolerance for floating-point comparison
% tolerance = 1e-6;
% % Find the indices of xData that are not in extreme_vals using tolerance
% extreme_vals_idx = find(~ismembertol(xData, extreme_vals, tolerance));
% % Check if any values in xData are not in extreme_vals
% if ~isempty(extreme_vals_idx)
%     all_sizes = all_sizes(extreme_vals_idx, 1);
%     xData = xData(extreme_vals_idx, 1);
%     yData = yData(extreme_vals_idx, 1);
%     coh_list = coh_list(extreme_vals_idx, 1);
% end

% Initialize parameters for fitting
mu = mean(xData); % Use mean of xData for the initial guess of mu
sigma = std(xData); % Use standard deviation of xData for initial guess of sigma
floor_value = min(yData);
ceiling_value = max(yData);
parms = [mu, sigma, floor_value, ceiling_value];

% Define modified normal CDF function with floor and ceiling
% b(1) = mu, b(2) = sigma, b(3) = floor_value, b(4) = ceiling_value
modified_cdf = @(b, x) b(3) + (b(4) - b(3)) * (1 + erf((x - b(1)) / (b(2) * sqrt(2)))) / 2;

% Optimization settings
opts = optimset('MaxFunEvals', 50000, 'MaxIter', 10000);
%lb = [-Inf, 0, floor_value, -Inf]; % Ensure non-negative sigma
%ub = [Inf, Inf, ceiling_value, Inf];
lb = [-Inf, 0, 0, 0]; % lb = [mu_lower, sigma_lower, floor_value_lower, ceiling_value_lower]
ub = [Inf, Inf, 1, 1]; % ub = [mu_upper, sigma_upper, floor_value_upper, ceiling_value_upper]

% Fit the model with bounds
mdl = lsqcurvefit(@(b, x) modified_cdf(b, x), parms, xData, yData, lb, ub, opts);

% Generate values for plotting the fitted curve
curve_xvals = min(xData(:)):.01:max(xData(:));
curve_yvals = modified_cdf(mdl, curve_xvals);

% Calculate the slope of the dynamic range
[slope_dynamicrange,std_gaussian_scaled,coherence_low,coherence_high] = calculate_slope_dynamic_range(mdl);

%fprintf('Slope of the dynamic range: %.4f\n', slope_dynamicrange);
%fprintf('scaled sigma: %.4f\n', std_gaussian_scaled);


    % Extract and calculate relevant statistics
    mu = mdl(1);  % Mean of the distribution
    std_gaussian = mdl(2);  % Standard deviation of the Gaussian
    dy_dx = diff(curve_yvals) ./ diff(curve_xvals);  % Slope of the CDF curve
    overall_slope = mean(dy_dx);  % Average  overall slope. ignore, not informative bc of dynamic range
    slope_at_50_percent = 1 / (std_gaussian * sqrt(2 * pi));  % Slope at 50% response

    % Plotting the fit and data
    fig = figure('Name', 'Psychometric Function');
    
    scatter(xData, yData,all_sizes, fig_color, 'LineWidth', 2);

    hold on;
    plot(curve_xvals, curve_yvals, fig_color, 'LineWidth', 2.5);
    
    % Set plot labels and styling
    title(sprintf('%s Psych. Func. L&R\n%s', fig_modality, save_name), 'Interpreter', 'none');
    xlabel('Coherence ((+)Rightward, (-)Leftward)', 'Interpreter', 'none');
    ylabel('Proportion Rightward Response', 'Interpreter', 'none');
    xlim([-max(xData(:)) max(xData(:))]);
    ylim([0 1.2]);
    grid on;
    ax = gca; 
    ax.FontSize = 22;

    % Displaying additional information on the plot
    text(0, .15, "mu: " + mu, 'FontSize', 22);
 %   text(0, .1, "scaled sigma: " + sprintf('%.3f', std_gaussian_scaled), 'FontSize', 22);

  %  text(0, .1, "std cummulative gaussian: " + sprintf('%.3f', std_gaussian), 'FontSize', 22);
 %   text(0, .2, "slope at 50 percent: " + sprintf('%.3f', slope_at_50_percent), 'FontSize', 22);
    text(0, .2, "slope of dynamic range: " + sprintf('%.3f', slope_dynamicrange), 'FontSize', 22);
    if any(coh_list == 0)
        text(-max(xData), .65, "catch trial prop. R resp: "+ sprintf('%.3f', prop_Rresp_zerocoh) ,'FontSize', 15);
        text(0, .05, "n_trials: " + (sum(all_sizes)-all_sizes(catch_idx(1))), 'FontSize', 22, 'Interpreter', 'none');
    else
        text(0, .05, "n_trials: " + sum(all_sizes), 'FontSize', 22, 'Interpreter', 'none');
        
    end
    % Add dynamic range markers to the plot
    if ~isnan(slope_dynamicrange)
        plot([coherence_low,coherence_low],[min(curve_yvals),max(curve_yvals)],'m:','LineWidth',2);
        plot([coherence_high,coherence_high],[min(curve_yvals),max(curve_yvals)],'m:','LineWidth', 2,'HandleVisibility', 'off');
        legend('% Rightward Resp. vs. Coherence', 'NormCDF', 'Dynamic Range',...
        'Location', 'NorthWest', 'Interpreter', 'none');
    else
        legend('% Rightward Resp. vs. Coherence', 'NormCDF',...
        'Location', 'NorthWest', 'Interpreter', 'none');
    end
   
    % Save figure and data
%    save(save_name, 'save_name', 'xData', 'yData', 'mdl');
end
