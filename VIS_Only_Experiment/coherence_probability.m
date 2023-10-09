function [probability_correct] = coherence_probability(dataout, dotInfo)
%COHERENCE_PROBABILITY Compute the total response accuracy per coherence from given data.
%
% Syntax:
%   prob = coherence_probability(dataout, dotInfo)
%
% Input Arguments:
%   dataout - A cell array containing trial data.
%       * Column 5: Indicates if the trial is a 'Catch Trial' ('Yes' or 'No').
%       * Column 6: Indicates if a reward was given ('Yes', 'No', or 'N/A').
%       * Column 8: Contains coherence values.
%
%   dotInfo - A structure containing information about the dot coherence.
%       * dotInfo.coherences: 1D array containing unique coherence levels.
%       * dotInfo.cohFreq: 2D array where the first row has coherence levels 
%                         and the second row contains the frequency of each coherence.
%
% Output Arguments:
%   prob - A 2D array where:
%       * First column: Coherence levels.
%       * Second column: Coherence success rate in percentage.
%       * Third column: Frequency of each coherence.
%
% Description:
%   The function first calculates the number of rewarded trials and the number of 
%   N/A trials (no chance for reward) for each coherence level. Then, it computes 
%   the success rate by dividing the number of rewarded trials by the total number 
%   of trials minus the N/A trials. The result is returned as a percentage.
%
% Examples:
%   prob = coherence_probability(dataout, dotInfo);
%
% Note:
%   The function assumes that the input 'dataout' has a specific structure where 
%   relevant information is stored in columns 5, 6, and 8.
%


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
    probability_correct = [dotInfo.coherences;
        coherence_success_rate(2,:)*100;
        dotInfo.cohFreq];

    probability_correct = probability_correct';
end