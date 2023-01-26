function [ExpInfo, staircase_index, dotInfo, audInfo] = staircase_procedure(ExpInfo, trial_status, staircase_index, audInfo, dotInfo)

    %We need info from the last trial on weather he got the trial correct
    if strcmp(trial_status, 'Correct')
        x_rand = rand(1); %random num between 0-1
    
    
    
        if x_rand <= ExpInfo.probs(1) %Prob of Coherence lowering
            if staircase_index < length(ExpInfo.cohSet) %Check to make sure we don't go lower than the lowest value possible
                staircase_index = staircase_index + 1; %Decrease the coherence
                audInfo.coh = (audInfo.cohSet(staircase_index));
                dotInfo.coh = (dotInfo.cohSet(staircase_index));
            end
    
        end
    
        if x_rand <= ExpInfo.probs(2) %Prob of direction change, after Correct
            %Change Direction of the AV stimulus
            if audInfo.dir == 1 && dotInfo.dir == 0 %Right
                audInfo.dir = 0;
                dotInfo.dir = 180;
            elseif audInfo.dir == 0 && dotInfo.dir == 180 %Left
                audInfo.dir = 1;
                dotInfo.dir = 0;
            end
    
        end
    
    
    
    elseif strcmp(trial_status, 'Incorrect')
        y_rand = rand(1); %random num between 0-1
    
    
        if y_rand <= ExpInfo.probs(3) %Prob of Coherence Increasing, after Incorrect
    
            if staircase_index > 1 %Check to make sure we don't go higher than the highest value possible
                staircase_index = staircase_index - 1; %Increase the coherence
                audInfo.coh = (audInfo.cohSet(staircase_index));
                dotInfo.coh = (dotInfo.cohSet(staircase_index));
            end
    
        end
    
        if y_rand <= ExpInfo.probs(4) %Prob of direction change, after Incorrect
    
            %Change Direction of the AV stimulus
            if audInfo.dir == 1 && dotInfo.dir == 0 %Right
                audInfo.dir = 0;
                dotInfo.dir = 180;
            elseif audInfo.dir == 0 && dotInfo.dir == 180 %Left
                audInfo.dir = 1;
                dotInfo.dir = 0;
            end
    
        end
    
    
    end


end