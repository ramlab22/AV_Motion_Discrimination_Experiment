function [trialInfo, staircase_index_dot, staircase_index_aud, dotInfo, audInfo] = staircase_procedure(ExpInfo, trial_status, trialInfo, staircase_index_aud, staircase_index_dot, audInfo, dotInfo)

    %We need info from the last trial on weather he got the trial correct
        if strcmp(trial_status, 'Correct')
            x_rand = rand(1); %random num between 0-1 
            
            if x_rand <= ExpInfo.probs(5) %Prob of modality switch
                if strcmp(trialInfo.modality, 'VIS')
                    trialInfo.modality = 'AUD';

                elseif strcmp(trialInfo.modality, 'AUD')
                    trialInfo.modality = 'VIS';

                end
            end
        
            if x_rand <= ExpInfo.probs(1) %Prob of Coherence lowering 
                if strcmp(trialInfo.modality, 'VIS')
                    if staircase_index_dot < length(dotInfo.cohSet) %Check to make sure we don't go lower than the lowest value possible
                        staircase_index_dot = staircase_index_dot + 1; %Decrease the coherence
                        dotInfo.coh = (dotInfo.cohSet(staircase_index_dot)); 
                    end
                elseif strcmp(trialInfo.modality, 'AUD')
                    if staircase_index_aud < length(audInfo.cohSet) %Check to make sure we don't go lower than the lowest value possible
                        staircase_index_aud = staircase_index_aud + 1; %Decrease the coherence
                        audInfo.coh = (audInfo.cohSet(staircase_index_aud)); 
                    end
                end
            end

            if x_rand <= ExpInfo.probs(2) %Prob of direction change, after Correct 
                if strcmp(trialInfo.modality, 'AUD')
                    %Change Direction of the AUD stimulus
                    if audInfo.dir == 1 %Right
                        audInfo.dir = 0; 
                    elseif audInfo.dir == 0 %Left
                        audInfo.dir = 1;
                    end
                elseif strcmp(trialInfo.modality, 'VIS')
                    %Change Direction of the VIS stimulus
                    if dotInfo.dir == 0 %Right
                        dotInfo.dir = 180; 
                    elseif dotInfo.dir == 180 %Left
                        dotInfo.dir = 0;
                    end
                end
            end

            

        elseif strcmp(trial_status, 'Incorrect')
            y_rand = rand(1); %random num between 0-1 
            
            if y_rand <= ExpInfo.probs(6) %Prob of modality switch
                if strcmp(trialInfo.modality, 'VIS')
                    trialInfo.modality = 'AUD';
%                     %Make sure that direction is for AUD
%                     if trialInfo.dir == 0 %VIS Right 
%                         trialInfo.dir = 1; %AUD Right
%                     elseif trialInfo.dir == 180 %VIS Left
%                         trialInfo.dir = 0; %AUD Left
%                     end
                elseif strcmp(trialInfo.modality, 'AUD')
                    trialInfo.modality = 'VIS';
                    %Make sure that direction is for VIS
%                     if trialInfo.dir == 1 %AUD Right 
%                         trialInfo.dir = 0; %VIS Right
%                     elseif trialInfo.dir == 0 %AUD Left
%                         trialInfo.dir = 180; %VIS Left
%                     end
                end
            end

            if y_rand <= ExpInfo.probs(3) %Prob of Coherence Increasing, after Incorrect
                if strcmp(trialInfo.modality, 'VIS')
                    if staircase_index_dot > 1 %Check to make sure we don't go higher than the highest value possible
                        staircase_index_dot = staircase_index_dot - 1; %Increase the coherence
                        dotInfo.coh = (dotInfo.cohSet(staircase_index_dot)); 
                    end
                elseif strcmp(trialInfo.modality, 'AUD')
                    if staircase_index_aud > 1 %Check to make sure we don't go higher than the highest value possible
                        staircase_index_aud = staircase_index_aud - 1; %Increase the coherence
                        audInfo.coh = (audInfo.cohSet(staircase_index_aud)); 
                    end
                end
            end

            if y_rand <= ExpInfo.probs(4) %Prob of direction change, after Incorrect
                if strcmp(trialInfo.modality, 'AUD')
                    %Change Direction of the AUD stimulus
                    if audInfo.dir == 1 %Right
                        audInfo.dir = 0; 
                    elseif audInfo.dir == 0 %Left
                        audInfo.dir = 1;
                    end
                elseif strcmp(trialInfo.modality, 'VIS')
                    %Change Direction of the VIS stimulus
                    if dotInfo.dir == 0 %Right
                        dotInfo.dir = 180; 
                    elseif dotInfo.dir == 180 %Left
                        dotInfo.dir = 0;
                    end
                end
            end


        end


end