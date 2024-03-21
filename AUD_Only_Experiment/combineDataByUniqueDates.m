function master_dataout = combineDataByUniqueDates(Path, unique_dates_totalfiles_names)
%COMBINEDATABYUNIQUEDATES Combines data from files that share the same date.
%
% This function loads data from multiple files, each corresponding to a unique date,
% cleans the data by removing empty rows and rows corresponding to catch trials, 
% and then combines the cleaned data for each unique date into a single data structure.
%
% Inputs:
%   Path - A string specifying the directory path where the data files are located.
%   unique_dates_totalfiles_names - A cell array with each row representing a unique
%       date and containing file names (as columns) that correspond to that date.
%
% Output:
%   master_dataout - A cell array where each cell contains combined data for a 
%       specific unique date, with rows representing data entries and columns
%       representing data fields.

n_unique_dates = length(unique_dates_totalfiles_names(:,1)); % Number of unique dates

for i_uniquedate = 1:n_unique_dates
    % Determine the number of non-empty file names for the current date
    n_blocks_uniquedate = sum(~cellfun('isempty', unique_dates_totalfiles_names(i_uniquedate, :)) & ...
                              ~cellfun(@(c) isequal(c, zeros(0,0)), unique_dates_totalfiles_names(i_uniquedate, :)));
    
    for j_block = 1:n_blocks_uniquedate
        % Load the data from the current file
        load(horzcat(Path, unique_dates_totalfiles_names{i_uniquedate,j_block}));
        close all
        % Delete empty rows from the data cell
        dataout(all(cellfun(@isempty, dataout), 2), :) = [];
        
        % Delete rows corresponding to catch trials from the data cell
        dataout(strcmp(dataout(:,5), 'Yes'), :) = [];
        
        % Combine all data for the particular date into one cell
        if j_block == 1
            uniquedate_dataout = dataout; % Initialize with data from the first file
            column_titles = dataout(1, :); % Assume the first row contains column titles
        else
            % Append data from subsequent files, excluding the first row (titles)
            uniquedate_dataout = vertcat(uniquedate_dataout, dataout(2:end, :));
        end
    end % for each block/file of a unique date
    
    % Store the combined data for the current unique date
    master_dataout{i_uniquedate} = uniquedate_dataout;
end % for each unique date
