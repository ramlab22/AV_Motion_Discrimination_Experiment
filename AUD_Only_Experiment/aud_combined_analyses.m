%before running, create a folder with all the auditory only blocks you want
%to combine, plot, and analyze. this script goes into that folder, combines
%those files, plots the psychometric function, and gives you mu and the
%standard deviation of the cumulative gaussian of the function (mu)

%Path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel93.5_dis78/' ;% wherever you want to search
%Path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel59.95_dis50/' ;% wherever you want to search
%Path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel43_dis36/' ;% wherever you want to search
%Path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel26.38_dis22/';
%Path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel9.59_dis8/' ;% wherever you want to search

%Path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel93.5_dis78/' ;% wherever you want to search
%Path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel59.95_dis50/' ;% wherever you want to search
%Path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel43_dis36/' ;% wherever you want to search
%Path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_displacement/dur834ms_vel26.38_dis22/';
%Path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel9.59_dis8/' ;% wherever you want to search

%Path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_velocity/dur1100ms_vel59.95_dis66/';
%Path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_displacement/dur1300ms_vel16.9_dis22/';
%Path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_velocity/dur1300ms_vel59.95_dis78/';
%Path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_velocity/dur601ms_vel59.95_dis36/';
%Path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_displacement/dur601ms_vel36.61_dis22/';

%Path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_displacement/dur367ms_vel59.95_dis22/';
%Path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_displacement/dur133ms_vel165.4_dis22/';
%Path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_velocity/dur133ms_vel59.95_dis8/';
%Path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/dur312ms_vel250_dis78/';
%Path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_velocity/dur133ms_vel59.95_dis8/';

Path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_displacement/dur133ms_vel165.4_dis22/';
[data_save_path, save_name] = deduce_analysis_save_info(Path);
data_save_path=Path;
%save_name='Alv_AudOnly_dur312ms_vel250_dis78';
[x_scattervals, y_scattervals, x_curvevals, y_curvevals, std_gaussian_per_date, slope_per_date, slope_at_50_percent_per_date, date_key,master_dataout] = get_unisensory_figdata_values(Path);
try 
    %get slope variability across dates 
    [slope_variability_SE, std_gaussian_variability_SE,slope_sd,std_gaussian_sd] = jackknifeTaskPerformance(slope_per_date, std_gaussian_per_date);
  %  [slope_variability_SE, std_gaussian_variability_SE, slope_at_50_percent_variability_SE,slope_sd,std_gaussian_sd,slope_at_50_percent_sd] = jackknifeTaskPerformance(slope_per_date, std_gaussian_per_date, slope_at_50_percent_per_date);

catch
    slope_variability_SE='NaN';
    std_gaussian_variability_SE='NaN';
    slope_at_50_percent_variability_SE='NaN';
    slope_sd='NaN';
    std_gaussian_sd='NaN';
    slope_at_50_percent_sd='NaN';
    
end
[dataout,column_titles,totalfiles_names] = combine_data_acrossblocks(Path);


close all
%get consider only first n_trials per coherence
desired_n_trials_per_coh=400;
%dataout = filter_trials_by_number(desired_n_trials_per_coh, dataout);

audInfo.coherences=unique(cell2mat(dataout(2:end,8)))';
[audInfo.cohFreq] = cohFreq_finder(dataout, audInfo);

total_trials=size(dataout,1)-1;

num_regular_trials = total_trials;
num_catch_trials =0; %set catch trials to 0 since the combine_data_acrossblocks function already deleted catch trials

format long g
%Break down of each success rate based on coherence level
prob = coherence_probability(dataout,audInfo)

[Right_dataout, Left_dataout] = direction_splitter(dataout);

audInfo.cohFreq_right = cohFreq_finder(Right_dataout, audInfo);
audInfo.cohFreq_left = cohFreq_finder(Left_dataout, audInfo);

prob_Right = directional_probability(Right_dataout, audInfo);
prob_Left = directional_probability(Left_dataout, audInfo);
%set(groot,'defaultLineLineWidth',2.5);

[x_scatter, y_scatter, fig_both,slope_dynamicrange,std_gaussian,LR_xdata,LR_ydata,LR_curve_xvals,LR_curve_yvals] = psychometric_plotter(dataout,prob_Right,prob_Left, audInfo,save_name,'red');
ax = gca; 
hold on
% if desired_n_trials_per_coh>=400
%     text(-max(LR_curve_xvals), .7, "std cum.guas. SE: " + sprintf('%.3f', std_gaussian_variability_SE), 'FontSize', 22);
%     text(-max(LR_curve_xvals), .75, "slope at 50 percent SE: " + sprintf('%.3f', slope_at_50_percent_variability_SE), 'FontSize', 22);
%     text(-max(LR_curve_xvals), .85, "Across Sessions: " ,'FontSize', 22);
% end

 % %Make Rightward only graph
 % prob_right_only = coherence_probability_1_direction(Right_dataout, audInfo);
 % [R_coh, R_pc, R_fig] = psychometric_plotter_1_direction(prob_right_only, 'RIGHT ONLY', audInfo, save_name);

% %%Make Leftward only graph
% prob_left_only = coherence_probability_1_direction(Left_dataout, audInfo);
% [L_coh, L_pc, L_fig] = psychometric_plotter_1_direction(prob_left_only, 'LEFT ONLY', audInfo, save_name);

%mu
std_gaussian
std_gaussian_variability_SE
% slope_at_50_percent = 1 / (std_gaussian * sqrt(2 * pi))
% slope_at_50_percent_variability_SE
dy_dx = diff(LR_curve_yvals) ./ diff(LR_curve_xvals); % calculates the slope of the CDF curve by taking the difference between consecutive y-values and dividing by the difference between their corresponding x-values
slope = mean(dy_dx)
slope_variability_SE
figure_file_directory=Path;
save(horzcat(data_save_path,save_name,'.mat'))
resizeFigures();
%Save all figures to Figure Directory
saveas(fig_both, [Path save_name '.png'])
saveas(fig_both, [Path save_name '.fig'])

% saveas(R_fig, [figure_file_directory save_name '_AUD_Psyc_Func_R.png'])
% saveas(L_fig, [figure_file_directory save_name '_AUD_Psyc_Func_L.png'])


  