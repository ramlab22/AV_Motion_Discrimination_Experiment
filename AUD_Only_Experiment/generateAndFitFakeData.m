function generateAndFitFakeData()
    % generateAndFitFakeData Generates fake data with known relationships and fits a mixed-effects model with PCA.
    %
    % This function generates fake data for the predictors (velocity, duration, displacement)
    % and the response variable (slope) based on a predefined true model with known weights.
    % It then fits a mixed-effects model using PCA to address multicollinearity and plots the results.
    %
    % The true model used to generate the data is:
    %   slope = beta0 + beta1 * velocity + beta2 * duration + beta3 * displacement + noise
    %
    % The function also includes random noise to simulate measurement variability.
    %
    % Usage:
    %   generateAndFitFakeData()
    %
    % Example:
    %   generateAndFitFakeData()
    %
    % See also: plotMixedEffectsPCAResults, fitlme, pca

    % Define the true model weights
    beta0 = 0;      % Intercept
    beta1 = 0;    % Velocity weight (minimal influence)
    beta2 = 1.0;      % Duration weight (strong influence)
    beta3 = 0;    % Displacement weight (minimal influence)
    noise_std = 0.1;  % Standard deviation of the noise

    % Original data for predictors
    velocity = [26.38, 43, 59.95, 76.74, 93.5, 26.38, 43, 59.95, 76.74, 93.5, ...
                59.95, 59.95, 59.95, 59.95, 59.95, 59.95, 59.95, 59.95, 36.61, 20, ...
                16.9, 36.61, 20, 16.9]';
    duration = [0.834, 0.834, 0.834, 0.834, 0.834, 0.834, 0.834, 0.834, 0.834, 0.834, ...
                0.367, 0.601, 1.1, 1.3, 0.367, 0.601, 1.1, 1.3, 0.601, 1.1, ...
                1.3, 0.601, 1.1, 1.3]';
    displacement = [22, 36, 50, 66, 78, 22, 36, 50, 66, 78, ...
                    22, 36, 66, 78, 22, 36, 66, 78, 22, 22, ...
                    22, 22, 22, 22]';
    subjectID = [{'ba'}; {'ba'}; {'ba'}; {'ba'}; {'ba'}; ...
                 {'alv'}; {'alv'}; {'alv'}; {'alv'}; {'alv'}; ...
                 {'ba'}; {'ba'}; {'ba'}; {'ba'}; {'alv'}; ...
                 {'alv'}; {'alv'}; {'alv'}; {'ba'}; {'ba'}; ...
                 {'ba'}; {'alv'}; {'alv'}; {'alv'}];

    % Generate fake slopes based on the true model
    slopes = beta0 + beta1 * velocity + beta2 * duration + beta3 * displacement + noise_std * randn(size(velocity));
    
    % Create the condition table
    condition_table = table(velocity, duration, displacement, subjectID, slopes, 'VariableNames', ...
        {'velocity', 'duration', 'displacement', 'subjectID', 'slope'});

    % Define the formula for the mixed effects model
    formula = 'slope ~ velocity + duration + displacement + (1|subjectID)';

    % Plot the results
    plotMixedEffectsPCAResults(condition_table, formula, 1);
end
