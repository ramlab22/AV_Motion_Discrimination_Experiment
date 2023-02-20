function [random_incorrect_opacity_list] = catch_trial_randomizer(ExpInfo)
%CATCH_TRIAL_RANDOMIZER Summary of this function goes here
%   Detailed explanation goes here
    %Catch Trial Randomizer
    random_incorrect_opacity_list = zeros(1,(ExpInfo.num_trials));
    if ExpInfo.catchtrials >= 1
        num_catch = ExpInfo.catchtrials; % number of 0 opacity (Catch Trials)  
        
        signal_2 = [ones(1, num_catch), zeros(1, ExpInfo.num_trials - num_catch)];
        signal_2 = signal_2(randperm(length(signal_2)));%For Incorrect Opacity
        for i = 1:ExpInfo.num_trials
            if signal_2(i) == 1
                random_incorrect_opacity_list(i) = 0; %Catch
            elseif signal_2(i) == 0
                random_incorrect_opacity_list(i) = 1; %Regular
            end
        end
    else
        random_incorrect_opacity_list(:) = 1; %Sets all opacities to 1 = all regular trials
    end

end

