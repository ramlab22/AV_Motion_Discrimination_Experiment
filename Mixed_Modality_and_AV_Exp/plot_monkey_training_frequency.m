folder_path='/Volumes/Ramlab/Jackson/Adriana Stuff/AV_Behavioral_Data/';
unique_dates = get_unique_dates_from_folder(folder_path);
sorted_dates = sort_dates(unique_dates);
[days_trained_per_week,days_trained_per_week_dates] = calculate_training_frequency(sorted_dates, '010123', '123123');
plotTrainingFrequency(days_trained_per_week, days_trained_per_week_dates)