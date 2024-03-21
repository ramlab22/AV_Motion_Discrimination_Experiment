function [uniqueDates,idx] = get_unique_dates(totalfiles_names)
    %account for cases where filenames are already organized with rows as
    %unique dates and columns as blocks
    if length(totalfiles_names(:,1))>1
        totalfiles_names=totalfiles_names(:,1)';
    end
    % Extract the first 6 characters (date) from each filename
    dates = cellfun(@(x) x(1:6), totalfiles_names, 'UniformOutput', false);
    
    % Find the unique dates and their occurrences
    [uniqueDates, ~, idx] = unique(dates);
