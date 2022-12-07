function [] = response_reversal_proportions(dataout)
dataout_columnlabels=dataout(1,:);

motion_directions=cell2mat(dataout(2:end,9)); %get list of motion directions, righward=1, leftward=0
n_completedtrials=length(motion_directions);
completed_dataout=dataout(2:n_completedtrials+1,:);
response_accuracy=completed_dataout(:,6);

response_reversals_correct=0;
response_reversals_incorrect=0;
response_nonreversals_correct=0;
response_nonreversals_incorrect=0;
NaN_trials=0;
response_direction=nan(n_completedtrials,1); %direction of subject's responses

%get whether subject responded rightward (1) or leftward (0) on each trial
for i_trial = 1:n_completedtrials
    if motion_directions(i_trial,1) == 1 & response_accuracy{i_trial,1}(2) == 'e'
        response_direction(i_trial,1) = 1;
    end
    if motion_directions(i_trial,1) == 1 & response_accuracy{i_trial,1}(2) == 'o'
        response_direction(i_trial,1) = 0;
    end
    if motion_directions(i_trial,1) == 0 & response_accuracy{i_trial,1}(2) == 'e'
        response_direction(i_trial,1) = 0;
    end
    if motion_directions(i_trial,1) == 0 & response_accuracy{i_trial,1}(2) == 'o'
        response_direction(i_trial,1) = 1;
    end
end

for j_trial = 2:n_completedtrials
    j_trial_response_accuracy=completed_dataout{j_trial,6};
    j_trial_response_direction=response_direction(j_trial,1);
    
    previoustrial_responseaccuracy=completed_dataout{j_trial-1,6};
    previoustrial_responsedirection=response_direction(j_trial-1,1);
    switch previoustrial_responseaccuracy
        case 'Yes'
            if j_trial_response_direction == previoustrial_responsedirection
                response_nonreversals_correct=response_nonreversals_correct+1;
            else
                response_reversals_correct=response_reversals_correct+1;
            end
            
        case 'No'
            if j_trial_response_direction == previoustrial_responsedirection
                response_nonreversals_incorrect=response_nonreversals_incorrect+1;
            else
                response_reversals_incorrect=response_reversals_incorrect+1;
            end
            
        case 'N/A'
            NaN_trials=NaN_trials+1;
    end
end
n_completedtrials
NaN_trials
n_trials_with_response=response_reversals_correct+response_reversals_incorrect+response_nonreversals_correct+response_nonreversals_incorrect
proportion_response_reversals_after_correct_response=response_reversals_correct/(response_reversals_correct+response_nonreversals_correct)
proportion_response_reversals_after_incorrect_response=response_reversals_incorrect/(response_reversals_incorrect+response_nonreversals_incorrect)