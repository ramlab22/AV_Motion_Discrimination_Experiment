function [artificial_dataouts, artificial_dataout_slopes,slope_SE_across_artificial_datasets,slope_sd_across_artificial_datasets] = get_n_slopes_from_data(dataout, n_slopes_per_condition, save_name)

%GET_N_SLOPES_FROM_DATA Generates artificial data sets and calculates slopes.
%
%   [artificial_dataouts, artificial_dataout_slopes] = GET_N_SLOPES_FROM_DATA(dataout, n_slopes_per_condition, save_name)
%   generates a specified number of artificial data sets from the input 
%   data and calculates the psychometric slope for each artificial data set.
%
%   Input:
%   - dataout: A cell array containing the original data, where the first
%     row contains column labels and the subsequent rows contain the data.
%   - n_slopes_per_condition: An integer specifying the number of artificial
%     data sets (or slopes) to generate per condition.
%   - save_name: A string specifying the base name for saving generated plots.
%
%   Output:
%   - artificial_dataouts: A 1 x n_slopes_per_condition cell array, where each 
%     cell contains a cell array representing an artificial data set. The first row 
%     of each cell array contains the column labels, and the subsequent rows 
%     contain the data for that artificial data set.
%   - artificial_dataout_slopes: A 1 x n_slopes_per_condition numeric array, where 
%     each element contains the calculated psychometric slope for the corresponding 
%     artificial data set.
%
%   Description:
%   The function converts the input cell array 'dataout' into a table for easier data 
%   manipulation. It then extracts unique coherence levels from the data and creates 
%   a cell array of tables, each containing the data for one coherence level. 
%   The number of trials per coherence is divided by the number of slopes per 
%   condition, and this value is used to randomly sample rows from each coherence 
%   table to create n_slopes_per_condition artificial data sets. For each artificial 
%   data set, the function calculates the psychometric slope using the 
%   'psychometric_plotter' function and stores it in the 'artificial_dataout_slopes' array.
%
%   Example:
%   [artificial_dataouts, artificial_dataout_slopes] = get_n_slopes_from_data(dataout, 10, 'example_plot');
%
%   This example generates 10 artificial data sets and calculates the psychometric 
%   slope for each. The plots are saved with the base name 'example_plot'.
%
%   See also: cell2table, table2cell, unique, randperm, floor, psychometric_plotter
set(0, 'DefaultFigureVisible', 'off');

% convert dataout to a table to make operations easier
dataout_table=cell2table(dataout(2:end,:),'VariableNames',dataout(1,:));
dataout_table.Properties.VariableNames = regexprep(dataout_table.Properties.VariableNames, '#', 'n'); % Replace '#' with 'n'
dataout_table.Properties.VariableNames = regexprep(dataout_table.Properties.VariableNames, '\s+(.*?\)', ''); % Remove parentheses and anything within them
dataout_table.Properties.VariableNames = regexprep(dataout_table.Properties.VariableNames, '\s+', '_'); % Replace spaces with underscores

%% create a cell array of tables, each table is the contents of dataout corresponding to a unique coherence 
% get number of unique coherences in dataout
coherences=unique(dataout_table.Coherence_Level);
n_coherences=length(coherences);
audInfo.coherences=coherences';
num_catch_trials = 0; % No catch trials included

% Initialize the cell array to hold tables
coherence_tables = cell(1, n_coherences);

% Loop through each unique coherence level and extract the corresponding data
for j_coherence = 1:n_coherences
    coherence_level = coherences(j_coherence);
    % Extract rows where Coherence_Level matches the current coherence_level
    coherence_tables{1, j_coherence} = dataout_table(dataout_table.Coherence_Level == coherence_level, :);
end

%% get number of trials per unique coherence in dataout_table
n_trials_per_coherence = cellfun(@(x) height(x), coherence_tables);

