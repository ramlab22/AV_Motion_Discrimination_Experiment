function [master_dataout,column_titles,totalfiles_names] = combine_data_acrossblocks(Path)
%% load data from all the data files in the selected folder and combine into one cell array 

%get names and info for all files in chosen folder 
[totalfiles,totalfiles_names] = get_datafile_info(Path);

for i_file=1:length(totalfiles_names)
    load(horzcat(Path,totalfiles_names{1,i_file}));
    %delete empty rows from data cell
    dataout(all(cellfun(@isempty, dataout),2),:) = [];
    %delete catch trials from data cell
    dataout(strcmp(dataout(:,5),'Yes'),:)=[];
    %combine all data in folder into one master_dataout cell
    if i_file==1
        master_dataout=dataout;
        column_titles=dataout(1,:);
    else
        master_dataout=vertcat(master_dataout,dataout(2:end,:));
    end % if first file
end %for each file 