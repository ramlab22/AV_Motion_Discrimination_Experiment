function [prob] = coherence_probability(dataout, audInfo) 
%   Get the probabillity of Righward Response given the amount of rewards given and coherences presented

coherence_rew_numbers = [audInfo.coherences;
        zeros(1,length(audInfo.coherences));
        zeros(1,length(audInfo.coherences))]; %Initilize top row(coherence lvls) and 2nd row(rew numbers) to zero, 3rd row(N/A trials)

    coherences = audInfo.coherences;

    for i_coherence = 1:length(coherences)
        for v = 1:length(dataout(:,1))
            if (strcmp(dataout{v,6},'Yes')) && (dataout{v,8} == coherences(i_coherence))  && (strcmp(dataout{v,5},'No')) %Target Reward & Not a Catch Trial
                coherence_rew_numbers(2,i_coherence) = coherence_rew_numbers(2,i_coherence)+1;
            end
            if  (strcmp(dataout{v,6},'N/A')) && (dataout{v,8} == coherences(i_coherence)) && (strcmp(dataout{v,5},'No')) %No chance for target reward & Not a catch trial
                coherence_rew_numbers(3,i_coherence) = coherence_rew_numbers(3,i_coherence)+1;
            end
        end
    end


    coherence_success_rate = [audInfo.coherences;
        zeros(1,length(audInfo.coherences))]; %Initilize the top row, and percentages
    for c = 1:length(audInfo.coherences)
        coherence_success_rate(2,c) = coherence_rew_numbers(2,c)/(audInfo.cohFreq(2,c)-coherence_rew_numbers(3,c));  %Subtract the trials where there was no chance for reward(N/A Target Correct)
    end

    % All of the Coherence Success Rates in Percentage, regular
    prob = [audInfo.coherences;
        coherence_success_rate(2,:)*100;
        audInfo.cohFreq];

    prob = prob';
end