
single_slope=1;
load_excel_conditiontable=1;

if single_slope~=1 && load_excel_conditiontable~= 1
    prompt = "how many slopes per subject unique condition do you want?";
    n_slopes_per_condition = input(prompt);

end
if load_excel_conditiontable==1
    excel_file='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/slopes_std_per_condition.xlsx';
    condition_table = readtable(excel_file);
else
    var_types={'double','double','double','double','string','double','cell'};
    table_size=[1 7];
    var_names={'slope','velocity','duration','displacement','subjectID','session','session_date'};
    condition_table=table('Size',table_size,'VariableTypes',var_types,'VariableNames',var_names)
    total_filepath{2}='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/errorbar_figs/';
    total_filepath{1}='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/errorbar_figs/';
    %total_filepath{2}='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/All_condition_psyfuncs_prefilter_071524/';
    %total_filepath{1}='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/All_condition_psyfuncs_prefilter_071524/';

    n_monkeys=length(total_filepath);
    for i_monkey=1:n_monkeys
        pathParts = strsplit(total_filepath{i_monkey}, filesep);
        if strcmp(pathParts{8}, 'Ba') || strcmp(pathParts{8}, 'Alv')
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
                    load(mat_file,"dataout","master_dataout","data_key","save_name");
                    total_trials=length(master_dataout);
                       % check if dataout has the same # of trials as each
                       % of the dataouts for each date (contained in master_dataout) added together 
                       % minus the first row of any 
                    if total_trials ~= sum(cellfun(@(x) size(x, 1), master_dataout)) - (numel(master_dataout) - 1)
                        disp("no combined dataout variable in ", parameterfolder_files_names{i_condition} );
                    else
                        %% run functions to generate n_slopes_per_condition number of slopes for the given condition
                        [i_condition_artificial_dataouts, slopes_i_condition] = get_n_slopes_from_data(dataout, n_slopes_per_condition, save_name);
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
condition_table(condition_table.displacement == 8, :) = []

%% classic mixed effects model of slope
% Define the formula for the classic mixed effects model
formula = 'slope ~ velocity + duration + displacement + (1|subjectID)'

% Fit the mixed effects model
lme = fitlme(condition_table, formula);

% Display the results
disp(lme);


%% classic mixed effects model of slope-no duration
% Define the formula for the classic mixed effects model
formula_noduration = 'slope ~ velocity + displacement + (1|subjectID)'

% Fit the mixed effects model
lme_noduration = fitlme(condition_table, formula_noduration);

% Display the results
disp(lme_noduration);

%% classic mixed effects model of slope-no displacement
% Define the formula for the classic mixed effects model
formula_nodisplacement = 'slope ~ velocity + duration + (1|subjectID)'

% Fit the mixed effects model
lme_nodisplacement = fitlme(condition_table, formula_nodisplacement);

% Display the results
disp(lme_nodisplacement);

%% classic mixed effects model of slope-no velocity
% Define the formula for the classic mixed effects model
formula_novelocity = 'slope ~ displacement + duration + (1|subjectID)'

% Fit the mixed effects model
lme_novelocity = fitlme(condition_table, formula_novelocity);

% Display the results
disp(lme_novelocity);


%% classic model with  interaction terms 
% cant run cuz of multicolinearity

%% Add two-way interaction terms
formula_interaction_2way = 'slope ~ velocity*duration + velocity*displacement + duration*displacement + (1|subjectID)';
lme_interaction_2way = fitlme(condition_table, formula_interaction_2way);

% Display the results
disp(lme_interaction_2way);
%% Add two-way interaction terms 
formula_interaction_2way_velocitydisplacement = 'slope ~ duration + velocity*displacement + (1|subjectID)';
lme_interaction_2way_velocitydisplacement = fitlme(condition_table, formula_interaction_2way_velocitydisplacement);

% Display the results
disp(lme_interaction_2way_velocitydisplacement);
%% classic mixed effects model of slope with session # considered
% Define the formula for the classic mixed effects model
formula_session = 'slope ~ velocity + duration + displacement + (1|subjectID)+ (1|session)'

% Fit the mixed effects model
lme_session = fitlme(condition_table, formula_session);

% Display the results
disp(lme_session);
%% Add two-way interaction terms with session # considered
formula_interaction_2way_session = 'slope ~ velocity*duration + velocity*displacement + duration*displacement + (1|subjectID)+ (1|session_num)';
lme_interaction_2way_session = fitlme(condition_table, formula_interaction_2way_session);

% Display the results
disp(lme_interaction_2way_session);


%% duration only model
% Simplified model formula excluding one of the correlated predictors
formula_duronly = 'slope ~ duration + (1|subjectID)';

% Fit the revised mixed effects model
lme_duronly = fitlme(condition_table, formula_duronly);

% Display the results
disp(lme_duronly);

%% displacement only model
% Simplified model formula excluding one of the correlated predictors
formula_disonly = 'slope ~ displacement + (1|subjectID)';

% Fit the revised mixed effects model
lme_disonly = fitlme(condition_table, formula_disonly);

% Display the results
disp(lme_disonly);

%% velocity only model
% Simplified model formula excluding one of the correlated predictors
formula_velonly = 'slope ~ velocity + (1|subjectID)';

% Fit the revised mixed effects model
lme_velonly = fitlme(condition_table, formula_velonly);

% Display the results
disp(lme_velonly);