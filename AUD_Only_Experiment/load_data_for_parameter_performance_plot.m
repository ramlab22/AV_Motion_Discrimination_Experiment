function [all_slopes,all_std_gaussians,totalfiles_names] = load_data_for_parameter_performance_plot(Path)
[~,totalfiles_names] = get_datafile_info(Path);
all_slopes=zeros(1,length(totalfiles_names));
all_std_gaussians=zeros(1,length(totalfiles_names));

for i_file=1:length(totalfiles_names)
    %load(horzcat(Path,totalfiles_names{1,i_file}),"slope_at_50_percent","std_gaussian");
   try
   load(horzcat(Path,totalfiles_names{1,i_file}),"slope_dynamicrange","std_gaussian_scaled");

    all_slopes(1,i_file)=slope_dynamicrange;
    all_std_gaussians(1,i_file)=std_gaussian_scaled;
   catch
       Path
   end

   % all_slope_50(1,i_file)=slope_at_50_percent;
   % all_std_gaussian(1,i_file)=std_gaussian;
end %for each file 