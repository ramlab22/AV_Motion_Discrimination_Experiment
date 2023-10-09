function [prob_correct] = directional_probability_visual_dotnum(directional_dataout, dotInfo) 
% DIRECTIONAL_PROBABILITY_DOTNUM Compute the proportion of correct responses for each dotnum level based on direction.
%
% Given a dataset containing trial information and related dot information,
% this function computes the success rate (in percentage) of different coherence levels 
% based on the direction (right or left) of the trials.
%
% Input:
%   - directional_dataout: Cell array containing trial-specific data.
%     * Column 5: 'Yes' if it's a catch trial, 'No' otherwise.
%     * Column 6: Indicates reward status - 'Yes', 'No', or 'N/A'.
%     * Column 8: dot um level for the trial.
%     * Column 9: Direction of the trial - 0 for Right, 180 for Left.
%
%   - dotInfo: Struct containing information about the dot stimuli.
%     * dotInfo.dotnumSet : Array of unique dotnum levels.
%     * dotInfo.dotnumFreq_right: Array containing right trial frequencies for each dotnum level.
%     * dotInfo.dotnumFreq_left: Array containing left trial frequencies for each dotnum level.
%
% Output:
%   - prob: Nx2 array where N is the number of unique dotnum levels.
%     * Column 1: dotnum levels.
%     * Column 2: Success rate in percentage for each dotnum level.
%
% Example usage:
%   prob_data = directional_probability_visual_dotnum(dataout, dotInfoStruct);
%
% Note:
%   This function assumes that the input directional_dataout is a cell array 
%   with the specified columns and dotInfo is a struct with the mentioned fields.


dotnum_rew_numbers = [dotInfo.dotnumSet;
        zeros(1,length(dotInfo.dotnumSet));
        zeros(1,length(dotInfo.dotnumSet))]; %Initilize top row(coherence lvls) and 2nd row(rew numbers) to zero, 3rd row(N/A trials)

    dotnums = dotInfo.dotnumSet;

    for i_dotnum_val = 1:length(dotnums)
        for v = 1:length(directional_dataout(:,1))
            if directional_dataout{v,9} == 0 %Right Trial
                if (strcmp(directional_dataout{v,6},'Yes')) && (directional_dataout{v,8} == dotnums(i_dotnum_val))  && (strcmp(directional_dataout{v,5},'No')) %Target Reward & Not a Catch Trial
                    dotnum_rew_numbers(2,i_dotnum_val) = dotnum_rew_numbers(2,i_dotnum_val)+1;
                end
                if  (strcmp(directional_dataout{v,6},'N/A')) && (directional_dataout{v,8} == dotnums(i_dotnum_val)) && (strcmp(directional_dataout{v,5},'No')) %No chance for target reward & Not a catch trial
                    dotnum_rew_numbers(3,i_dotnum_val) = dotnum_rew_numbers(3,i_dotnum_val)+1;
                end
            elseif directional_dataout{v,9} == 180 %Left Trial
                if (strcmp(directional_dataout{v,6},'No')) && (directional_dataout{v,8} == dotnums(i_dotnum_val))  && (strcmp(directional_dataout{v,5},'No')) %Target Reward & Not a Catch Trial
                    dotnum_rew_numbers(2,i_dotnum_val) = dotnum_rew_numbers(2,i_dotnum_val)+1;
                end
                if  (strcmp(directional_dataout{v,6},'N/A')) && (directional_dataout{v,8} == dotnums(i_dotnum_val)) && (strcmp(directional_dataout{v,5},'No')) %No chance for target reward & Not a catch trial
                    dotnum_rew_numbers(3,i_dotnum_val) = dotnum_rew_numbers(3,i_dotnum_val)+1;
                end
            end
        end
    end


    dotnum_success_rate = [dotInfo.dotnumSet;
        zeros(1,length(dotInfo.dotnumSet))]; %Initilize the top row, and percentages
    if directional_dataout{2,9} == 0 %Right
        for c = 1:length(dotInfo.dotnumSet)
            dotnum_success_rate(2,c) = dotnum_rew_numbers(2,c)/((dotInfo.dotnumFreq_right(2,c))-(dotnum_rew_numbers(3,c)));  %Subtract the trials where there was no chance for reward(N/A Target Correct)
        end
    elseif directional_dataout{2,9} == 180 %Left
        for c = 1:length(dotInfo.dotnumSet)
            dotnum_success_rate(2,c) = dotnum_rew_numbers(2,c)/((dotInfo.dotnumFreq_left(2,c))-(dotnum_rew_numbers(3,c)));  %Subtract the trials where there was no chance for reward(N/A Target Correct)
        end
    end
    % All of the Coherence Success Rates in Percentage, regular
    prob_correct = [dotInfo.dotnumSet;
        dotnum_success_rate(2,:)*100];

    prob_correct = prob_correct';
    
end