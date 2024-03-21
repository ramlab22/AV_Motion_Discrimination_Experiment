function [x_scatter, y_scatter, fig, mu, std_gaussian, xData, yData, curve_xvals, curve_yvals] = psychometric_plotter(prob_Right, prob_Left, audInfo, save_name, fig_color)
    % PSYCHOMETRIC_PLOTTER creates a psychometric plot based on probabilities of right and left choices.
    % This function processes the probabilities for rightward and leftward choices and uses them
    % to generate a psychometric plot. It adapts the probabilities to reflect the probability of a 
    % rightward choice, considering that the input probabilities indicate the likelihood of a correct
    % choice in either direction. The function then calls createFit_NormCDF_FLRnCLNG to fit a psychometric
    % function to these probabilities.
    %
    % Inputs:
    %   prob_Right - Nx2 matrix, where column 1 is coherence levels and column 2 is the probability of
    %                a rightward choice being correct.
    %   prob_Left  - Nx2 matrix, similar to prob_Right but for leftward choices.
    %   audInfo    - Auditory information structure, passed to the fitting function.
    %   save_name  - Name of the file for saving the figure and data.
    %   fig_color  - Color of the figure ('blue' or 'red'), indicating auditory or visual modality.
    %
    % Outputs:
    %   x, y                   - Combined and processed coherence levels and probabilities.
    %   fig                    - Handle to the created figure.
    %   mu                     - Estimated mean of the distribution.
    %   std_gaussian           - Estimated standard deviation of the Gaussian.
    %   xData, yData           - Data used for curve fitting.
    %   curve_xvals, curve_yvals - Values for the fitted psychometric curve.
    %
    % Example:
    %   [x, y, fig, mu, std_gaussian, xData, yData, curve_xvals, curve_yvals] =
    %       psychometric_plotter(prob_Right, prob_Left, audInfo, 'myFigure', 'blue');

    % Process rightward choice probabilities
    xR = prob_Right(:,1)'; 
    xL = flip(-1 * (prob_Left(:,1)))'; % Reflect leftward choices on the negative x-axis
    x_scatter = cat(2, xL, xR); 
    yL = flip(prob_Left(:,2))'; % Probabilities for leftward choices
    yR = prob_Right(:,2)'; % Probabilities for rightward choices
    y_scatter = cat(2, yL, yR);  

    % Combine and clean data for scatter plot
    scatter_plot_data = [x_scatter; y_scatter]'; 
    scatter_plot_data = scatter_plot_data(~isnan(scatter_plot_data(:,2)),:); 

    % Call createFit_NormCDF_FLRnCLNG to fit a psychometric function
    [fig, mu, std_gaussian, xData, yData, curve_xvals, curve_yvals] = createFit_NormCDF_FLRnCLNG(scatter_plot_data(:,1), scatter_plot_data(:,2)/100, audInfo, save_name, fig_color); 
end
