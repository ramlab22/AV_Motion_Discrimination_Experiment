function [prob] = coherence_probability_1_direction(dataout, dotInfo, direction, modality) 

coherence_rew_numbers = [dotInfo.coherences;
        zeros(1,length(dotInfo.coherences));
        zeros(1,length(dotInfo.coherences))]; %Initilize top row(coherence lvls) and 2nd row(rew numbers) to zero, 3rd row(N/A trials)

    coherences = dotInfo.coherences;

    for i_coherence = 1:length(coherences)
        for v = 1:length(dataout(:,1))
            if strcmp(modality, 'AUD')
                if dataout{v,9} == 1 %Right Trial
                    if (strcmp(dataout{v,6},'Yes')) && (dataout{v,8} == coherences(i_coherence))  && (strcmp(dataout{v,5},'No')) %Target Reward & Not a Catch Trial
                        coherence_rew_numbers(2,i_coherence) = coherence_rew_numbers(2,i_coherence)+1;
                    end
                    if  (strcmp(dataout{v,6},'N/A')) && (dataout{v,8} == coherences(i_coherence)) && (strcmp(dataout{v,5},'No')) %No chance for target reward & Not a catch trial
                        coherence_rew_numbers(3,i_coherence) = coherence_rew_numbers(3,i_coherence)+1;
                    end
                elseif dataout{v,9} == 0 %Left Trial
                    if (strcmp(dataout{v,6},'No')) && (dataout{v,8} == coherences(i_coherence))  && (strcmp(dataout{v,5},'No')) %Target Reward & Not a Catch Trial
                        coherence_rew_numbers(2,i_coherence) = coherence_rew_numbers(2,i_coherence)+1;
                    end
                    if  (strcmp(dataout{v,6},'N/A')) && (dataout{v,8} == coherences(i_coherence)) && (strcmp(dataout{v,5},'No')) %No chance for target reward & Not a catch trial
                        coherence_rew_numbers(3,i_coherence) = coherence_rew_numbers(3,i_coherence)+1;
                    end
                end
            elseif strcmp(modality, 'VIS')
                if dataout{v,9} == 0 %Right Trial
                    if (strcmp(dataout{v,6},'Yes')) && (dataout{v,8} == coherences(i_coherence))  && (strcmp(dataout{v,5},'No')) %Target Reward & Not a Catch Trial
                        coherence_rew_numbers(2,i_coherence) = coherence_rew_numbers(2,i_coherence)+1;
                    end
                    if  (strcmp(dataout{v,6},'N/A')) && (dataout{v,8} == coherences(i_coherence)) && (strcmp(dataout{v,5},'No')) %No chance for target reward & Not a catch trial
                        coherence_rew_numbers(3,i_coherence) = coherence_rew_numbers(3,i_coherence)+1;
                    end
                elseif dataout{v,9} == 180 %Left Trial
                    if (strcmp(dataout{v,6},'No')) && (dataout{v,8} == coherences(i_coherence))  && (strcmp(dataout{v,5},'No')) %Target Reward & Not a Catch Trial
                        coherence_rew_numbers(2,i_coherence) = coherence_rew_numbers(2,i_coherence)+1;
                    end
                    if  (strcmp(dataout{v,6},'N/A')) && (dataout{v,8} == coherences(i_coherence)) && (strcmp(dataout{v,5},'No')) %No chance for target reward & Not a catch trial
                        coherence_rew_numbers(3,i_coherence) = coherence_rew_numbers(3,i_coherence)+1;
                    end
                end
            end
        end
    end


    coherence_success_rate = [dotInfo.coherences;
        zeros(1,length(dotInfo.coherences))]; %Initilize the top row, and percentages
    

    if strcmp(direction, "Right") %Right
        for c = 1:length(dotInfo.coherences)
            coherence_success_rate(2,c) = coherence_rew_numbers(2,c)/((dotInfo.cohFreq_right(2,c))-(coherence_rew_numbers(3,c)));  %Subtract the trials where there was no chance for reward(N/A Target Correct)
        end
    elseif strcmp(direction, "Left") %Left
        for c = 1:length(dotInfo.coherences)
            coherence_success_rate(2,c) = coherence_rew_numbers(2,c)/((dotInfo.cohFreq_left(2,c))-(coherence_rew_numbers(3,c)));  %Subtract the trials where there was no chance for reward(N/A Target Correct)
        end
    end
    
    % All of the Coherence Success Rates in Percentage, regular
    prob = [dotInfo.coherences;
        coherence_success_rate(2,:)*100];

    prob = prob';
end