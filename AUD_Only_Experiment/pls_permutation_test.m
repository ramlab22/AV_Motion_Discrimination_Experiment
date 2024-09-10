function pls_permutation_test(condition_table, numPermutations)
    % PLS_PERMUTATION_TEST Perform permutation testing for PLS regression.
    %
    % This function takes a table containing velocity, duration, displacement,
    % slope, and subjectID columns. It normalizes the data, determines the
    % optimal number of components using cross-validation, performs PLS regression,
    % and then uses permutation testing to determine the significance of each
    % predictor's effect on the slope.
    %
    % Usage:
    %   pls_permutation_test(condition_table, numPermutations)
    %
    % Input:
    %   condition_table - A table with columns: velocity, duration, displacement,
    %                     slope, and subjectID.
    %   numPermutations - Number of permutations for the significance test.
    %
    % Example:
    %   % Assuming condition_table is already in your workspace
    %   pls_permutation_test(condition_table, 5000); % Increase number of permutations

    if nargin < 2
        numPermutations = 1000; % Default number of permutations
    end

    % Extract relevant data from the table
    velocity = condition_table.velocity;
    duration = condition_table.duration;
    displacement = condition_table.displacement;
    slope = condition_table.slope;

    % Normalize the data
    X = [velocity, duration, displacement];
    [X_norm, mu, sigma] = zscore(X);
    y_norm = (slope - mean(slope)) / std(slope);

    % Determine the optimal number of components
    maxComponents = min(10, size(X_norm, 2)); % Adjust maximum number of components if needed
    numFolds = 10; % Number of folds for cross-validation
    optimal_num_components = determine_optimal_components(X_norm, y_norm, maxComponents, numFolds);
    fprintf('Optimal number of components: %d\n', optimal_num_components);

    % Run original PLS regression with the optimal number of components
    [~, ~, XS, ~, beta, ~, ~, stats] = plsregress(X_norm, y_norm, optimal_num_components);

    % Calculate original R-squared
    yfit = [ones(size(X_norm,1),1) X_norm] * beta;
    yfit = yfit * std(slope) + mean(slope); % Convert back to original scale
    SST = sum((slope - mean(slope)).^2);
    SSE = sum((slope - yfit).^2);
    originalR2 = 1 - SSE/SST;

    % Initialize arrays to store permutation results
    permutedR2_velocity = zeros(numPermutations, 1);
    permutedR2_duration = zeros(numPermutations, 1);
    permutedR2_displacement = zeros(numPermutations, 1);

    % Perform permutation testing
    for i = 1:numPermutations
        % Permute velocity
        perm_velocity = X_norm(randperm(length(velocity)), 1);
        perm_X = [perm_velocity, X_norm(:,2:3)];
        [~, ~, ~, ~, perm_beta, ~, ~, ~] = plsregress(perm_X, y_norm, optimal_num_components);
        perm_yfit = [ones(size(perm_X,1),1) perm_X] * perm_beta;
        perm_yfit = perm_yfit * std(slope) + mean(slope); % Convert back to original scale
        perm_SSE = sum((slope - perm_yfit).^2);
        permutedR2_velocity(i) = 1 - perm_SSE/SST;

        % Permute duration
        perm_duration = X_norm(randperm(length(duration)), 2);
        perm_X = [X_norm(:,1), perm_duration, X_norm(:,3)];
        [~, ~, ~, ~, perm_beta, ~, ~, ~] = plsregress(perm_X, y_norm, optimal_num_components);
        perm_yfit = [ones(size(perm_X,1),1) perm_X] * perm_beta;
        perm_yfit = perm_yfit * std(slope) + mean(slope); % Convert back to original scale
        perm_SSE = sum((slope - perm_yfit).^2);
        permutedR2_duration(i) = 1 - perm_SSE/SST;

        % Permute displacement
        perm_displacement = X_norm(randperm(length(displacement)), 3);
        perm_X = [X_norm(:,1:2), perm_displacement];
        [~, ~, ~, ~, perm_beta, ~, ~, ~] = plsregress(perm_X, y_norm, optimal_num_components);
        perm_yfit = [ones(size(perm_X,1),1) perm_X] * perm_beta;
        perm_yfit = perm_yfit * std(slope) + mean(slope); % Convert back to original scale
        perm_SSE = sum((slope - perm_yfit).^2);
        permutedR2_displacement(i) = 1 - perm_SSE/SST;
    end

    % Calculate p-values
    p_value_velocity = sum(permutedR2_velocity >= originalR2) / numPermutations;
    p_value_duration = sum(permutedR2_duration >= originalR2) / numPermutations;
    p_value_displacement = sum(permutedR2_displacement >= originalR2) / numPermutations;

    % Display results
    fprintf('Original R-squared: %.4f\n', originalR2);
    fprintf('P-value for Velocity: %.4f\n', p_value_velocity);
    fprintf('P-value for Duration: %.4f\n', p_value_duration);
    fprintf('P-value for Displacement: %.4f\n', p_value_displacement);
end

function optimal_num_components = determine_optimal_components(X, y, maxComponents, numFolds)
    % DETERMINE_OPTIMAL_COMPONENTS Determine the optimal number of PLS components using cross-validation
    %
    % Inputs:
    %   X - Matrix of predictors
    %   y - Vector of response variable
    %   maxComponents - Maximum number of PLS components to consider
    %   numFolds - Number of folds for cross-validation
    %
    % Output:
    %   optimal_num_components - Optimal number of PLS components
    
    % Initialize RMSE storage
    RMSE = zeros(maxComponents, 1);

    % Perform K-fold cross-validation
    cv = cvpartition(size(X, 1), 'KFold', numFolds);

    for numComponents = 1:maxComponents
        mse = zeros(cv.NumTestSets, 1);
        
        for i = 1:cv.NumTestSets
            X_train = X(cv.training(i), :);
            y_train = y(cv.training(i), :);
            X_test = X(cv.test(i), :);
            y_test = y(cv.test(i), :);
            
            [~, ~, ~, ~, beta] = plsregress(X_train, y_train, numComponents);
            y_pred = [ones(size(X_test, 1), 1) X_test] * beta;
            mse(i) = mean((y_test - y_pred).^2);
        end
        
        RMSE(numComponents) = sqrt(mean(mse));
    end

    % Determine the optimal number of components
    [~, optimal_num_components] = min(RMSE);
    
    % Plot the RMSE for different numbers of components
    figure;
    plot(1:maxComponents, RMSE, '-o');
    xlabel('Number of Components');
    ylabel('Root Mean Square Error');
    title('Cross-Validation to Determine Optimal Number of PLS Components');
    grid on;
end
