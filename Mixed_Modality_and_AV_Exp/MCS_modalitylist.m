function [ExpInfo] = MCS_modalitylist(ExpInfo, audInfo, dotInfo, AVInfo)

% creates a list of modalities, with the # of trials selected for each 
% modality, randomizes this list, and creates indices to find each 
% modality's trials within the master list

% Define the number of each type of trial
n_aud_trials = audInfo.n_aud_trials; 
n_vis_trials = dotInfo.n_vis_trials;  
n_AV_trials = AVInfo.n_AV_trials;   
n_totaltrials = ExpInfo.num_trials;

% Create the list
modality_trials = [repmat({'AUD'}, 1, n_aud_trials), ...
          repmat({'VIS'}, 1, n_vis_trials), ...
          repmat({'AV'}, 1, n_AV_trials)];
% Shuffle the list
ExpInfo.trial_modality_list = modality_trials(randperm(length(modality_trials)));

% Get the indices for each type of trial
ExpInfo.aud_trial_modality_list_idx = find(strcmp(ExpInfo.trial_modality_list, 'AUD'));
ExpInfo.vis_trial_modality_list_idx = find(strcmp(ExpInfo.trial_modality_list, 'VIS'));
ExpInfo.AV_trial_modality_list_idx = find(strcmp(ExpInfo.trial_modality_list, 'AV'));

end