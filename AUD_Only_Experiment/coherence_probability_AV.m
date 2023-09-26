function [prob] = coherence_probability_AV(AV_dataout, AVInfo) 
%Initilize top row(AUD coherence lvls) , 2nd row (dot coherence levels), 3rd row(rew numbers) to zero, 4th row(N/A trials)
coherence_rew_numbers = [AVInfo.coherences_aud;
                            AVInfo.coherences_dot;
                            zeros(1,length(AVInfo.coherences_aud));
                            zeros(1,length(AVInfo.coherences_aud))]; 


    coherences_aud = AVInfo.coherences_aud;
    coherences_dot = AVInfo.coherences_dot;
    
    %AUD section of AV, AV_dataout{v,8}(1), Really only need to count this
    %because if you got AUD correct you got VIS correct, these are
    %congruent(same direction) trials
    for i_coherence_aud = 1:length(coherences_aud)
        for v = 1:length(AV_dataout(:,1))
            if (strcmp(AV_dataout{v,6},'Yes')) && ...
               (AV_dataout{v,8}(1) == coherences_aud(i_coherence_aud)) && ...
               (strcmp(AV_dataout{v,5},'No')) %Target Reward & Not a Catch Trial

                    coherence_rew_numbers(3,i_coherence_aud) = coherence_rew_numbers(3,i_coherence_aud)+1;
            end
            if  (strcmp(AV_dataout{v,6},'N/A')) && ....
                (AV_dataout{v,8}(1) == coherences_aud(i_coherence_aud)) && ...
                (strcmp(AV_dataout{v,5},'No')) %No chance for target reward & Not a catch trial

                    coherence_rew_numbers(4,i_coherence_aud) = coherence_rew_numbers(4,i_coherence_aud)+1;
            end
        end
    end


    coherence_success_rate = [AVInfo.coherences_aud;
                                AVInfo.coherences_dot;
                                zeros(1,length(AVInfo.coherences_aud))]; %Initilize the top 2 rows, and percentages
   
    for c = 1:length(AVInfo.coherences_aud)
        coherence_success_rate(3,c) = ...
            coherence_rew_numbers(3,c)/((AVInfo.cohFreq_aud(2,c)-coherence_rew_numbers(4,c)));  
        %Subtract the trials where there was no chance for reward(N/A Target Correct)
    end

    % All of the Coherence Success Rates in Percentage, 
    % 1:11 is the index for coherence list for both A and V 
    prob = [1:length(coherence_success_rate(1,:));
            coherence_success_rate(3,:)*100;
            1:length(coherence_success_rate(1,:));
            AVInfo.cohFreq_aud(2,:)];

    prob = prob';
end