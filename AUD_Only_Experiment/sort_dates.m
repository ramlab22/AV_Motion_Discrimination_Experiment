function sortedDates = sort_dates(uniqueDates)
    %SORTDATES Sorts dates in mmddyy format from least to most recent.
    %
    % Description:
    %   This function takes a cell array of date strings in mmddyy format and
    %   sorts them from the least to the most recent date. It assumes all dates
    %   belong to the 2000s.
    %
    % Input:
    %   uniqueDates - A cell array of strings, each representing a date in mmddyy format.
    %
    % Output:
    %   sortedDates - A cell array of strings, sorted from least to most recent date.
    %
    % Example:
    %   dates = {'010120', '123119', '070415'};
    %   sortedDates = sortDates(dates);
    %   disp(sortedDates);
    
    % Convert mmddyy strings to MATLAB datetime objects, assuming year 2000+
    dateNumbers = datetime(uniqueDates, 'InputFormat', 'MMddyy', 'Format', 'yyyyMMdd');
    
    % Sort the datetime array
    sortedDateNumbers = sort(dateNumbers);
    
    % Convert sorted datetime objects back to mmddyy strings
    sortedDates = cellstr(datestr(sortedDateNumbers, 'mmddyy'));
end
