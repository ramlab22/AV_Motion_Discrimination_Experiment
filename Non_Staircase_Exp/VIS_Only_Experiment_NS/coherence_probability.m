function [prob] = coherence_probability(dataout, dotInfo) 

coherence_rew_numbers = [dotInfo.coherences;
        zeros(1,length(dotInfo.coherences));
        zeros(1,length(dotInfo.coherences))]; %Initilize top row(coherence lvls) and 2nd row(rew numbers) to zero, 3rd row(N/A trials)

    coherences = dotInfo.coherences;

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


    coherence_success_rate = [dotInfo.coherences;
        zeros(1,length(dotInfo.coherences))]; %Initilize the top row, and percentages
    for c = 1:length(dotInfo.coherences)
        coherence_success_rate(2,c) = coherence_rew_numbers(2,c)/(dotInfo.cohFreq(2,c)-coherence_rew_numbers(3,c));  %Subtract the trials where there was no chance for reward(N/A Target Correct)
    end

    % All of the Coherence Success Rates in Percentage, regular
    prob = [dotInfo.coherences;
        coherence_success_rate(2,:)*100;
        dotInfo.cohFreq];

    prob = prob';
end