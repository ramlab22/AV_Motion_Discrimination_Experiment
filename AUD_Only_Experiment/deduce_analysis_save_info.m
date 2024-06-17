function [data_save_path, save_name] = deduce_analysis_save_info(Path)
    % deduce_save_info Deduce data_save_path and save_name from Path
    %
    % This function deduces the data_save_path and save_name based on the input Path.
    % The Path should follow a specific format to ensure correct extraction.
    %
    % Example Usage:
    %   Path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_velocity/dur1100ms_vel59.95_dis66/';
    %   [data_save_path, save_name] = deduce_save_info(Path);
    %
    % Inputs:
    %   Path - The full directory path that contains duration, velocity, and distance information.
    %
    % Outputs:
    %   data_save_path - The directory where the data should be saved.
    %   save_name - The name of the file to be saved.
    %
    % Note:
    %   Ensure that the Path is structured correctly, otherwise an error will be raised.

    % Remove leading and trailing slashes
    Path = strtrim(strrep(Path, '//', '/'));
    if Path(1) == '/'
        Path = Path(2:end);
    end
    if Path(end) == '/'
        Path = Path(1:end-1);
    end

    % Split Path into parts using '/' as the delimiter
    path_parts = strsplit(Path, '/');

    % Check the number of path components
    if numel(path_parts) < 10
        error('Invalid Path format: not enough components in Path');
    end

    % Extract the participant name (Ba or Alv) from the Path
    participant = path_parts{7};

    % Construct the data_save_path by excluding the last folder (duration and velocity)
    data_save_path = strjoin(path_parts(1:end-1), '/');
    
    % Extract duration, velocity, and distance from the final folder name
    folder_name = path_parts{end};
    parts = regexp(folder_name, 'dur(\d+)ms_vel([\d.]+)_dis(\d+)', 'tokens');

    % Ensure that we correctly extracted the parts
    if isempty(parts)
        error('Invalid Path format: cannot parse duration, velocity, and distance');
    end
    tokens = parts{1};

    % Extract duration, velocity, and distance values
    duration = tokens{1};
    velocity = tokens{2};
    distance = tokens{3};

    % Construct the save_name
    save_name = sprintf('%s_AudOnly_dur%sms_vel%s_dis%s', participant, duration, velocity, distance);
    
    % Add leading and trailing slashes to data_save_path
    data_save_path = ['/', data_save_path, '/'];
end
