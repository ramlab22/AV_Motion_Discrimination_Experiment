function [cohFreq_dir] = cohFreq_finder(dir_dataout, audInfo)
    % Find the frequency of each coherence presentation throughout the exp. 
    % Exclude catch trials
    % Outputs list of coherences and the corresponding frequency of presentation
    % 
    % dir_dataout(strcmp(dir_dataout(:,6),'N/A'),:)=[]; %delete rows where subject quit before target presented
    % dir_dataout(all(cellfun(@isempty, dir_dataout),2),:) = [];%delete empty rows from data cell
    % 
    % 
    % columnIndex = 5; %Catch Trial Column
    % filterCondition = @(x) strcmp(x, 'No'); %Filter to only regular Trials, ie Catch Trial = 'No' 
    % filteredArray = {};
    % if  strcmp(dir_dataout(1,1), 'Trial #')
    % 
    %     for i = 2:size(dir_dataout, 1)
    %         if filterCondition(dir_dataout{i, columnIndex})
    %             filteredArray = [filteredArray; dir_dataout(i,:)];
    %         end
    %     end
    % else
    %     for i = 1:size(dir_dataout, 1)
    %         if filterCondition(dir_dataout{i, columnIndex})
    %             filteredArray = [filteredArray; dir_dataout(i,:)];
    %         end
    %     end
    % 
    % end

% Delete rows where the subject quit before target presented
dir_dataout(strcmp(dir_dataout(:,6), 'N/A'), :) = [];

% Delete empty rows from data cell
dir_dataout(all(cellfun(@isempty, dir_dataout), 2), :) = [];

% Column index for Catch Trial Column
columnIndex = 5;

% Filter condition to only include regular Trials, i.e., Catch Trial = 'No'
filterCondition = @(x) strcmp(x, 'No');

% Check if the first cell in the first row is 'Trial #'
if strcmp(dir_dataout(1,1), 'Trial #')
    startRow = 2; % Skip the header row
else
    startRow = 1; % No header row
end

% Apply the filter condition to the specified column
filteredArray = dir_dataout(startRow:end, :); % Get relevant rows
filteredArray = filteredArray(cellfun(filterCondition, filteredArray(:, columnIndex)), :);


[cnt, uniq] = hist(cell2mat(filteredArray(startRow:end,8)), unique(cell2mat(filteredArray(startRow:end,8))));


ii = [uniq';cnt];

cohFreq_dir = [audInfo.coherences;
    zeros(1,length(audInfo.coherences))];
for i = 1:length(audInfo.coherences)
    for j = 1:length(ii)
        if ii(1,j) == cohFreq_dir(1,i)
            cohFreq_dir(2,i) = ii(2,j);
            break
        else
            cohFreq_dir(2,i) = 0;
        end
    end
end

