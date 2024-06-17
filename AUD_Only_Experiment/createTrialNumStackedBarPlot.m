function createTrialNumStackedBarPlot(date_key, n_totaltrials_per_date, n_total_trials_with_response_per_date, n_total_trials_with_reward_per_date)
      %
    % This function generates a stacked bar plot where each bar represents a
    % specific date. The bars are divided into three segments, representing 
    % the number of trials correct, the number of trials the subject responded to,
    % and the total number of trials. This version of the function stacks the bars 
    % such that the segment for the total number of trials is on top, followed by 
    % trials responded to, and trials correct at the bottom. The segments are 
    % color-coded as blue for total trials, red for trials responded to, and 
    % green for trials correct.
    %
    % Parameters:
    %   - date_key: A 1x54 cell array of strings, where each string is a date in
    %     'mmddyy' format (e.g., '030424' for March 4, 2024).
    %   - n_totaltrials_per_date: A 1x54 array of doubles, each representing the
    %     total number of trials for a corresponding date in `date_key`.
    %   - n_total_trials_with_response_per_date: A 1x54 array of doubles, each
    %     representing the number of trials the subject responded to for a
    %     corresponding date in `date_key`.
    %   - n_total_trials_with_reward_per_date: A 1x54 array of doubles, each
    %     representing the number of trials the subject got correct for a
    %     corresponding date in `date_key`.
    %
    % Example:
    %   createStackedBarPlot(date_key, n_totaltrials_per_date,
    %   n_total_trials_with_response_per_date, n_total_trials_with_reward_per_date)
    %
    % This function does not return any values. It creates a figure window
    % displaying the stacked bar plot with appropriately labeled axes, a title,
    % and a legend. The plotting order is adjusted to visualize the data hierarchy.

% Convert date_key strings into datetime objects for better x-axis labels
    dates = datetime(date_key, 'InputFormat', 'MMddyy');
    
    % Prepare the data for the stacked bar plot
    % First, calculate the differences needed for the middle and bottom segments
    % so that when stacked, they represent the total trials on top, followed by 
    % trials with a response, and then trials correct at the bottom.
    diff_response_to_total = n_totaltrials_per_date - n_total_trials_with_response_per_date;
    diff_correct_to_response = n_total_trials_with_response_per_date - n_total_trials_with_reward_per_date;
    
    % The data for the plot needs to be in a matrix where each row represents a category
    % and each column represents a date. The first row (now the bottom segment) will be
    % the number of trials correct, the second row (middle segment) is the difference 
    % between the number of trials with a response and correct trials, and the third row 
    % (top segment) is the difference between total trials and trials with a response.
    data = [n_total_trials_with_reward_per_date;
            diff_correct_to_response;
            diff_response_to_total]';
    
    % Plot the stacked bar graph
    figure; % Create a new figure window
    bar(dates, data, 'stacked');
    
    % Customize the plot with labels and a title
    xlabel('Date');
    ylabel('Number of Trials');
    title('Trial Data by Date');
    legend('Trials Correct', 'Trials Responded To', 'Total Trials', 'Location', 'Best');
    
    % Improve the x-axis labels readability
    ax = gca; % Get current axis
    ax.XTickLabelRotation = 45; % Rotate labels to make them readable
    % Ensure each date is labeled on the x-axis
    ax.XTick = dates;
    % Format dates for x-axis labels to ensure readability
    ax.XTickLabel = datestr(dates, 'mm/dd/yy');
  
    % Optionally adjust bar colors
    bars = findobj(gca, 'Type', 'Bar');
    set(bars(1), 'FaceColor', 'green'); % Correct
    set(bars(2), 'FaceColor', 'red'); % Responded
    set(bars(3), 'FaceColor', 'blue'); % Total
end
