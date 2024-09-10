function results = analyzePsychometricSlopes(slopes, labels)
    %ANALYZEPSYCHOMETRICSLOPES Analyze differences in psychometric function slopes.
    %
    % This function takes an array of slopes from psychometric functions and
    % a corresponding array of condition labels, fits a linear mixed-effects
    % model, and checks if there are significant differences between the slopes
    % across different conditions.
    %
    % Syntax:
    % results = analyzePsychometricSlopes(slopes, labels)
    %
    % Inputs:
    % slopes - A numeric array containing the slopes of psychometric functions.
    % labels - A cell array of strings or a categorical array representing the
    %          condition labels for each slope.
    %
    % Outputs:
    % results - A linear mixed-effects model object from the fitlme function,
    %           which contains the fitted model details including coefficients,
    %           statistical significance, and more.
    %
    % Example:
    % slopes = [0.1, 0.2, 0.15, 0.3, 0.25];
    % labels = {'condition1', 'condition2', 'condition1', 'condition2', 'condition1'};
    % results = analyzePsychometricSlopes(slopes, labels);
    %
    % See also fitlme

    % Ensure inputs are appropriate
    if isempty(slopes) || isempty(labels)
        error('Slopes and labels cannot be empty.');
    end

    if length(slopes) ~= length(labels)
        error('Slopes and labels must have the same length.');
    end

    if iscell(labels)
        labels = categorical(labels);
    elseif ~iscategorical(labels)
        error('Labels must be a cell array of strings or a categorical array.');
    end

    % Prepare the dataset table
    tbl = table(slopes, labels, 'VariableNames', {'Slopes', 'Conditions'});

    % Fit the mixed-effects model
    % Assume 'Conditions' as a fixed effect and intercepts as random effects grouped by 'Conditions'
    try
        lme = fitlme(tbl, 'Slopes ~ Conditions + (1|Conditions)');
    catch ME
        error('Error fitting model: %s', ME.message);
    end

    % Display the fixed effects results
    % disp('Fixed effects results:');
    % disp(lme.Coefficients);

    % Check p-values for the significance of condition effects
    pValues = lme.Coefficients.pValue;
    significant = pValues < 0.05;  % Consider 0.05 as a threshold for significance

    % Display whether differences among conditions are significant
    if any(significant)
        disp('There are significant differences between the conditions.');
    else
        disp('There are no significant differences between the conditions.');
    end

    % Return the model results
    results = lme;
end
