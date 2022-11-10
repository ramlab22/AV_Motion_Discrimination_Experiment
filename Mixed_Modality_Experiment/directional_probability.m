function [prob] = directional_probability(directional_dataout, audInfo) 

coherence_rew_numbers = [audInfo.coherences;
        zeros(1,length(audInfo.coherences));
        zeros(1,length(audInfo.coherences))]; %Initilize top row(coherence lvls) and 2nd row(rew numbers) to zero, 3rd row(N/A trials)

    coherences = audInfo.coherences;

    for i_coherence = 1:length(coherences)
        for v = 1:length(directional_dataout(:,1))
            if directional_dataout{v,9} == 1 %Right Trial
                if (strcmp(directional_dataout{v,6},'Yes')) && (directional_dataout{v,8} == coherences(i_coherence))  && (strcmp(directional_dataout{v,5},'No')) %Target Reward & Not a Catch Trial
                    coherence_rew_numbers(2,i_coherence) = coherence_rew_numbers(2,i_coherence)+1;
                end
                if  (strcmp(directional_dataout{v,6},'N/A')) && (directional_dataout{v,8} == coherences(i_coherence)) && (strcmp(directional_dataout{v,5},'No')) %No chance for target reward & Not a catch trial
                    coherence_rew_numbers(3,i_coherence) = coherence_rew_numbers(3,i_coherence)+1;
                end
            elseif directional_dataout{v,9} == 0 %Left Trial
                if (strcmp(directional_dataout{v,6},'No')) && (directional_dataout{v,8} == coherences(i_coherence))  && (strcmp(directional_dataout{v,5},'No')) %Target Reward & Not a Catch Trial
                    coherence_rew_numbers(2,i_coherence) = coherence_rew_numbers(2,i_coherence)+1;
                end
                if  (strcmp(directional_dataout{v,6},'N/A')) && (directional_dataout{v,8} == coherences(i_coherence)) && (strcmp(directional_dataout{v,5},'No')) %No chance for target reward & Not a catch trial
                    coherence_rew_numbers(3,i_coherence) = coherence_rew_numbers(3,i_coherence)+1;
                end
            end
        end
    end


    coherence_success_rate = [audInfo.coherences;
        zeros(1,length(audInfo.coherences))]; %Initilize the top row, and percentages
    for c = 1:length(audInfo.coherences)
        coherence_success_rate(2,c) = coherence_rew_numbers(2,c)/((round(audInfo.cohFreq(c)/2))-coherence_rew_numbers(3,c));  %Subtract the trials where there was no chance for reward(N/A Target Correct)
    end

    % All of the Coherence Success Rates in Percentage, regular
    prob = [audInfo.coherences;
        coherence_success_rate(2,:)*100];

    prob = prob';
    
end