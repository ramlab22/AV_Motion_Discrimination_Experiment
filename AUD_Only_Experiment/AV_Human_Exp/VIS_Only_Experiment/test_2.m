function [prob] = directional_probablity(direction) 

coherence_rew_numbers = [0 0.2 0.4 0.6 0.8 1;
                             0 0 0 0 0 0;
                             0 0 0 0 0 0]; %Initilize top row(coherence lvls) and 2nd row(rew numbers) to zero, 3rd row(N/A trials)
    coherences=[0 0.2 0.4 0.6 0.8 1];

    for i_coherence = 1:length(coherences)
       for v = 1:length(direction)
           if (strcmp(direction{v,6},'Yes')) && (direction{v,8} == coherences(i_coherence))  && (strcmp(direction{v,5},'No'))
                coherence_rew_numbers(2,i_coherence) = coherence_rew_numbers(2,i_coherence)+1;
           end
           if  (strcmp(direction{v,6},'N/A')) && (direction{v,8} == coherences(i_coherence)) && (strcmp(direction{v,5},'No'))
               coherence_rew_numbers(3,i_coherence) = coherence_rew_numbers(3,i_coherence)+1;
           end
       end
    end
    
    
    coherence_success_rate = [0 0.2 0.4 0.6 0.8 1;
                              0 0 0 0 0 0]; %Initilize the top row, and percentages
    for c = 1:6
       coherence_success_rate(2,c) = coherence_rew_numbers(2,c)/(dotInfo.cohFreq(c)-coherence_rew_numbers(3,c));  %Subtract the trials where there was no chance for reward(N/A Target Correct)  
    end
    
    % All of the Coherence Success Rates in Percentage, regular  
    p_0 = coherence_success_rate(2,1)*100;
    p_20 = coherence_success_rate(2,2)*100;
    p_40 = coherence_success_rate(2,3)*100;
    p_60 = coherence_success_rate(2,4)*100;
    p_80 = coherence_success_rate(2,5)*100;
    p_100 = coherence_success_rate(2,6)*100;
    
    prob = [0 0.2 0.4 0.6 0.8 1;
        p_0 p_20 p_40 p_60 p_80 p_100];
    prob = prob'; 
    
end