%% divide number of trials per unique coherence by n_slopes_per_condition (< 3)
    %   thats the number of trials per coherence
    %   youll randomly draw from each corresponding cell of the above cell array
    %   to get n_slopes_per_condition artificial data sets
    if n_slopes_per_condition >= 3
        trials_per_coherence_per_slope_divisor=2;
        %trials_per_coherence_per_slope_divisor=3;

    else
        trials_per_coherence_per_slope_divisor = n_slopes_per_condition;
    end

%n_trials_per_coherence_per_slope = floor(n_trials_per_coherence / trials_per_coherence_per_slope_divisor);
n_trials_per_coherence_per_slope = floor(n_trials_per_coherence * 0.8);

%% create a cell array of n_slopes_per_condition tables with artificial data set
% Initialize the cell array to hold the artificial dataout tables
artificial_dataouts_tables = cell(1, n_slopes_per_condition);

% Assuming the original column labels are stored in the first row of dataout
column_labels = dataout(1, :);

% Initialize the cell array to hold the converted tables
artificial_dataouts = cell(1, n_slopes_per_condition);
artificial_dataout_slopes = zeros(1, n_slopes_per_condition);
artificial_dataout_stdgaussian = zeros(1, n_slopes_per_condition);

% Loop through each slope condition
for i_slope = 1:n_slopes_per_condition
    % Initialize an empty table to store the current artificial dataout
    current_dataout = [];

    % Loop through each unique coherence level
    for j_coherence = 1:n_coherences
        % Get the table corresponding to the current coherence level
        current_coherence_table = coherence_tables{1, j_coherence};
        
        % Randomly select rows from the current coherence table
        selected_indices = randperm(height(current_coherence_table), n_trials_per_coherence_per_slope(j_coherence));
        selected_rows = current_coherence_table(selected_indices, :);
        
        % Concatenate the selected rows to the current dataout
        current_dataout = [current_dataout; selected_rows];
    end
    
    % Store the current artificial dataout in the cell array
    artificial_dataouts_tables{1, i_slope} = current_dataout;
    
    % Convert the table to a cell array
    table_as_cell = table2cell(artificial_dataouts_tables{1, i_slope});
    
    % Prepend the column labels as the first row
    artificial_dataouts{1, i_slope} = [column_labels; table_as_cell];

    %% get slopes for each artificial dataout
    current_artificial_dataout=artificial_dataouts{1, i_slope};
    % Initialize auditory information
    [audInfo.cohFreq] = cohFreq_finder(current_artificial_dataout, audInfo);

    total_trials = size(current_artificial_dataout, 1) - 1;
    num_regular_trials = total_trials;

     % Calculate success rates
    prob = coherence_probability(current_artificial_dataout, audInfo);

    % Split data by direction
    [Right_artificial_dataout, Left_artificial_dataout] = direction_splitter(current_artificial_dataout);
    audInfo.cohFreq_right = cohFreq_finder(Right_artificial_dataout, audInfo);
    audInfo.cohFreq_left = cohFreq_finder(Left_artificial_dataout, audInfo);
    prob_Right = directional_probability(Right_artificial_dataout, audInfo);
    prob_Left = directional_probability(Left_artificial_dataout, audInfo);

    % Plot psychometric function
    [~, ~, ~,slope_dynamicrange,std_gaussian,~,~,~,~] = psychometric_plotter(dataout, prob_Right, prob_Left, audInfo, save_name, 'red');

    %store artificial dataframe slope
    artificial_dataout_slopes(1,i_slope)=slope_dynamicrange;

     %store artificial dataframe std gaussian (not accurate, just for
     %variability function. ignore vals)
    artificial_dataout_stdgaussian(1,i_slope)=std_gaussian;
end
%   [slope_SE_across_artificial_datasets, ~,slope_sd_across_artificial_datasets,~] = jackknifeTaskPerformance(artificial_dataout_slopes, artificial_dataout_stdgaussian);
slope_SE_across_artificial_datasets=0;
slope_sd_across_artificial_datasets=0;

set(0, 'DefaultFigureVisible', 'on');




