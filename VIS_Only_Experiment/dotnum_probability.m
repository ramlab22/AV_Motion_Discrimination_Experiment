function [probability_correct] = dotnum_probability(dataout, dotInfo) 
%DOTNUM_PROBABILITY Calculate the success rate of dot numbers.
%
%   [probability_correct] = DOTNUM_PROBABILITY(dataout, dotInfo) computes
%   the probability of success for each dot number possibility based on the provided data.
%
%   Parameters:
%   - dataout: A cell array containing the trial data. 
%              Expected columns include:
%              6th column: Contains strings 'Yes', 'No', or 'N/A' indicating reward status.
%              8th column: Contains the dot number values.
%              5th column: Contains strings indicating if a trial is a 'Catch Trial'.
%
%   - dotInfo: A structure containing dot information.
%              dotInfo.dotnumSet: A 1xN array of dot numbers.
%              dotInfo.dotnumFreq: A 1xN array indicating the frequency of each dot number.
%
%   Returns:
%   - probability_correct: A Nx3 matrix where:
%              1st column: Represents the dot number.
%              2nd column: Represents the success rate in percentage.
%              3rd column: Represents the frequency of each dot number from dotInfo.dotnumFreq.
%
%   Example:
%   dataout = {...}; % Your trial data here
%   dotInfo.dotnumSet = [200, 100, 50];
%   dotInfo.dotnumFreq = [10, 10, 10];
%   pc = DOTNUM_PROBABILITY(dataout, dotInfo);
%
%   Note:
%   The function computes the success rate by taking the ratio of rewarded trials to 
%   the total number of trials minus trials where there was no chance for reward.

dotnum_rew_numbers = [dotInfo.dotnumSet;
        zeros(1,length(dotInfo.dotnumSet));
        zeros(1,length(dotInfo.dotnumSet))]; %Initilize top row(dot numbers) and 2nd row(rew numbers) to zero, 3rd row(N/A trials)

    dotnum_vals = dotInfo.dotnumSet;

    for i_dotnum_val = 1:length(dotnum_vals)
        for v = 1:length(dataout(:,1))
            if (strcmp(dataout{v,6},'Yes')) && (dataout{v,8} == dotnum_vals(i_dotnum_val))  && (strcmp(dataout{v,5},'No')) %Target Reward & Not a Catch Trial
                dotnum_rew_numbers(2,i_dotnum_val) = dotnum_rew_numbers(2,i_dotnum_val)+1;
            end
            if  (strcmp(dataout{v,6},'N/A')) && (dataout{v,8} == dotnum_vals(i_dotnum_val)) && (strcmp(dataout{v,5},'No')) %No chance for target reward & Not a catch trial
                dotnum_rew_numbers(3,i_dotnum_val) = dotnum_rew_numbers(3,i_dotnum_val)+1;
            end
        end
    end


    dotnum_success_rate = [dotInfo.dotnumSet;
        zeros(1,length(dotInfo.dotnumSet))]; %Initilize the top row, and percentages
    for c = 1:length(dotInfo.dotnumSet)
        dotnum_success_rate(2,c) = dotnum_rew_numbers(2,c)/(dotInfo.dotnumFreq(2,c)-dotnum_rew_numbers(3,c));  %Subtract the trials where there was no chance for reward(N/A Target Correct)
    end

    % All of the dot num possibility Success Rates in Percentage, regular
    probability_correct = [dotInfo.dotnumSet;
        dotnum_success_rate(2,:)*100;
        dotInfo.dotnumFreq];

    probability_correct = probability_correct';
end