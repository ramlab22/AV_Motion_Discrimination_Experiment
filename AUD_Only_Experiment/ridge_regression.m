function ridge_regression(condition_table, include_interactions)
    % RIDGE_REGRESSION Performs ridge regression on the given data table.
    %
    % This function standardizes the predictors and the response variable, 
    % performs ridge regression over a range of lambda values, displays 
    % the coefficients, and plots the regularization path.
    %
    % Usage:
    %    ridge_regression(condition_table, include_interactions)
    %
    % Inputs:
    %    condition_table - A table containing the following columns:
    %        slope       - Dependent variable
    %        velocity    - Predictor variable
    %        duration    - Predictor variable
    %        displacement- Predictor variable
    %        subjectID   - Subject identifier (not used in regression)
    %        slope_std   - Standard deviation of the slope (not used in regression)
    %    include_interactions - Boolean flag to include two-way interactions in the model
    %
    % Outputs:
    %    Displays the ridge regression coefficients and intercept, 
    %    and plots the regularization path of coefficients as a function of lambda.
    %
    % Example:
    %    condition_table = table([1.2535; 1.1632; 1.2857; ...], ...
    %                            [9.59; 26.38; 43; ...], ...
    %                            [0.834; 0.834; 0.834; ...], ...
    %                            [8; 22; 36; ...], ...
    %                            {'ba'; 'ba'; 'ba'; ...}, ...
    %                            [0.1108; 0.0471; 0.0209; ...], ...
    %                            'VariableNames', {'slope', 'velocity', 'duration', 'displacement', 'subjectID', 'slope_std'});
    %    ridge_regression(condition_table, true);
    %
    % Author: Your Name
    % Date: July 2024

    % Remove rows where displacement is 8
    condition_table(condition_table.displacement == 8, :) = [];

    % Extract the variables from the table
    slope = condition_table.slope;
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

    % Standardize the predictors
    X = (X - mean(X)) ./ std(X);

    % Standardize the response variable
    y = (slope - mean(slope)) ./ std(slope);

    % Define a range of lambda values for ridge regression
    lambda = 0:0.1:10;

    % Run ridge regression using the fitrlinear function with the ridge option
    Mdl = fitrlinear(X, y, 'Learner', 'leastsquares', 'Regularization', 'ridge', 'Lambda', lambda, 'FitBias', true);

    % % Display the results
    % disp('Ridge Regression Coefficients:');
    % disp(Mdl.Beta);
    % disp('Ridge Regression Intercept:');
    % disp(Mdl.Bias);

    % Plot the regularization path
    figure;
    plot(lambda, Mdl.Beta, 'LineWidth', 2);
    xlabel('Lambda');
    ylabel('Coefficients');
    title('Ridge Regression Coefficients as a Function of Lambda');
    if include_interactions
        legend({'Velocity', 'Duration', 'Displacement', 'Velocity*Duration', 'Velocity*Displacement', 'Duration*Displacement'}, 'Location', 'best');
    else
        legend({'Velocity', 'Duration', 'Displacement'}, 'Location', 'best');
    end
    grid on;

    bar_plot_optimal_lambda(condition_table, include_interactions);
    compare_ridge_modelvsdata_slopes(condition_table, include_interactions, Mdl);
    function bar_plot_optimal_lambda(condition_table, include_interactions)
        % Remove rows where displacement is 8
        condition_table(condition_table.displacement == 8, :) = [];

        % Extract the variables from the table
        slope = condition_table.slope;
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

        % Standardize the predictors
        X = (X - mean(X)) ./ std(X);

        % Standardize the response variable
        y = (slope - mean(slope)) ./ std(slope);

        % Define a range of lambda values for ridge regression
        lambda = 0:0.1:10;

        % Perform cross-validation to find the optimal lambda
        k = 10; % Number of folds for cross-validation
        cvp = cvpartition(length(y), 'KFold', k);
        mse = zeros(length(lambda), 1);

        for i = 1:length(lambda)
            mse_fold = zeros(k, 1);
            for j = 1:k
                X_train = X(training(cvp, j), :);
                y_train = y(training(cvp, j));
                X_test = X(test(cvp, j), :);
                y_test = y(test(cvp, j));

                Mdl = fitrlinear(X_train, y_train, 'Learner', 'leastsquares', 'Regularization', 'ridge', 'Lambda', lambda(i), 'FitBias', true);
                y_pred = predict(Mdl, X_test);
                mse_fold(j) = mean((y_test - y_pred).^2);
            end
            mse(i) = mean(mse_fold);
        end

        % Find the lambda that minimizes the MSE
        [~, optimal_lambda_index] = min(mse);
        optimal_lambda = lambda(optimal_lambda_index);

        % Fit the model using the optimal lambda
        Mdl = fitrlinear(X, y, 'Learner', 'leastsquares', 'Regularization', 'ridge', 'Lambda', optimal_lambda, 'FitBias', true);

        % Extract coefficients for the optimal lambda value
        coefficients = Mdl.Beta;

        % Define predictor names
        if include_interactions
            predictors = {'Velocity', 'Duration', 'Displacement', 'Velocity*Duration', 'Velocity*Displacement', 'Duration*Displacement'};
        else
            predictors = {'Velocity', 'Duration', 'Displacement'};
        end

        % Create bar plot
        figure;
        bar(coefficients);
        set(gca, 'xticklabel', predictors);
        xlabel('Predictors');
        ylabel('Coefficient Value');
        title(['Coefficients at Optimal Lambda = ', num2str(optimal_lambda)]);
        grid on;

        % Display optimal lambda and MSE
        disp(['Optimal Lambda: ', num2str(optimal_lambda)]);
        disp(['Cross-Validation MSE: ', num2str(mse(optimal_lambda_index))]);

        % Display the coefficients with predictor names
        disp('Coefficients for Optimal Lambda:');
        for i = 1:length(predictors)
            disp([predictors{i}, ': ', num2str(coefficients(i))]);
        end

        % Plot cross-validation error against lambda
        figure;
        plot(lambda, mse, 'LineWidth', 2);
        xlabel('Lambda');
        ylabel('Cross-Validation MSE');
        title('Cross-Validation MSE vs. Lambda');
        grid on;
        hold on;
        plot(optimal_lambda, mse(optimal_lambda_index), 'ro', 'MarkerSize', 8, 'LineWidth', 2);
        legend('MSE', 'Optimal Lambda', 'Location', 'best');
        hold off;
    end
end

