function compare_ridge_modelvsdata_slopes(condition_table, include_interactions, Mdl)
    % compare_ridge_modelvsdata_slopes - Generate predicted slopes from ridge regression model
    % and compare them to actual data
    %
    % Syntax: compare_slopes_ridge(condition_table, include_interactions, Mdl)
    %
    % Inputs:
    %    condition_table - A table containing the original data including predictors and actual slopes
    %    include_interactions - Boolean flag to include two-way interactions in the model
    %    Mdl - Ridge regression model trained using fitrlinear
    %
    % Outputs:
    %    None (displays a plot comparing actual vs. predicted slopes)
    %
    % Example:
    %    compare_slopes_ridge(condition_table, true, Mdl);

    % Remove rows where displacement is 8
    condition_table(condition_table.displacement == 8, :) = [];

    % Extract the variables from the table
    velocity = condition_table.velocity;
    duration = condition_table.duration;
    displacement = condition_table.displacement;

    % Create the design matrix X for the predictors
    X = [velocity, duration, displacement];
    
    % Include interaction terms if specified
    if include_interactions
        interactions = [velocity.*duration, velocity.*displacement, duration.*displacement];
        X = [X, interactions];
    end

    % Standardize the predictors using the same mean and std as used in training
    X = (X - mean(X)) ./ std(X);

    % Generate predicted slopes based on the ridge regression model
    predicted_slopes = predict(Mdl, X);

    % Extract actual slopes from the condition table
    actual_slopes = condition_table.slope;

    % Plot actual vs. predicted slopes
    figure;
    scatter(actual_slopes, predicted_slopes, 'filled');
    xlabel('Actual Slopes');
    ylabel('Predicted Slopes');
    title('Comparison of Actual vs. Predicted Slopes (Ridge Regression)');
    grid on;

    % Add a line y = x for reference
    hold on;
    plot([min(actual_slopes), max(actual_slopes)], [min(actual_slopes), max(actual_slopes)], 'r--');
    hold off;

    % Display the correlation coefficient
    corr_coef = corr(actual_slopes, predicted_slopes);
    fprintf('Correlation between actual and predicted slopes: %f\n', corr_coef);
end
