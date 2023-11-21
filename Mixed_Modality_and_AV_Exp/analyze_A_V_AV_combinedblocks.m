
Path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/grant_figure/' ;% wherever you want to search
[dataout,column_titles,totalfiles_names] = combine_data_acrossblocks(Path);
save_name='Ba_834msstim_8dBSNR';

%% End of Block
[AUD_dataout, VIS_dataout, AV_dataout] = modality_splitter(dataout);

audInfo.coherences=unique(cell2mat(AUD_dataout(:,8)))';
dotInfo.coherences=unique(cell2mat(VIS_dataout(:,8)))';
AVInfo.cohSet_aud=unique(cell2mat(AV_dataout(:,8)))';
AVInfo.cohSet_dot=unique(cell2mat(AV_dataout(:,8)))';
AVInfo.coherences_aud=unique(cell2mat(AV_dataout(:,8)))';
AVInfo.coherences_dot=unique(cell2mat(AV_dataout(:,8)))';

% Get the Frequencies for each coherence in each modality
[audInfo.cohFreq] = cohFreq_finder(AUD_dataout, audInfo);
[dotInfo.cohFreq] = cohFreq_finder(VIS_dataout, dotInfo);
[AVInfo.cohFreq_aud, AVInfo.cohFreq_vis] = cohFreq_finder_AV(AV_dataout, AVInfo);

num_catch_trials=0;
total_trials=size(dataout,1)-1;
num_regular_trials=total_trials;

%[Fixation_Success_Rate, Stim_Success_Rate, Target_Success_Rate_Regular, Target_Success_Rate_Catch] = SR_CALC(dataout,total_trials,num_regular_trials,num_catch_trials)

%Break down of each success rate based on coherence level
%Count how many rew and N/A per coherence

prob_AUD = coherence_probability(AUD_dataout, audInfo)
prob_VIS = coherence_probability(VIS_dataout, dotInfo)
prob_AV = coherence_probability_AV(AV_dataout, AVInfo)

[AUD_Right_dataout, AUD_Left_dataout] = direction_splitter(AUD_dataout, 'AUD');
[VIS_Right_dataout, VIS_Left_dataout] = direction_splitter(VIS_dataout, 'VIS');
[AV_Right_dataout, AV_Left_dataout] = direction_splitter(AV_dataout, 'AV');

[audInfo.cohFreq_right] = cohFreq_finder(AUD_Right_dataout, audInfo);
[dotInfo.cohFreq_right] = cohFreq_finder(VIS_Right_dataout, dotInfo);
[audInfo.cohFreq_left] = cohFreq_finder(AUD_Left_dataout, audInfo);
[dotInfo.cohFreq_left] = cohFreq_finder(VIS_Left_dataout, dotInfo);
%Since its congruent AV, aud and vis should be same number of freq, just at
%different coherences for A and V lists
[AVInfo.cohFreq_right_aud, AVInfo.cohFreq_right_vis] = cohFreq_finder_AV(AV_Right_dataout, AVInfo);
[AVInfo.cohFreq_left_aud, AVInfo.cohFreq_left_vis] = cohFreq_finder_AV(AV_Left_dataout, AVInfo);

AUD_prob_Right = directional_probability(AUD_Right_dataout, audInfo, 'Right', 'AUD');
AUD_prob_Left = directional_probability(AUD_Left_dataout, audInfo, 'Left','AUD');
VIS_prob_Right = directional_probability(VIS_Right_dataout, dotInfo, 'Right','VIS');
VIS_prob_Left = directional_probability(VIS_Left_dataout, dotInfo, 'Left', 'VIS');
%These have indeces instead of cohs, 1:11 with probabilities
%corresponding to the A and V coh lists
AV_prob_Right = directional_probability_AV(AV_Right_dataout, AVInfo, 'Right');
AV_prob_Left = directional_probability_AV(AV_Left_dataout, AVInfo, 'Left');


[fig_3_AUD_VIS_AV,BF_AUD_VIS, BF_AUD_AV, BF_VIS_AV,AUD_mu,VIS_mu, AV_mu, AUD_std_cumulative_gaussian,VIS_std_cumulative_gaussian,AV_std_cumulative_gaussian,Results_MLE] = ...
    psychometric_plotter_modalities(AUD_prob_Right, AUD_prob_Left, ...
    VIS_prob_Right, VIS_prob_Left,...
    AV_prob_Right, AV_prob_Left,...
    audInfo, dotInfo, AVInfo, save_name);

aud_slope_at_50_percent = 1 / (AUD_std_cumulative_gaussian * sqrt(2 * pi))
vis_slope_at_50_percent = 1 / (VIS_std_cumulative_gaussian * sqrt(2 * pi))
AV_slope_at_50_percent = 1 / (AV_std_cumulative_gaussian * sqrt(2 * pi))

display_aud_mu = sprintf('AUD Mu: %.2f',AUD_mu);
disp(display_aud_mu)
display_aud_std = sprintf('AUD std of cumulative gaussian: %.2f',AUD_std_cumulative_gaussian);
disp(display_aud_std)
display_aud_slope_50_percent = sprintf('AUD slope at 50 percent: %.2f',aud_slope_at_50_percent);
disp(display_aud_slope_50_percent)
display_vis_mu = sprintf('VIS Mu: %.2f',VIS_mu);
disp(display_vis_mu)
display_vis_std = sprintf('VIS std of cumulative gaussian: %.2f',VIS_std_cumulative_gaussian);
disp(display_vis_std)
display_vis_slope_50_percent = sprintf('VIS slope at 50 percent: %.2f',vis_slope_at_50_percent);
disp(display_vis_slope_50_percent)
display_av_mu = sprintf('AV Mu: %.2f',AV_mu);
disp(display_av_mu)
display_av_std = sprintf('AV std of cumulative gaussian: %.2f',AV_std_cumulative_gaussian);
disp(display_av_std)
display_AV_slope_50_percent = sprintf('AV slope at 50 percent: %.2f',AV_slope_at_50_percent);
disp(display_AV_slope_50_percent)

AUD_prob_right_only = coherence_probability_1_direction(AUD_Right_dataout, audInfo,'Right','AUD');
AUD_prob_left_only = coherence_probability_1_direction(AUD_Left_dataout, audInfo,'Left','AUD');

VIS_prob_right_only = coherence_probability_1_direction(VIS_Right_dataout, dotInfo,'Right','VIS');
VIS_prob_left_only = coherence_probability_1_direction(VIS_Left_dataout, dotInfo,'Left','VIS');



%%Make Rightward only graph with AUD and VIS
[R_fig_AV] = psychometric_plotter_1_direction_modalities(AUD_prob_right_only,...
    VIS_prob_right_only,...
    AV_prob_Right, ...
    'RIGHT ONLY', audInfo, dotInfo, AVInfo, save_name);

%%Make Leftward only graph with AUD and VIS
[L_fig_AV] = psychometric_plotter_1_direction_modalities(AUD_prob_left_only,...
    VIS_prob_left_only,...
    AV_prob_Left, ...
    'LEFT ONLY', audInfo, dotInfo, AVInfo, save_name);


figure_file_directory=Path;
% %Save all figures to Figure Directory
% saveas(fig_3_AUD_VIS_AV, [figure_file_directory save_name '_Psyc_Func_LR_MMAV.png']);
% saveas(R_fig_AV, [figure_file_directory save_name '_Psyc_Func_R_MMAV.png']);
% saveas(L_fig_AV, [figure_file_directory save_name '_Psyc_Func_L_MMAV.png']);
% 



%save([Path save_name],'Results_MLE');
