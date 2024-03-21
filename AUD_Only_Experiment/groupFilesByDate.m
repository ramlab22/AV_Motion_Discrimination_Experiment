function unique_dates_totalfiles_names = groupFilesByDate(totalfiles_names)
%GROUPFILESBYDATE Groups files by their date based on the first 6 characters of their names.
%
% This function takes a cell array of filenames, extracts the first 6 characters
% from each filename as the date, and then groups the filenames by these dates.
% It returns a cell array where each row corresponds to a unique date, and
% each column under a row contains filenames that share the same date.
%
% Inputs:
%   totalfiles_names - A cell array of strings, where each string is a filename
%                      that contains a date in its first 6 characters.
%
% Output:
%   unique_days_totalfiles_names - A cell array where each row represents a
%                                  unique date and contains the filenames
%                                  associated with that date.

     % Find the unique dates and their occurrences
    [uniqueDates,uniqueDates_idx] = get_unique_dates(totalfiles_names);
    % Determine the number of files for each unique date
    numFilesPerDate = accumarray(uniqueDates_idx, 1);
    maxFiles = max(numFilesPerDate); % Maximum number of files in any given date
    
    % Initialize the output cell array with appropriate dimensions
    unique_dates_totalfiles_names = cell(length(uniqueDates), maxFiles);
    
    % Create a temporary storage to keep track of the insert position for each date
    insertPos = zeros(length(uniqueDates), 1);
    
    % Loop over each file to group by date
    for i = 1:length(totalfiles_names)
        % Find the index for the current date in uniqueDates
        currentDateIndex = uniqueDates_idx(i);
        
        % Determine the insertion column for the current file
        insertColumn = insertPos(currentDateIndex) + 1;
        insertPos(currentDateIndex) = insertColumn;
        
        % Insert the file name into the output array at the correct position
        unique_dates_totalfiles_names(currentDateIndex, insertColumn) = totalfiles_names(i);
    end
end
