function plotTrainingFrequency(days_trained_per_week, days_trained_per_week_dates)
    %PLOTTRAININGFREQUENCY Creates a publication-ready bar graph of training frequency over weeks.
    %
    % Description:
    %   This function takes the counts of training sessions per week and the
    %   corresponding week start dates, creating a bar graph with the start
    %   dates on the x-axis and the number of training sessions on the y-axis.
    %   The graph is formatted for publication quality, with enhanced sizes and
    %   clarity for labels and titles.
    %
    % Inputs:
    %   days_trained_per_week       - A 1 x n_weeks array, counts of training sessions per week.
    %   days_trained_per_week_dates - A 2 x n_weeks string array where the first row
    %                                 contains the start dates for each week in mmddyy format.
    %
    % Example:
    %   days_trained_per_week = [2, 3, 1, 4];
    %   days_trained_per_week_dates = ["010120", "010720", "011420", "012120"; 
    %                                  "010620", "011320", "012020", "012720"];
    %   plotTrainingFrequency(days_trained_per_week, days_trained_per_week_dates);
    
    % Convert start dates from mmddyy format to datetime for plotting
    startDates = datetime(days_trained_per_week_dates(1,:), 'InputFormat', 'MMddyy');
    
    % Convert datetime to serial date number for bar plotting
    dateNums = datenum(startDates);
    
    % Create bar graph
    figure('Units', 'inches', 'Position', [0.5, 0.5, 8, 6]); % Larger figure size for publication
    bar(dateNums, days_trained_per_week, 'FaceColor', 'flat');
    
    % Improve plot aesthetics for publication quality
    ax = gca; % Current axes
    ax.FontSize = 14; % Increase font size for readability
    xlabel('Week Starting Date', 'FontSize', 16); % Larger axis labels
    ylabel('Days Trained', 'FontSize', 16);
    title('Training Frequency Over Weeks', 'FontSize', 18);
    grid off;
    
    % Set x-axis to show dates and rotate labels for readability
    ax.XTick = dateNums; % Set x-ticks to date numbers
    ax.XTickLabel = datestr(startDates, 'mm-dd-yy'); % Convert date numbers back to date strings for labels
    ax.XTickLabelRotation = 45; % Rotate the date labels for better readability
    
    % Enhance line and marker clarity
    ax.LineWidth = 1.5; % Thicker axes lines for clarity
end
