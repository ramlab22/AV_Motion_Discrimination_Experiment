function [velocities, distances, durations] = extract_file_parameters(fileNames)
    %EXTRACT_FILE_PARAMETERS Extracts numerical parameters from file names.
    %
    % Syntax:  [velocities, distances, durations] = extract_file_parameters(fileNames)
    %
    % Inputs:
    %    fileNames - Cell array of character arrays, each containing a file name
    %               that includes 'durZZms_velXX_disYY.mat' where XX, YY, and ZZ
    %               are numbers that may include decimals (e.g., 12.34).
    %
    % Outputs:
    %    velocities - 1xn double array containing the numbers extracted after 'vel'
    %                 and before '_dis' in each file name.
    %    distances  - 1xn double array containing the numbers extracted after 'dis'
    %                 and before '.mat' or any subsequent text.
    %    durations  - 1xn double array containing the numbers extracted after 'dur'
    %                 and before 'ms' in each file name.
    %
    % Example:
    %    fileList = {'Ba_AudOnly_dur834ms_vel9.59_dis8.mat', 'Alv_AudOnly_dur1100ms_vel46.1_dis8_may24.mat', 'dur834ms_vel46.1_dis8_may24.mat', 'dur1100ms_vel9.44_dis20.mat'};
    %    [velocities, distances, durations] = extract_file_parameters(fileList);
    %    % velocities => [9.59 46.1 46.1 9.44]
    %    % distances => [8 8 8 20]
    %    % durations => [834 1100 834 1100]
    %
    % This function uses regular expressions to parse the file names and extract
    % the necessary numerical values.

    % Number of files
    numFiles = numel(fileNames);
    
    % Initialize arrays to store the velocities, distances, and durations
    velocities = zeros(1, numFiles);
    distances = zeros(1, numFiles);
    durations = zeros(1, numFiles);
    
    % Regular expression to match numbers (including decimals) after 'dur', 'vel', and 'dis'
    pattern = 'dur(\d+(?:\.\d+)?)ms.*?vel(\d+(?:\.\d+)?)_dis(\d+(?:\.\d+)?).*?\.mat';
    
    % Loop through each file name and extract the numbers
    for i = 1:numFiles
        % Current file name
        fileName = fileNames{i};
        
        % Use regular expression to extract numbers
        tokens = regexp(fileName, pattern, 'tokens');
        
        % If tokens are found, convert them to numbers and store in arrays
        if ~isempty(tokens)
            % tokens{1} contains the matched groups for the current file
            durations(i) = str2double(tokens{1}{1});
            velocities(i) = str2double(tokens{1}{2});
            distances(i) = str2double(tokens{1}{3});
        end
    end
end
