
single_slope=1;
load_excel_conditiontable=0;
n_slopes_per_condition = 100;
% if single_slope~=1 && load_excel_conditiontable~= 1
%     prompt = "how many slopes per subject unique condition do you want?";
%     n_slopes_per_condition = input(prompt);
% 
% end
if load_excel_conditiontable==1
    excel_file='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/slopes_std_per_condition.xlsx';
    condition_table = readtable(excel_file);
else
    var_types={'double','double','double','double','string','double'};
    %var_types={'double','double','double','double','string','double','cell'};

    table_size=[1 6];
    %table_size=[1 7];

    var_names={'slope','velocity','duration','displacement','subjectID','session'};
    %var_names={'slope','velocity','duration','displacement','subjectID','session','session_date'};

    condition_table=table('Size',table_size,'VariableTypes',var_types,'VariableNames',var_names);
    total_filepath{2}='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/errorbar_figs/';
    total_filepath{1}='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/errorbar_figs/';
    %total_filepath{2}='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/All_condition_psyfuncs_prefilter_071524/';
    %total_filepath{1}='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/All_condition_psyfuncs_prefilter_071524/';

    n_monkeys=length(total_filepath);
    for i_monkey=1:n_monkeys
        pathParts = strsplit(total_filepath{i_monkey}, filesep);
        if strcmpi(pathParts{8}, 'Ba') || strcmpi(pathParts{8}, 'Alv')
            monkey{i_monkey} = pathParts{8};
        end
        parameter_folders=getSubfolders(total_filepath{i_monkey});
        n_parameterfolders=length(parameter_folders);
        for i_parameterfolder=1:n_parameterfolders
            [~,parameterfolder_files_names] = get_datafile_info(parameter_folders{i_parameterfolder});
            n_conditions_per_parameterfolder=length(parameterfolder_files_names);
            [velocities, displacements,durations] = extract_file_parameters(parameterfolder_files_names);
            for i_condition=1:n_conditions_per_parameterfolder
                mat_file=[parameter_folders{i_parameterfolder} '/' parameterfolder_files_names{i_condition} ];


                if single_slope==1
                    load(mat_file,"slope_dynamicrange");

                    n_slopes_per_condition=length(slope_dynamicrange);
                else
                    load(mat_file,"dataout","master_dataout","date_key","save_name");
                    total_trials=length(dataout);
                       % check if dataout has the same # of trials as each
                       % of the dataouts for each date (contained in master_dataout) added together 
                       % minus the first row of any 
                    if total_trials ~= sum(cellfun(@(x) size(x, 1), master_dataout)) - (numel(master_dataout) - 1)
                        fprintf('NO COMBINED DATAOUT VARIABLE IN: %s\n',parameterfolder_files_names{i_condition} );

                    else
                        %% run functions to generate n_slopes_per_condition number of slopes for the given condition
                        [i_condition_artificial_dataouts, slopes_i_condition,i_slopes_SE_across_artificial_datasets,i_slope_sd_across_artificial_datasets] = get_n_slopes_from_data(dataout, n_slopes_per_condition, save_name);
                    end
                   % n_slopes_per_condition=length(slope_per_date);
                end

                if i_condition==1 && i_parameterfolder==1 && i_monkey==1
                    row_start=1;
                    row_end=n_slopes_per_condition;
                else
                    row_start=row_end+1;
                    row_end=row_end+n_slopes_per_condition;
                end
                if single_slope==1
                    condition_table.slope(row_start:row_end)=slope_dynamicrange;

                else
                    condition_table.slope(row_start:row_end)=slopes_i_condition;
              %      condition_table.session_date(row_start:row_end)=[date_key(:)];

                end
                condition_table.session(row_start:row_end)=[1:n_slopes_per_condition];
                condition_table.subjectID(row_start:row_end)=monkey{i_monkey};
                condition_table.velocity(row_start:row_end)=velocities(i_condition);
                condition_table.duration(row_start:row_end)=durations(i_condition);
                condition_table.displacement(row_start:row_end)=displacements(i_condition);
            end
        end
    end
    condition_table.session_num(1:size(condition_table,1))=[1:size(condition_table,1)];
end
if load_excel_conditiontable~=1
    condition_table.duration=condition_table.duration/1000;
end
condition_table(condition_table.displacement == 8, :) = []
% Separate data for subjects
baData = condition_table(strcmpi(condition_table.subjectID, 'ba'), :);
alvData = condition_table(strcmpi(condition_table.subjectID, 'alv'), :);

%% classic mixed effects model of slope
% Define the formula for the classic mixed effects model
formula = 'slope ~ velocity + duration + displacement + (1|subjectID)';
