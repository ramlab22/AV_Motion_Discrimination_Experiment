function [Fixation_Success_Rate, RDK_Success_Rate, Target_Success_Rate_Regular, Target_Success_Rate_Catch] = SR_CALC(dataout,total_trials,num_regular_trials,num_catch_trials)
    %Count all of the fixation rewards given and divde by total trials to get a Fixation Success Rate 
    fix_rew = zeros(1,total_trials); 
    for j = 2:total_trials+1
        if strcmp(dataout{j,3},'Yes')
            fix_rew(j-1) = 1;
        end
    end
    Fixation_Success_Rate = sum(fix_rew)/total_trials; 

    %Count all of the RDK rewards given and divde by total trials to get a RDK Success Rate    
    rdk_rew = zeros(1,total_trials); 
    for h = 2:total_trials+1
        if strcmp(dataout{h,4},'Yes')
            rdk_rew(h-1) = 1;
        end
    end
    RDK_Success_Rate = sum(rdk_rew)/total_trials;

    %Count all of the target rewards given and divde by total trials to get a Target Success Rate 
    targ_rew_regular = zeros(1,num_regular_trials); 
    targ_rew_catch = zeros(1,num_catch_trials); 
    for k = 2:total_trials+1
        if strcmp(dataout{k,5},'No') && strcmp(dataout{k,6},'Yes') %Regular Trial  
            targ_rew_regular(k-1) = 1;
        elseif strcmp(dataout{k,5},'Yes') && strcmp(dataout{k,6},'Yes') %Catch Trial 
            targ_rew_catch(k-1) = 1; 
        end
    end
    
    %Number of regular trials where there was no chance to allow for target decision  
    na_trials_regular = 0;
    for na_r = 2:total_trials+1
        if strcmp(dataout{na_r,6},'N/A') && strcmp(dataout{na_r,5},'No') 
            na_trials_regular = na_trials_regular +1;
        end
        
    end
    %Number of catch trials where there was no chance to allow for target decision  
    na_trials_catch = 0;
    for na_c = 2:total_trials+1
        if strcmp(dataout{na_c,6},'N/A') && strcmp(dataout{na_c,5},'Yes') 
            na_trials_catch = na_trials_catch +1;
        end
        
    end
    
    Target_Success_Rate_Regular = sum(targ_rew_regular)/(num_regular_trials - na_trials_regular); %Regular Trial Success Rate 
    Target_Success_Rate_Catch = sum(targ_rew_catch)/(num_catch_trials - na_trials_catch); % Catch Trial Success Rate
    

end