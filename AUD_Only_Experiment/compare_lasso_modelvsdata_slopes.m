function compare_lasso_modelvsdata_slopes(condition_table, include_vars, B, FitInfo)
    % compare_lasso_modelvsdata_slopes - Generate predicted slopes from LASSO model and compare them to actual data
    %
    % Syntax: compare_slopes(condition_table, include_vars, B, FitInfo)
    %
    % Inputs:
    %    condition_table - A table containing the original data including predictors and actual slopes
    %    include_vars - A cell array of strings specifying which variables were included as predictors
    %    B - The matrix of coefficients from the LASSO model
    %    FitInfo - Structure containing information about the fit, including the optimal lambda
    %
    % Outputs:
    %    None (displays a plot comparing actual vs. predicted slopes)
    %
    % Example:
    %    compare_slopes(condition_table, {'velocity', 'duration', 'displacement'}, B, FitInfo);

    % Extract the coefficients for the optimal lambda
    optimal_coeffs = B(:, FitInfo.IndexMinMSE);

    % Extract and standardize the selected predictor variables
    X = [];
    for var = include_vars
        X = [X, condition_table.(var{1})];
    end
    [X, ~, ~] = zscore(X); % Standardize the predictors

    % Generate predicted slopes based on the LASSO model
    predicted_slopes = X * optimal_coeffs;

    % Extract actual slopes from the condition table
    actual_slopes = condition_table.slope;

    % Plot actual vs. predicted slopes
    figure;
    scatter(actual_slopes, predicted_slopes, 'filled');
    xlabel('Actual Slopes');
    ylabel('Predicted Slopes');
    title('Comparison of Actual vs. Predicted Slopes');
    grid on;

    % Add a line y = x for reference
    hold on;
    plot([min(actual_slopes), max(actual_slopes)], [min(actual_slopes), max(actual_slopes)], 'r--');
    hold off;

    % Display the correlation coefficient
    corr_coef = corr(actual_slopes, predicted_slopes);
    fprintf('Correlation between actual and predicted slopes: %f\n', corr_coef);
end
