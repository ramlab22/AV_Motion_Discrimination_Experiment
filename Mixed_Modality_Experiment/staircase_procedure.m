function [trialInfo, staircase_index] = staircase_procedure(ExpInfo, trial_status, trialInfo, staircase_index)

    %We need info from the last trial on weahter he got the trial correct
        if strcmp(trial_status, 'Correct')
            x_rand = rand(1); %random num between 0-1 
            if x_rand <= ExpInfo.probs(1) %Prob of Coherence lowering 
                if staircase_index < length(trialInfo.cohSet) %Check to make sure we don't go lower than the lowest value possible
                    staircase_index = staircase_index + 1; %Decrease the coherence
                    trialInfo.coh = (trialInfo.cohSet(staircase_index)); 
                end
            end

            if x_rand <= ExpInfo.probs(2) %Prob of direction change, after Correct 
                if strcmp(trialInfo.modality, 'AUD')
                    %Change Direction of the AUD stimulus
                    if trialInfo.dir == 1 
                        trialInfo.dir = 0; 
                    elseif trialInfo.dir == 0 
                        trialInfo.dir = 1;
                    end
                elseif strcmp(trialInfo.modality, 'VIS')
                    %Change Direction of the VIS stimulus
                    if trialInfo.dir == 0 
                        trialInfo.dir = 180; 
                    elseif trialInfo.dir == 180 
                        trialInfo.dir = 0;
                    end
                end
            end

            if x_rand <= ExpInfo.prob(5) %Prob of modality switch
                if strcmp(trialInfo.modality, 'VIS')
                    triaInfo.modality = 'AUD';
                elseif strcmp(trialInfo.modality, 'AUD')
                    triaInfo.modality = 'VIS'
                end
            end

        elseif strcmp(trial_status, 'Incorrect')
            y_rand = rand(1); %random num between 0-1 
            if y_rand <= ExpInfo.probs(3) %Prob of Coherence Increasing 
                if staircase_index > 1 %Check to make sure we don't go higher than highest value possible
                    staircase_index = staircase_index - 1; %Increase the coherence
                    trialInfo.coh = (trialInfo.cohSet(staircase_index)); 
                end
            end

            if y_rand <= ExpInfo.probs(4) %Prob of direction change, after Incorrect
                if strcmp(trialInfo.modality, 'AUD')
                    %Change Direction of the AUD stimulus
                    if trialInfo.dir == 1 
                        trialInfo.dir = 0; 
                    elseif trialInfo.dir == 0 
                        trialInfo.dir = 1;
                    end
                elseif strcmp(trialInfo.modality, 'VIS')
                    %Change Direction of the VIS stimulus
                    if trialInfo.dir == 0 
                        trialInfo.dir = 180; 
                    elseif trialInfo.dir == 180 
                        trialInfo.dir = 0;
                    end
                end
            end

            if x_rand <= ExpInfo.prob(6) %Prob of modality switch
                if strcmp(trialInfo.modality, 'VIS')
                    triaInfo.modality = 'AUD';
                elseif strcmp(trialInfo.modality, 'AUD')
                    triaInfo.modality = 'VIS'
                end
            end
        end


end