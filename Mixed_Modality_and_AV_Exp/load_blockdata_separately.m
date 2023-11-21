function [master_dataout, column_titles, totalfiles_names] = load_blockdata_separately(Path)
%LOAD_BLOCKDATA_SEPARATELY Loads data from multiple files located at the specified path
%
%   [master_dataout, column_titles, totalfiles_names] = load_blockdata_separately(Path)
%
%   Inputs:
%   - Path: A string representing the path to the directory containing the data files.
%
%   Outputs:
%   - master_dataout: A cell array where each element is a data matrix from a file.
%   - column_titles: A cell array containing the column titles extracted from the last processed file.
%   - totalfiles_names: A cell array containing the names of all files in the directory specified by Path.
%
%   This function reads each data file in the specified directory, removes empty rows, and aggregates the data 
%   into a master cell array. It also extracts the column titles from the
%   last processed file, and saves all the total data psychometric
%   functions to the data folder 

% Get the information about data files in the specified path
[totalfiles, totalfiles_names] = get_datafile_info(Path);

% Initialize the master data output cell array
master_dataout = cell(1, size(totalfiles_names, 2));

% Loop through each file in the total files list
for i_file = 1:length(totalfiles_names)
    
    % Load data from the current file
    %load(horzcat(Path, totalfiles_names{1, i_file}));
    load(horzcat(Path,totalfiles_names{1,i_file}),"dataout");
    % Delete empty rows from the data cell array (dataout)
    dataout(all(cellfun(@isempty, dataout), 2), :) = [];
    
    % Store the non-empty data into the master data output cell array
    master_dataout{i_file} = dataout;
end % End of loop through each file

% Extract column titles from the last processed data file
column_titles = dataout(1, :);
%save_all_open_LRfuncs(Path,totalfiles_names) ;
end

