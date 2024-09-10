% plots all individual psychometric functions as well as all the
% psychometric functions for a single condition on the same plot together
% for a single monkey

save_figs=0;
total_filepath='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/errorbar_figs/';
parameter_folders=getSubfolders(total_filepath);
n_parameterfolders=length(parameter_folders);
for i_parameterfolder=1:n_parameterfolders
    [~,totalfiles_names] = get_datafile_info(parameter_folders{i_parameterfolder});
    n_files_per_i_parameterfolder=length(totalfiles_names);
    for i_file=1:n_files_per_i_parameterfolder
        mat_file=[parameter_folders{i_parameterfolder} '/' totalfiles_names{i_file} ];
        [all_dates_fig]=total_condition_psych_funcs(mat_file);
        if save_figs==1
             saveas(all_dates_fig, [mat_file(1:end-4) 'all psychometrics.png']);
             saveas(all_dates_fig, [mat_file(1:end-4) 'all psychometrics.fig']);
        end
    end
end