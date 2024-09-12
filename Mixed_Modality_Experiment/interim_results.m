function [prob]=interim_results (figure_file_directory, save_name, dataout, audInfo)
    total_trials=trialcounter;
    num_regular_trials = total_trials - audInfo.catchtrials;
    num_catch_trials = audInfo.catchtrials;
    
    [Fixation_Success_Rate, AUD_Success_Rate, Target_Success_Rate_Regular, Target_Success_Rate_Catch] = SR_CALC(dataout,total_trials,num_regular_trials,num_catch_trials)
    
    %Break down of each success rate based on coherence level
    %Count how many rew and N/A per coherence
    audInfo.cohFreq = cohFreq_finder(dataout, audInfo);
    
    prob = coherence_probability(dataout,audInfo)
    %    prob_zero = prob(1,:);
    
    [Right_dataout, Left_dataout] = direction_splitter(dataout);
    
    audInfo.cohFreq_right = cohFreq_finder(Right_dataout, audInfo);
    audInfo.cohFreq_left = cohFreq_finder(Left_dataout, audInfo);
    
    
    prob_Right = directional_probability(Right_dataout, audInfo);
    prob_Left = directional_probability(Left_dataout, audInfo);
    
    [x, y, fig_both] = psychometric_plotter(prob_Right,prob_Left, audInfo, save_name);
    Eye_Tracker_Plotter(eye_data_matrix);
    
    %%Make Rightward only graph
    prob_right_only = coherence_probability_1_direction(Right_dataout, audInfo);
    [R_coh, R_pc, R_fig] = psychometric_plotter_1_direction(prob_right_only, 'RIGHT ONLY', audInfo, save_name);
    
    %%Make Leftward only graph
    prob_left_only = coherence_probability_1_direction(Left_dataout, audInfo);
    [L_coh, L_pc, L_fig] = psychometric_plotter_1_direction(prob_left_only, 'LEFT ONLY', audInfo, save_name);
    
    %%Make Coh vs Trial graph to track progress
    coh_vs_trial_fig = plot_coh_vs_trial(dataout, save_name);
    