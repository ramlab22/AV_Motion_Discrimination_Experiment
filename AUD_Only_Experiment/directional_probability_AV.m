function [prob] = directional_probability_AV(directional_dataout, AVInfo, direction)

coherence_rew_numbers = [AVInfo.coherences_aud;
    AVInfo.coherences_dot;
    zeros(1,length(AVInfo.coherences_aud));
    zeros(1,length(AVInfo.coherences_aud))];
%Initilize top row(coherence lvls) and 2nd row(rew numbers) to zero, 3rd row(N/A trials)

coherences = AVInfo.coherences_aud;

for i_coherence = 1:length(coherences)
    for v = 1:length(directional_dataout(:,1))
        if directional_dataout{v,9} == 1 %Right Trial
            if (strcmp(directional_dataout{v,6},'Yes')) && (directional_dataout{v,8}(1) == coherences(i_coherence))  && (strcmp(directional_dataout{v,5},'No')) %Target Reward & Not a Catch Trial
                coherence_rew_numbers(3,i_coherence) = coherence_rew_numbers(3,i_coherence)+1;
            end
            if  (strcmp(directional_dataout{v,6},'N/A')) && (directional_dataout{v,8}(1) == coherences(i_coherence)) && (strcmp(directional_dataout{v,5},'No')) %No chance for target reward & Not a catch trial
                coherence_rew_numbers(4,i_coherence) = coherence_rew_numbers(4,i_coherence)+1;
            end
        elseif directional_dataout{v,9} == 0 %Left Trial
            if (strcmp(directional_dataout{v,6},'No')) && (directional_dataout{v,8}(1) == coherences(i_coherence))  && (strcmp(directional_dataout{v,5},'No')) %Target Reward & Not a Catch Trial
                coherence_rew_numbers(3,i_coherence) = coherence_rew_numbers(3,i_coherence)+1;
            end
            if  (strcmp(directional_dataout{v,6},'N/A')) && (directional_dataout{v,8}(1) == coherences(i_coherence)) && (strcmp(directional_dataout{v,5},'No')) %No chance for target reward & Not a catch trial
                coherence_rew_numbers(4,i_coherence) = coherence_rew_numbers(4,i_coherence)+1;
            end
        end

    end
end

%Initilize the top row, and percentages
coherence_success_rate = [AVInfo.coherences_aud;
                            AVInfo.coherences_dot;
                            zeros(1,length(AVInfo.coherences_aud))]; 

if strcmp(direction, "Right")
    for c = 1:length(AVInfo.coherences_aud)
        coherence_success_rate(3,c) = coherence_rew_numbers(3,c)/((AVInfo.cohFreq_right_aud(2,c))-(coherence_rew_numbers(4,c)));  %Subtract the trials where there was no chance for reward(N/A Target Correct)
    end
elseif strcmp(direction, "Left")
    for c = 1:length(AVInfo.coherences_aud)
        coherence_success_rate(3,c) = coherence_rew_numbers(3,c)/((AVInfo.cohFreq_left_aud(2,c))-(coherence_rew_numbers(4,c)));  %Subtract the trials where there was no chance for reward(N/A Target Correct)
    end
end
% All of the Coherence Success Rates in Percentage, regular
prob = [1:length(coherence_success_rate(1,:));
    coherence_success_rate(3,:)*100];

prob = prob';

end