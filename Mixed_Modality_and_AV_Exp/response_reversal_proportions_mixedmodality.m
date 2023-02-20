function [n_trials_with_response,n_trials_with_reward,proportion_response_reversals_after_correct_response,proportion_response_reversals_after_incorrect_response] = response_reversal_proportions_mixedmodality(dataout)
dataout_columnlabels=dataout(1,:);

motion_directions=cell2mat(dataout(2:end,9)); %get list of motion directions, righward=0, leftward=180
%motion_directions=audInfo.random_dir_list';
n_completedtrials=length(motion_directions);
completed_dataout=dataout(2:n_completedtrials+1,:);
response_accuracy=completed_dataout(:,6);
stim_modality=completed_dataout(:,11);

response_reversals_correct=0;
response_reversals_incorrect=0;
response_nonreversals_correct=0;
response_nonreversals_incorrect=0;
NaN_trials=0;
response_direction=nan(n_completedtrials,1); %direction of subject's responses

%get whether subject responded rightward (1) or leftward (0) on each trial
for i_trial = 1:n_completedtrials
    switch stim_modality{i_trial,1}
        case 'VIS'
            switch response_accuracy{i_trial,1}
                case 'Yes'
                    if motion_directions(i_trial,1) == 0
                        response_direction(i_trial,1) = 1;
                    end
                    if motion_directions(i_trial,1) == 180
                        response_direction(i_trial,1) = 0;
                    end

                case 'No'
                    if motion_directions(i_trial,1) == 0
                        response_direction(i_trial,1) = 0;
                    end
                    if motion_directions(i_trial,1) == 180
                        response_direction(i_trial,1) = 1;
                    end
            end %switch response accuracy
        case 'AUD'
            switch response_accuracy{i_trial,1}
                case 'Yes'
                    response_direction(i_trial,1) = motion_directions(i_trial,1);
                case 'No'
                    if motion_directions(i_trial,1) == 1
                        response_direction(i_trial,1) = 0;
                    end
                    if motion_directions(i_trial,1) == 0
                        response_direction(i_trial,1) = 1;
                    end
            end %switch response accuracy
        case 'AV'
            switch response_accuracy{i_trial,1}
                case 'Yes'
                    response_direction(i_trial,1) = motion_directions(i_trial,1);
                case 'No'
                    if motion_directions(i_trial,1) == 1
                        response_direction(i_trial,1) = 0;
                    end
                    if motion_directions(i_trial,1) == 0
                        response_direction(i_trial,1) = 1;
                    end
            end %switch response accuracy
    end % switch modality

end %for each completed trial

for j_trial = 1:(n_completedtrials-1)
    j_trial_response_accuracy=completed_dataout{j_trial,6};
    j_trial_response_direction=response_direction(j_trial,1);

    nexttrial_responsedirection=response_direction(j_trial+1,1);
    switch j_trial_response_accuracy
        case 'Yes'
            if j_trial_response_direction == nexttrial_responsedirection
                response_nonreversals_correct=response_nonreversals_correct+1;
            else
                response_reversals_correct=response_reversals_correct+1;
            end

        case 'No'
            if j_trial_response_direction == nexttrial_responsedirection
                response_nonreversals_incorrect=response_nonreversals_incorrect+1;
            else
                response_reversals_incorrect=response_reversals_incorrect+1;
            end

        case 'N/A'
            NaN_trials=NaN_trials+1;
    end
end
n_completedtrials
n_trials_with_response=response_reversals_correct+response_reversals_incorrect+response_nonreversals_correct+response_nonreversals_incorrect;
n_trials_with_reward=response_reversals_correct+response_nonreversals_correct;
proportion_response_reversals_after_correct_response=response_reversals_correct/(response_reversals_correct+response_nonreversals_correct);
proportion_response_reversals_after_incorrect_response=response_reversals_incorrect/(response_reversals_incorrect+response_nonreversals_incorrect);