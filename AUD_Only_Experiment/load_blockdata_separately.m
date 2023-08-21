function [master_dataout,column_titles,totalfiles_names] = load_blockdata_separately(Path)
[totalfiles,totalfiles_names] = get_datafile_info(Path);
master_dataout=cell(1,size(totalfiles_names,2));
for i_file=1:length(totalfiles_names)
    load(horzcat(Path,totalfiles_names{1,i_file}),"dataout");
    %delete empty rows from data cell
    dataout(all(cellfun(@isempty, dataout),2),:) = [];
    % if length(dataout)>500
    %     dataout=dataout(1:501,:);
    % end
    master_dataout{i_file}=dataout;
end %for each file 
column_titles=dataout(1,:);