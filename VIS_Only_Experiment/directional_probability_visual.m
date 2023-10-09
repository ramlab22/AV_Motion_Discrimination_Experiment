function [prob] = directional_probability_visual(directional_dataout, dotInfo) 
% DIRECTIONAL_PROBABILITY Compute the proportion of correct responses for each coherence level based on direction.
%
% Given a dataset containing trial information and related dot information,
% this function computes the success rate (in percentage) of different coherence levels 
% based on the direction (right or left) of the trials.
%
% Input:
%   - directional_dataout: Cell array containing trial-specific data.
%     * Column 5: 'Yes' if it's a catch trial, 'No' otherwise.
%     * Column 6: Indicates reward status - 'Yes', 'No', or 'N/A'.
%     * Column 8: Coherence level for the trial.
%     * Column 9: Direction of the trial - 0 for Right, 180 for Left.
%
%   - dotInfo: Struct containing information about the dot stimuli.
%     * dotInfo.coherences: Array of unique coherence levels.
%     * dotInfo.cohFreq_right: Array containing right trial frequencies for each coherence level.
%     * dotInfo.cohFreq_left: Array containing left trial frequencies for each coherence level.
%
% Output:
%   - prob: Nx2 array where N is the number of unique coherence levels.
%     * Column 1: Coherence levels.
%     * Column 2: Success rate in percentage for each coherence level.
%
% Example usage:
%   prob_data = directional_probability(dataout, dotInfoStruct);
%
% Note:
%   This function assumes that the input directional_dataout is a cell array 
%   with the specified columns and dotInfo is a struct with the mentioned fields.


coherence_rew_numbers = [dotInfo.coherences;
        zeros(1,length(dotInfo.coherences));
        zeros(1,length(dotInfo.coherences))]; %Initilize top row(coherence lvls) and 2nd row(rew numbers) to zero, 3rd row(N/A trials)

    coherences = dotInfo.coherences;

    for i_coherence = 1:length(coherences)
        for v = 1:length(directional_dataout(:,1))
            if directional_dataout{v,9} == 0 %Right Trial
                if (strcmp(directional_dataout{v,6},'Yes')) && (directional_dataout{v,8} == coherences(i_coherence))  && (strcmp(directional_dataout{v,5},'No')) %Target Reward & Not a Catch Trial
                    coherence_rew_numbers(2,i_coherence) = coherence_rew_numbers(2,i_coherence)+1;
                end
                if  (strcmp(directional_dataout{v,6},'N/A')) && (directional_dataout{v,8} == coherences(i_coherence)) && (strcmp(directional_dataout{v,5},'No')) %No chance for target reward & Not a catch trial
                    coherence_rew_numbers(3,i_coherence) = coherence_rew_numbers(3,i_coherence)+1;
                end
            elseif directional_dataout{v,9} == 180 %Left Trial
                if (strcmp(directional_dataout{v,6},'No')) && (directional_dataout{v,8} == coherences(i_coherence))  && (strcmp(directional_dataout{v,5},'No')) %Target Reward & Not a Catch Trial
                    coherence_rew_numbers(2,i_coherence) = coherence_rew_numbers(2,i_coherence)+1;
                end
                if  (strcmp(directional_dataout{v,6},'N/A')) && (directional_dataout{v,8} == coherences(i_coherence)) && (strcmp(directional_dataout{v,5},'No')) %No chance for target reward & Not a catch trial
                    coherence_rew_numbers(3,i_coherence) = coherence_rew_numbers(3,i_coherence)+1;
                end
            end
        end
    end


    coherence_success_rate = [dotInfo.coherences;
        zeros(1,length(dotInfo.coherences))]; %Initilize the top row, and percentages
    if directional_dataout{2,9} == 0 %Right
        for c = 1:length(dotInfo.coherences)
            coherence_success_rate(2,c) = coherence_rew_numbers(2,c)/((dotInfo.cohFreq_right(2,c))-(coherence_rew_numbers(3,c)));  %Subtract the trials where there was no chance for reward(N/A Target Correct)
        end
    elseif directional_dataout{2,9} == 180 %Left
        for c = 1:length(dotInfo.coherences)
            coherence_success_rate(2,c) = coherence_rew_numbers(2,c)/((dotInfo.cohFreq_left(2,c))-(coherence_rew_numbers(3,c)));  %Subtract the trials where there was no chance for reward(N/A Target Correct)
        end
    end
    % All of the Coherence Success Rates in Percentage, regular
    prob = [dotInfo.coherences;
        coherence_success_rate(2,:)*100];

    prob = prob';
    
end