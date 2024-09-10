function [slopes,mean_slopes,std_slopes,median_slopes,totalfiles_names] = load_bootstrap_data_for_parameter_performance_plot(data_save_path)
[~,totalfiles_names] = get_datafile_info(data_save_path);
slopes=zeros(1,length(totalfiles_names));
mean_slopes=zeros(1,length(totalfiles_names));
std_slopes=zeros(1,length(totalfiles_names));
median_slopes=zeros(1,length(totalfiles_names));

for i_file=1:length(totalfiles_names)
    %load(horzcat(Path,totalfiles_names{1,i_file}),"slope_at_50_percent","std_gaussian");
   try
   load(horzcat(data_save_path,totalfiles_names{1,i_file}),"bootstrap_slopes","bootstrap_slope_sd","bootstrap_slope_mean","bootstrap_slope_median");
   if i_file==1
       slopes=zeros(length(bootstrap_slopes),length(totalfiles_names));
   end
   slopes(:,i_file)=bootstrap_slopes;

   mean_slopes(1,i_file)=bootstrap_slope_mean;
   std_slopes(1,i_file)=bootstrap_slope_sd;
   median_slopes(1,i_file)=bootstrap_slope_median;

   catch
       data_save_path
   end

   % all_slope_50(1,i_file)=slope_at_50_percent;
   % all_std_gaussian(1,i_file)=std_gaussian;
end %for each file 