Path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Monkey run data/BaronFiles/';
% Retrieve and organize file information based on unique dates
[~, totalfiles_names] = get_datafile_info(Path);
unique_dates_totalfiles_names = groupFilesByDate(totalfiles_names);
[n_totaltrials_per_date,n_total_trials_with_response_per_date,n_total_trials_with_reward_per_date] = combineTrialNumsByUniqueDates(Path, unique_dates_totalfiles_names);
[date_key, ~] = get_unique_dates(unique_dates_totalfiles_names);

createTrialNumStackedBarPlot(date_key, n_totaltrials_per_date, n_total_trials_with_response_per_date, n_total_trials_with_reward_per_date)