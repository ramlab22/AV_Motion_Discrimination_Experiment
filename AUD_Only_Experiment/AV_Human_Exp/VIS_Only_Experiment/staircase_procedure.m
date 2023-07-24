function [dotInfo, staircase_index] = staircase_procedure(trial_status, dotInfo, staircase_index)

    %We need info from the last trial on weahter he got the trial correct
    if strcmp(trial_status, 'Correct')
        x_rand = rand(1); %random num between 0-1 
        if x_rand <= dotInfo.probs(1) %Prob of Coherence lowering 
            if staircase_index < length(dotInfo.cohSet) %Check to make sure we don't go lower than the lowest value possible
                staircase_index = staircase_index + 1; %Decrease the coherence
                dotInfo.coh = (dotInfo.cohSet(staircase_index)); 
            end
        end

        if x_rand <= dotInfo.probs(2) %Prob of direction change, after Correct 
            %Change Direction of the stimulus
            if dotInfo.dir == 0 
                dotInfo.dir = 180; 
            elseif dotInfo.dir == 180 
                dotInfo.dir = 0;
            end
        end
    elseif strcmp(trial_status, 'Incorrect')
        y_rand = rand(1); %random num between 0-1 
        if y_rand <= dotInfo.probs(3) %Prob of Coherence Increasing 
            if staircase_index > 1 %Check to make sure we don't go higher than highest value possible
                staircase_index = staircase_index - 1; %Increase the coherence
                dotInfo.coh = (dotInfo.cohSet(staircase_index)); 
            end
        end

        if y_rand <= dotInfo.probs(4) %Prob of direction change, after Incorrect
            %Change Direction of the stimulus
            if dotInfo.dir == 0 
                dotInfo.dir = 180; 
            elseif dotInfo.dir == 180 
                dotInfo.dir = 0;
            end
        end
    end
    
end