function filtered_dataout = filter_trials_by_number(n_trials, dataout)
    %FILTER_TRIALS_BY_NUMBER Filters trials based on the coherence level.
    %
    % This function takes a cell array `dataout`, which includes various
    % trial data with the first row as column titles. It filters out trials
    % where 'Fixation Correct' is 'Yes' and then selects the first `n_trials`
    % trials for each unique 'Coherence Level'. After filtering, the 'Coherence
    % Level' column values are converted back to doubles.
    %
    % Parameters:
    %   n_trials (int): The maximum number of trials to select for each
    %                   unique 'Coherence Level'.
    %   dataout (cell array): The cell array containing trial data with the
    %                         first row as column titles. Expected columns
    %                         include 'Coherence Level' and 'Fixation Correct'.
    %
    % Returns:
    %   filtered_dataout (cell array): A cell array similar in structure to
    %                                  `dataout` but filtered according to the
    %                                  specified criteria, with 'Coherence Level'
    %                                  converted back to double.
    %
    % Errors:
    %   If `dataout` is empty or does not contain the required columns, the
    %   function will error out indicating the issue with the input array.
    %
    % Example:
    %   % Assuming `dataout` is already loaded with the appropriate structure
    %   n_trials = 200;
    %   filtered_data = filter_trials_by_number(n_trials, dataout);
    %   disp(filtered_data);
    %
    % See also UNIQUE, STRCMP, CELLFUN

    % Ensure the dataout array is not empty and has the required structure
    if isempty(dataout) || size(dataout, 1) < 2 || size(dataout, 2) < 2
        error('Invalid or empty dataout array');
    end

    % Find the column indices for 'Coherence Level' and 'Fixation Correct'
    column_titles = dataout(1, :);
    col_coherence = find(strcmp(column_titles, 'Coherence Level'));
    col_fix_correct = find(strcmp(column_titles, 'Fixation Correct'));

    % Error handling if column indices are not found
    if isempty(col_coherence) || isempty(col_fix_correct)
        error('Required columns are not found in the dataout array');
    end

    % Initialize the filtered dataout array with column titles
    filtered_dataout = dataout(1, :);

    % Filter out trials where 'Fixation Correct' is 'No'
    valid_trials = dataout(2:end, :);  % Exclude title row
    valid_trials = valid_trials(strcmp(valid_trials(:, col_fix_correct), 'Yes'), :);

    % Convert all entries in Coherence Level column to string if not already
    coherence_levels = valid_trials(:, col_coherence);
    if any(cellfun(@(x) ~ischar(x) && ~isstring(x), coherence_levels))
        coherence_levels = cellfun(@num2str, coherence_levels, 'UniformOutput', false);
        valid_trials(:, col_coherence) = coherence_levels;
    end

    % Get unique values of 'Coherence Level'
    unique_coherence_levels = unique(coherence_levels);

    % Collect up to the first n_trials for each unique 'Coherence Level'
    for k = 1:length(unique_coherence_levels)
        level = unique_coherence_levels{k};
        trials_for_level = valid_trials(strcmp(valid_trials(:, col_coherence), level), :);
        trials_to_add = trials_for_level(1:min(n_trials, size(trials_for_level, 1)), :);

        % Convert 'Coherence Level' back to double for the added trials
        trials_to_add(:, col_coherence) = cellfun(@str2double, trials_to_add(:, col_coherence), 'UniformOutput', false);

        filtered_dataout = [filtered_dataout; trials_to_add];
    end
end
