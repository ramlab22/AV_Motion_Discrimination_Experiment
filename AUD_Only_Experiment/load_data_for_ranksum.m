function [slope_distributions,std_distributions,totalfiles_names] = load_data_for_ranksum(Path)
[~,totalfiles_names] = get_datafile_info(Path);
for i_file=1:length(totalfiles_names)
    load(horzcat(Path,totalfiles_names{1,i_file}),"slope_at_50_percent_per_date","std_gaussian_per_date");
    
    slope_distributions{i_file}=slope_at_50_percent_per_date;
    std_distributions{i_file}=std_gaussian_per_date;
end %for each file 