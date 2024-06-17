function subfolderPaths = getSubfolders(folderPath)
    %getSubfolders Retrieve full paths of all subfolders within a specified folder that arent empty.
    %
    % Syntax:
    %   subfolderPaths = getNonEmptySubfolders(folderPath)
    %
    % Description:
    %   The function getNonEmptySubfolders returns the full paths of all non-empty
    %   subdirectories within the specified directory path, excluding the special 
    %   '.' and '..' directories which refer to the current and parent directories.
    %
    % Inputs:
    %   folderPath : A string or character vector representing the absolute 
    %                or relative path to the directory whose subfolders are 
    %                to be listed.
    %
    % Outputs:
    %   subfolderPaths : A cell array of strings, each string being the full path 
    %                    to a non-empty subfolder within the specified directory.
    %
    % Examples:
    %   % Example 1: Get full paths of non-empty subfolders in the current directory
    %   currentPath = '.';
    %   subfolderPaths = getNonEmptySubfolders(currentPath);
    %   disp(subfolderPaths);
    %
    %   % Example 2: Get full paths of non-empty subfolders in a specified directory
    %   folderPath = '/Users/username/Documents';
    %   subfolderPaths = getNonEmptySubfolders(folderPath);
    %   disp(subfolderPaths);
    %
    % See also: dir, fullfile, ismember

    % List all items in the directory specified by folderPath
    items = dir(folderPath);
    
    % Filter to keep only those that are directories
    isSubfolder = [items.isdir];
    
    % Get the names of these directories
    subfolderNames = {items(isSubfolder).name};
    
    % Remove the '.' and '..' directories
    subfolderNames = subfolderNames(~ismember(subfolderNames, {'.', '..'}));
    
    % Initialize cell array to hold paths of non-empty subfolders
    subfolderPaths = {};
    
    % Loop through each subfolder to check if it's empty
    for i = 1:length(subfolderNames)
        subfolderPath = fullfile(folderPath, subfolderNames{i});
        % List contents of the subfolder
        subfolderContents = dir(subfolderPath);
        % Remove '.' and '..' from the list of contents
        subfolderContents = subfolderContents(~ismember({subfolderContents.name}, {'.', '..'}));
        % Check if the subfolder is non-empty
        if ~isempty(subfolderContents)
            subfolderPaths{end+1} = subfolderPath; %#ok<AGROW>
        end
    end
end