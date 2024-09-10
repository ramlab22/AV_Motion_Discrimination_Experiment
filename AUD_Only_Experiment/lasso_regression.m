function lasso_regression(condition_table, include_vars)
    % lasso_regression - Perform LASSO regression on the given data table with flexible variable inclusion.
    %
    % Syntax: lasso_regression(condition_table, include_vars)
    %
    % Inputs:
    %    condition_table - A table containing the following columns:
    %                      - slope: The response variable
    %                      - velocity: The predictor variable representing velocity
    %                      - duration: The predictor variable representing duration
    %                      - displacement: The predictor variable representing displacement
    %                      - subjectID: The subject identifier (categorical)
    %    include_vars - A cell array of strings specifying which variables to include as predictors.
    %                   Possible values are 'velocity', 'duration', 'displacement'.
    %
    % Outputs:
    %    Displays the optimal Lambda value, the coefficients for each Lambda,
    %    the non-zero coefficients for the best Lambda, and plots the LASSO paths.
    %
    % Example: 
    %    lasso_regression(condition_table, {'velocity', 'duration','displacement'});
    %
    % Other m-files required: None
    % Subfunctions: None
    % MAT-files required: None
    %
    % See also: lasso, lassoPlot

    % Validate input variables
    valid_vars = {'velocity', 'duration', 'displacement'};
    if ~iscell(include_vars) || any(~ismember(include_vars, valid_vars))
        error('include_vars must be a cell array containing any combination of ''velocity'', ''duration'', ''displacement''.');
    end

    % Extract and standardize selected predictor variables
    X = [];
    for var = include_vars
        X = [X, condition_table.(var{1})];
    end
    [X, mu, sigma] = zscore(X);
    
    % Extract response variable
    y = condition_table.slope;

    % get unique subject names for figure titles later (before convert to
    % numerical)
    if any(condition_table.subjectID ~= condition_table.subjectID(1))
        subject_for_title="Alv and Ba";
    else
        subject_for_title=unique(condition_table.subjectID);
    end
    fprintf('Subject(s): %s\n', subject_for_title);
    % Convert subjectID to numerical values for grouping (not used in LASSO but for consistency)
    [~, ~, condition_table.subjectID] = unique(condition_table.subjectID);

    % Fit LASSO regression
    [B, FitInfo] = lasso(X, y, 'CV', 10);

    % Display results
    fprintf('Optimal Lambda: %f\n', FitInfo.LambdaMinMSE);
    % disp('Coefficients for each Lambda:');
    % disp(B);
     % Non-zero coefficients for the best Lambda
    non_zero_coeffs = B(:, FitInfo.IndexMinMSE);
    disp('Non-zero coefficients for the best Lambda:');
    for i = 1:length(include_vars)
        if non_zero_coeffs(i) ~= 0
            fprintf('%s: %f\n', include_vars{i}, non_zero_coeffs(i));
        end
    end

    % Plot the LASSO paths
    figure;
    lassoPlot(B, FitInfo, 'PlotType', 'CV');
    % Enhance line visibility and add legend
    ax = gca;
    lines = ax.Children;
    for i = 1:length(lines)
        lines(i).LineWidth = 1.5;
    end
    legend(include_vars, 'Location', 'Best');
    xlabel('Log Lambda');
    ylabel('Coefficients');
    title(subject_for_title,'LASSO Path Plot');

    % Plot the logarithmic transformation of lambda vs coefficient magnitudes
    figure;
    plot(log(FitInfo.Lambda), abs(B), 'LineWidth', 1.5);
    legend(include_vars, 'Location', 'Best');
    xlabel('Log Lambda');
    ylabel('Coefficient Magnitudes');
    title(subject_for_title,'Log Lambda vs Coefficient Magnitudes');
    grid on;

    % Cross-validate predictors
    evaluate_predictors(condition_table, include_vars);
    compare_lasso_modelvsdata_slopes(condition_table, include_vars, B, FitInfo);
    %% crossvalidate predictors
    function evaluate_predictors(condition_table, include_vars)
        % cross-validation to evaluate the significance of each
        % predictor by comparing the cross-validated MSE (mean squared error) of 
        % models with and without each predictor. 
        predictors = include_vars;
        y = condition_table.slope;

        % Define a function to fit LASSO and return cross-validated MSE
        function mse = fit_lasso(X, y)
            [~, FitInfo] = lasso(X, y, 'CV', 10);
            mse = FitInfo.MSE(FitInfo.IndexMinMSE);
        end

        % Full model with all predictors
        X_full = [condition_table.velocity, condition_table.duration, condition_table.displacement];
        mse_full = fit_lasso(X_full, y);
        fprintf('Full model MSE: %f\n', mse_full);

        % Models with each predictor excluded one by one
        for i = 1:length(predictors)
            X_subset = X_full;
            X_subset(:, i) = [];
            mse_subset = fit_lasso(X_subset, y);
            fprintf('Model without %s MSE: %f\n', predictors{i}, mse_subset);
        end
    end
end
