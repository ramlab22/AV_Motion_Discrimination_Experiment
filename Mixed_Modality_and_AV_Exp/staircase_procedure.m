function [ExpInfo,staircase_index_dot, staircase_index_aud, staircase_index_av, dotInfo, audInfo, AVInfo] = staircase_procedure(ExpInfo, trial_status,  staircase_index_aud, staircase_index_dot, staircase_index_av, audInfo, dotInfo, AVInfo)

%We need info from the last trial on weather he got the trial correct
if strcmp(trial_status, 'Correct')
    x_rand = rand(1); %random num between 0-1

    if x_rand <= ExpInfo.probs(1) %Prob of Coherence lowering
        if strcmp(ExpInfo.modality, 'VIS')
            if staircase_index_dot < length(dotInfo.cohSet) %Check to make sure we don't go lower than the lowest value possible
                staircase_index_dot = staircase_index_dot + 1; %Decrease the coherence
                dotInfo.coh = (dotInfo.cohSet(staircase_index_dot));
            end
        elseif strcmp(ExpInfo.modality, 'AUD')
            if staircase_index_aud < length(audInfo.cohSet) %Check to make sure we don't go lower than the lowest value possible
                staircase_index_aud = staircase_index_aud + 1; %Decrease the coherence
                audInfo.coh = (audInfo.cohSet(staircase_index_aud));
            end
        elseif strcmp(ExpInfo.modality, 'AV')
            if (staircase_index_av < length(AVInfo.cohSet_dot)) || (staircase_index_av < length(AVInfo.cohSet_aud))%Check to make sure we don't go lower than the lowest value possible
                staircase_index_av = staircase_index_av + 1; %Decrease the coherence
                AVInfo.coh_dot = (AVInfo.cohSet_dot(staircase_index_av));
                AVInfo.coh_aud = (AVInfo.cohSet_aud(staircase_index_av));
            end
        end
    end


    if x_rand <= ExpInfo.probs(2) %Prob of direction change, after Correct
        if strcmp(ExpInfo.modality, 'AUD')
            %Change Direction of the AUD stimulus
            if audInfo.dir == 1 %Right
                audInfo.dir = 0;
            elseif audInfo.dir == 0 %Left
                audInfo.dir = 1;
            end
        elseif strcmp(ExpInfo.modality, 'VIS')
            %Change Direction of the VIS stimulus
            if dotInfo.dir == 0 %Right
                dotInfo.dir = 180;
            elseif dotInfo.dir == 180 %Left
                dotInfo.dir = 0;
            end
        elseif strcmp(ExpInfo.modality, 'AV')
            %Change Direction of the AV stimulus
            if AVInfo.dir == 1 %Right
                AVInfo.dir = 0;
            elseif AVInfo.dir == 0 %Left
                AVInfo.dir = 1;
            end
        end
    end

    if x_rand <= ExpInfo.probs(5) %Prob of modality switch, equal chance for each choice
        if strcmp(ExpInfo.modality, 'VIS')
            num = randi([0,1]);
            if num == 1
                ExpInfo.modality = 'AUD';
            elseif num == 0
                ExpInfo.modality = 'AV';
            end
        elseif strcmp(ExpInfo.modality, 'AUD')
            num = randi([0,1]);
            if num == 1
                ExpInfo.modality = 'VIS';
            elseif num == 0
                ExpInfo.modality = 'AV';
            end
        elseif strcmp(ExpInfo.modality, 'AV')
            num = randi([0,1]);
            if num == 1
                ExpInfo.modality = 'VIS';
            elseif num == 0
                ExpInfo.modality = 'AUD';
            end
        end
    end


elseif strcmp(trial_status, 'Incorrect')
    y_rand = rand(1); %random num between 0-1

    if y_rand <= ExpInfo.probs(3) %Prob of Coherence Increasing, after Incorrect
        if strcmp(ExpInfo.modality, 'VIS')
            if staircase_index_dot > 1 %Check to make sure we don't go higher than the highest value possible
                staircase_index_dot = staircase_index_dot - 1; %Increase the coherence
                dotInfo.coh = (dotInfo.cohSet(staircase_index_dot));
            end
        elseif strcmp(ExpInfo.modality, 'AUD')
            if staircase_index_aud > 1 %Check to make sure we don't go higher than the highest value possible
                staircase_index_aud = staircase_index_aud - 1; %Increase the coherence
                audInfo.coh = (audInfo.cohSet(staircase_index_aud));
            end
        elseif strcmp(ExpInfo.modality, 'AV')
            if (staircase_index_av > 1) %Check to make sure we don't go lower than the lowest value possible
                staircase_index_av = staircase_index_av - 1; %Decrease the coherence
                AVInfo.coh_dot = (AVInfo.cohSet_dot(staircase_index_av));
                AVInfo.coh_aud = (AVInfo.cohSet_aud(staircase_index_av));
            end
        end
    end

    if y_rand <= ExpInfo.probs(4) %Prob of direction change, after Incorrect
        if strcmp(ExpInfo.modality, 'AUD')
            %Change Direction of the AUD stimulus
            if audInfo.dir == 1 %Right
                audInfo.dir = 0;
            elseif audInfo.dir == 0 %Left
                audInfo.dir = 1;
            end
        elseif strcmp(ExpInfo.modality, 'VIS')
            %Change Direction of the VIS stimulus
            if dotInfo.dir == 0 %Right
                dotInfo.dir = 180;
            elseif dotInfo.dir == 180 %Left
                dotInfo.dir = 0;
            end
        elseif strcmp(ExpInfo.modality, 'AV')
            %Change Direction of the AV stimulus
            if AVInfo.dir == 1 %Right
                AVInfo.dir = 0;
            elseif AVInfo.dir == 0 %Left
                AVInfo.dir = 1;
            end
        end
    end

    if y_rand <= ExpInfo.probs(6) %Prob of modality switch
        if strcmp(ExpInfo.modality, 'VIS')
            num = randi([0,1]);
            if num == 1
                ExpInfo.modality = 'AUD';
            elseif num == 0
                ExpInfo.modality = 'AV';
            end
        elseif strcmp(ExpInfo.modality, 'AUD')
            num = randi([0,1]);
            if num == 1
                ExpInfo.modality = 'VIS';
            elseif num == 0
                ExpInfo.modality = 'AV';
            end
        elseif strcmp(ExpInfo.modality, 'AV')
            num = randi([0,1]);
            if num == 1
                ExpInfo.modality = 'VIS';
            elseif num == 0
                ExpInfo.modality = 'AUD';
            end
        end
    end

end


end