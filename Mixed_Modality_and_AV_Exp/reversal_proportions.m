function [] = reversal_proportions(dataout)
    numeric_cells=dataout(2:end,9);
    motion_directions=cell2mat(numeric_cells); %get list of motion directions, righward=1, leftward=0
    n_completedtrials=length(motion_directions);
    reversals_correct=0;
    reversals_incorrect=0;
    nonreversals_correct=0;
    nonreversals_incorrect=0;
    NaN_trials=0;
    for i_trial = 1:n_completedtrials
        response=dataout{i_trial+1,6};
        if i_trial<n_completedtrials
            i_trial_motiondirection=motion_directions(i_trial,1);
            nexttrial_motiondirection=motion_directions(i_trial+1,1);
            switch response
                case 'Yes'
                    if i_trial_motiondirection == nexttrial_motiondirection
                        nonreversals_correct=nonreversals_correct+1;
                    else
                        reversals_correct=reversals_correct+1;
                    end
                case 'No'
                    if i_trial_motiondirection == nexttrial_motiondirection
                        nonreversals_incorrect=nonreversals_incorrect+1;
                    else
                        reversals_incorrect=reversals_incorrect+1;
                    end
    
                case 'N/A'
                    NaN_trials=NaN_trials+1;
            end
        end 
    end
    disp(n_completedtrials)
    disp(NaN_trials+reversals_correct+reversals_incorrect+nonreversals_correct+nonreversals_incorrect)
    n_trials_with_response=reversals_correct+reversals_incorrect+nonreversals_correct+nonreversals_incorrect
    proportion_reversals_correct=reversals_correct/(reversals_correct+nonreversals_correct)
    proportion_reversals_incorrect=reversals_incorrect/(reversals_incorrect+nonreversals_incorrect)