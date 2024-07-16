function [prop_Rresp_zerocoh] = propRresp_catchtrials(dataout, audInfo)
     % Calculates the proportion of rightward responses for trials at zero coherence level
    % in a dataset excluding specific trials based on given conditions. This function is 
    % particularly designed for processing unisensory trial data, where it accounts for 
    % trials excluding those where the subject quit before the target was presented, and 
    % trials that do not have only the correct target available.
    %
    % The function also dynamically adjusts to ignore a header row in the input data, if present, 
    % ensuring that column titles such as 'Trial #' do not interfere with the calculations.
    %
    % Parameters:
    %   dataout: A cell array of trial data with the following columns of interest:
    %            - Column 5: Indicates whether only the correct target was available ('Yes' or 'No').
    %            - Column 6: Contains the response accuracy ('Yes', 'No', or 'N/A').
    %            - Column 8: The coherence level of the trial.
    %            - Column 9: The trial direction (1 for right, 0 for left).
    %            The function expects the first row to possibly contain column titles, 
    %            in which case it will be ignored in calculations.
    %   audInfo: A structure containing auditory stimuli information, used here to 
    %            identify coherence levels, though not directly used in the modified function.
    %
    % Returns:
    %   prop_Rresp_zerocoh: The proportion of trials at zero coherence level where a 
    %                       rightward or leftward response was recorded, expressed as 
    %                       a percentage of the total valid trials. Trials marked with 
    %                       'N/A' responses or those where only the correct target was 
    %                       available are excluded from the calculation.
    %
    % Example Usage:
    %   [prop_Rresp_zerocoh] = probRresp_catchtrials(dataout, audInfo);

    % Initialize counters for rightward responses and total valid trials at zero coherence
    rightwardResponses = 0;
    totalValidTrials = 0;

    % Determine the starting index based on whether the first row contains column titles
    startIndex = 1;
    if strcmp(dataout{1,1}, 'Trial #')
        startIndex = 2;
    end

    % Loop through each trial in the dataout, starting from startIndex
    for v = startIndex:size(dataout,1)
        % Extract coherence level directly as it is already a double
        coherence = dataout{v,8};

        % Check if the correct target was not the only option available
        correctTargetNotOnlyAvailable = strcmp(dataout{v,5},'No');

        % First, check for zero coherence
        if coherence == 0
            % Then check if the correct target was not the only option available
            if correctTargetNotOnlyAvailable
                totalValidTrials = totalValidTrials + 1; % Count this as a valid trial
                if (strcmp(dataout{v,6},'Yes') && dataout{v,9} == 1) || (strcmp(dataout{v,6},'No') && dataout{v,9} == 0)
                    rightwardResponses = rightwardResponses + 1; % Count as a rightward response if conditions are met
                end
            end
        end
    end

    % Calculate the proportion of rightward responses for zero coherence trials
    if totalValidTrials > 0
        prop_Rresp_zerocoh = (rightwardResponses / totalValidTrials) * 100;
    else
        prop_Rresp_zerocoh = NaN; % Handle the case of no valid trials
    end
end