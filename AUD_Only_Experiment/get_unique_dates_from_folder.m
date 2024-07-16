function uniqueDates = get_unique_dates_from_folder(folderPath)
    %GETUNIQUEDATESFROMFILES Extract unique dates from file names in a folder.
    %
    % Description:
    %   This function scans a specified folder for files with a .mat extension
    %   and extracts a list of unique dates from the filenames. The function
    %   assumes that the filenames follow a specific format where the first 6
    %   characters represent a date in mmddyy format. It skips files whose names
    %   do not adhere to this date format.
    %
    % Input:
    %   folderPath - A string or character array specifying the path to the folder
    %                containing the .mat files.
    %
    % Output:
    %   uniqueDates - A cell array of strings, each representing a unique date
    %                 extracted from the file names. Dates are in mmddyy format.
    %
    % Example:
    %   folderPath = 'C:\path\to\your\folder';
    %   uniqueDates = getUniqueDatesFromFiles(folderPath);
    %   disp(uniqueDates);
    %
    % Note:
    %   The date validation is basic and does not account for leap years or the
    %   correct number of days in each month. It simply checks that the month is
    %   between 01 and 12, and the day is between 01 and 31.
    
    % Check if the provided folderPath exists and is a directory
    if ~isfolder(folderPath)
        error('The specified folder does not exist.');
    end

    % Get a list of all files in the directory
    files = dir(fullfile(folderPath, '*.mat'));

    % Initialize an empty cell array to store dates
    dates = {};

    % Define a regular expression pattern for date validation (mmddyy)
    datePattern = '^(0[1-9]|1[0-2])(0[1-9]|[12][0-9]|3[01])\d{2}';

    % Loop through each file in the folder
    for i = 1:length(files)
        fileName = files(i).name;

        % Extract the date part from the filename (first 6 characters)
        dateStr = fileName(1:6);

        % Check if the dateStr matches the date format
        if regexp(dateStr, datePattern)
            % If it matches, add the date to the dates array
            dates{end+1} = dateStr; %#ok<AGROW>
        end
    end

    % Find unique dates and return them
    uniqueDates = unique(dates);
end
