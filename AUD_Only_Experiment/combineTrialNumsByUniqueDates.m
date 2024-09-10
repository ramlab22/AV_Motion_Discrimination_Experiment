function [n_totaltrials_per_date,n_total_trials_with_response_per_date,n_total_trials_with_reward_per_date] = combineTrialNumsByUniqueDates(Path, unique_dates_totalfiles_names)

n_unique_dates = length(unique_dates_totalfiles_names(:,1)); % Number of unique dates
n_total_trials_with_response_per_date=zeros(1,length(unique_dates_totalfiles_names(:,1)));
n_total_trials_with_reward_per_date=zeros(1,length(unique_dates_totalfiles_names(:,1)));

for i_uniquedate = 1:n_unique_dates
    % Determine the number of non-empty file names for the current date
    n_blocks_uniquedate = sum(~cellfun('isempty', unique_dates_totalfiles_names(i_uniquedate, :)) & ...
                              ~cellfun(@(c) isequal(c, zeros(0,0)), unique_dates_totalfiles_names(i_uniquedate, :)));
    
    for j_block = 1:n_blocks_uniquedate
        % Load the data from the current file
        load(horzcat(Path, unique_dates_totalfiles_names{i_uniquedate,j_block}));
        close all
        
        
        % Combine all data for the particular date into one cell
        if j_block == 1
            n_totaltrials = num_regular_trials; % Initialize with data from the first file
            n_total_trials_with_response = n_trials_with_response; 
            n_total_trials_with_reward = n_trials_with_reward; 

        else
            % Append data from subsequent files, excluding the first row (titles)
            n_totaltrials = n_totaltrials + num_regular_trials;
            n_total_trials_with_response = n_total_trials_with_response + n_trials_with_response;
            n_total_trials_with_reward = n_total_trials_with_reward + n_trials_with_reward;
        end
    end % for each block/file of a unique date
    
    % Store the combined data for the current unique date
    n_totaltrials_per_date(1,i_uniquedate) = n_totaltrials;
    n_total_trials_with_response_per_date(1,i_uniquedate) = n_total_trials_with_response;
    n_total_trials_with_reward_per_date(1,i_uniquedate) = n_total_trials_with_reward;

end % for each unique date
