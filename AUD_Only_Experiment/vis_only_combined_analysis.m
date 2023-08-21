Path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv_vis_staircase/' ;% wherever you want to search
[dataout,column_titles,totalfiles_names] = combine_data_acrossblocks(Path);
save_name='alv_vis_staircase';
[dataout]=convert_vis_directioncode(dataout);
dotInfo.coherences=unique(cell2mat(dataout(2:end,8)))';
[dotInfo.cohFreq] = cohFreq_finder(dataout, dotInfo);

total_trials=size(dataout,1)-1;

num_regular_trials = total_trials;  
num_catch_trials =0; 

%[Fixation_Success_Rate, AUD_Success_Rate, Target_Success_Rate_Regular, Target_Success_Rate_Catch] = SR_CALC(dataout,total_trials,num_regular_trials,num_catch_trials)
    
    %Break down of each success rate based on coherence level 
      
     prob = coherence_probability(dataout,dotInfo)
%    prob_zero = prob(1,:); 
    
    [Right_dataout, Left_dataout] = direction_splitter(dataout);
    
    dotInfo.cohFreq_right = cohFreq_finder(Right_dataout, dotInfo);
    dotInfo.cohFreq_left = cohFreq_finder(Left_dataout, dotInfo);
    
    
    prob_Right = directional_probability(Right_dataout, dotInfo); 
    prob_Left = directional_probability(Left_dataout, dotInfo); 
    [x, y, fig_both, coeff_p_values,CIs_of_LR_fit,mu,std_gaussian,LR_xdata,LR_ydata,LR_curve_xvals,LR_curve_yvals] = psychometric_plotter(prob_Right,prob_Left, dotInfo,save_name);
   % Eye_Tracker_Plotter(eye_data_matrix);
    
    %%Make Rightward only graph
    prob_right_only = coherence_probability_1_direction(Right_dataout, dotInfo);
    [R_coh, R_pc, R_fig] = psychometric_plotter_1_direction(prob_right_only, 'RIGHT ONLY', dotInfo, save_name);
    
    %%Make Leftward only graph
    prob_left_only = coherence_probability_1_direction(Left_dataout, dotInfo);
    [L_coh, L_pc, L_fig] = psychometric_plotter_1_direction(prob_left_only, 'LEFT ONLY', dotInfo, save_name);
    mu
    std_gaussian
    slope_at_50_percent = 1 / (std_gaussian * sqrt(2 * pi))
    dy_dx = diff(LR_curve_yvals) ./ diff(LR_curve_xvals); % calculates the slope of the CDF curve by taking the difference between consecutive y-values and dividing by the difference between their corresponding x-values
    slope = mean(dy_dx)

    figure_file_directory=Path;
    %Save all figures to Figure Directory
   % saveas(fig_both, [figure_file_directory save_name '_AUD_Psyc_Func_LR.png'])
   % saveas(R_fig, [figure_file_directory save_name '_AUD_Psyc_Func_R.png'])
   % saveas(L_fig, [figure_file_directory save_name '_AUD_Psyc_Func_L.png'])
    
    %save([data_file_directory save_name],'save_name','dataout','Fixation_Success_Rate','RDK_Success_Rate','Target_Success_Rate_Regular','Target_Success_Rate_Catch','ExpInfo','dotInfo','Total_Block_Time','eye_data_matrix', "coeff_p_values",'n_trials_with_response','n_trials_with_reward','proportion_response_reversals_after_correct_response','proportion_response_reversals_after_incorrect_response','threshold','prob');

  