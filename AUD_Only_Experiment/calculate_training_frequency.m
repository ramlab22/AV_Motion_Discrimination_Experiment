function [days_trained_per_week,days_trained_per_week_dates] = calculate_training_frequency(sorted_dates, start_date, end_date)
   %CALCULATE_TRAINING_FREQUENCY Counts training sessions per week within a date range
    %and provides the corresponding start and end dates for each week.
    %
    % Description:
    %   This function takes a list of dates when training occurred (sorted_dates),
    %   adjusts the start date to the closest Sunday, and calculates the number
    %   of weeks between the adjusted start date and the end date. It counts how
    %   many times training occurred each week, returning a 1 x n_weeks array with
    %   these counts and a 2 x n_weeks string array with the start and end dates
    %   for each week's training sessions.
    %
    % Inputs:
    %   sorted_dates - A cell array of strings, dates in mmddyy format, sorted from earliest to latest.
    %   start_date   - A string representing the start date in mmddyy format.
    %   end_date     - A string representing the end date in mmddyy format.
    %
    % Outputs:
    %   days_trained_per_week       - A 1 x n_weeks array, counts of training sessions per week.
    %   days_trained_per_week_dates - A 2 x n_weeks string array where the first row contains
    %                                 the start dates and the second row contains the end dates
    %                                 for each week, all in mmddyy format.
    %
    % Example:
    %   sorted_dates = {'010120', '011220', '020320'};
    %   start_date = '010120';
    %   end_date = '022920';
    %   [days_trained_per_week, days_trained_per_week_dates] = calculate_training_frequency(sorted_dates, start_date, end_date);
    %   disp(days_trained_per_week);
    %   disp(days_trained_per_week_dates);
    
    % Convert dates from mmddyy to datetime
    formatIn = 'MMddyy';
    dtSortedDates = datetime(sorted_dates, 'InputFormat', formatIn);
    dtStartDate = datetime(start_date, 'InputFormat', formatIn);
    dtEndDate = datetime(end_date, 'InputFormat', formatIn);
    
    % Adjust dtStartDate to the closest Sunday
    dayOfWeek = weekday(dtStartDate);
    if dayOfWeek > 1
        % If it's not Sunday, adjust to the closest previous Sunday
        dtStartDate = dtStartDate - days(dayOfWeek - 1);
    end
    
    % Calculate the number of weeks
    duration = dtEndDate - dtStartDate;
    n_weeks = ceil(days(duration) / 7);
    
    % Initialize the array to store the count of training sessions per week
    days_trained_per_week = zeros(1, n_weeks);
    % Initialize the array to store the start date (first row) and end date
    % (second row) of the training sessions per week values
    days_trained_per_week_dates = zeros(2, n_weeks);
    days_trained_per_week_dates = string(days_trained_per_week_dates);

    % For each week, count the training sessions
    for week = 1:n_weeks
        weekStart = dtStartDate + days((week-1)*7);
        weekEnd = weekStart + days(6); % End of the week
        weekStart_string=datestr(weekStart,'mmddyy');
        weekEnd_string=datestr(weekEnd,'mmddyy');

        % Ensure the weekEnd does not exceed the dtEndDate
        if weekEnd > dtEndDate
            weekEnd = dtEndDate;
        end
        
        % Count the training sessions in the current week
        weekTrainings = sum(dtSortedDates >= weekStart & dtSortedDates <= weekEnd);
        
        % Update the training sessions count for the current week
        days_trained_per_week(week) = weekTrainings;
        days_trained_per_week_dates(1,week) = weekStart_string;
        days_trained_per_week_dates(2,week) = weekEnd_string;
    end
end
