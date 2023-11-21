%function [master_dataout] = threshold_slope_variability(folder_name)
% "the data were resampled using random draws with replacement, while taking care to
% maintain the substructure of the data.

% For example, the variability in threshold measurements would
% be estimated by resampling the data in a block of behavioral data
% 1,000 times. The responses at each coherence were drawn from
% the original data set at that particular coherence with replacement, making sure that
% the number of bootstrapped trials at that coherence matched that obtained behaviorally.
% This was done at all coherences to generate one estimate ofthe bootstrapped behavioral data
% to generate one threshold. The same procedure was repeated 1,000 times to generate 1,000
% estimates of threshold, so that the variability of the threshold could be determined." -Dylla et al. 2013
%folder_name=folder_name;
%cd test_data
n_permutations=1;
%n_permutations=100;
%chosen_threshold=0.72;
max_n_coherences=11;
%Path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/AUD_Only_Experiment/test_data/' ;% wherever you want to search
Path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/Alv mcs 083123 to 092123/' ;% wherever you want to search
combine_blocks=0;
%condition: 1=visual, 2=auditory, 3=AV
%in AV data files for coherence column (8), first value in double is aud,
%second is vis
if combine_blocks==1
    [temp_master_dataout,column_titles,totalfiles_names] = combine_data_acrossblocks(Path);
    n_files=1;
    master_dataout=cell(1,1);
    master_dataout{1,1}=temp_master_dataout;
else
    [master_dataout,column_titles,totalfiles_names] = load_blockdata_separately(Path) ;
    n_files=size(master_dataout,2);
    close all

end
%011323=A only, 012023=V only, 021023=A and V only, 021623=A,V,AV
%for mixed modality blocks, separate each modality's trials into separate
%"files"
new_filecount=0;
separateconditions_master_dataout=cell(1,1);
for i_file=1:n_files
    
    if length(master_dataout{i_file}(1,:))>10%check to see if there is a column indicating modality
        [AUD_dataout, VIS_dataout,AV_dataout] = modality_condition_splitter(master_dataout{i_file});
        if size(AUD_dataout,1)>1
            new_filecount=new_filecount+1;
            totalfiles_names_separated_conditions{new_filecount}=horzcat('AUD_',totalfiles_names{i_file});
            AUD_dataout(strcmp(AUD_dataout(:,6),'N/A'),:)=[]; %delete rows where subject quit before target presented

            %AUD_dataout(strcmp(AUD_dataout(:,10),'N/A'),:)=[]; %delete rows where subject didnt fixate on the presented target.
            %commented out bc of error in this column for aud only conditions btwn 1/11/23 and 2/15/23
            separateconditions_master_dataout{new_filecount}=AUD_dataout;
        end
        if size(VIS_dataout,1)>1
            new_filecount=new_filecount+1;
            totalfiles_names_separated_conditions{new_filecount}=horzcat('VIS_',totalfiles_names{i_file});
            separateconditions_master_dataout{new_filecount} = delete_failed_trials(VIS_dataout);
            
        end
        if size(AV_dataout,1)>1
            new_filecount=new_filecount+1;
            totalfiles_names_separated_conditions{new_filecount}=horzcat('AV__',totalfiles_names{i_file}); %add additional underscore so that modality is also 3 characters long
            separateconditions_master_dataout{new_filecount} = delete_failed_trials(AV_dataout);
                        
        end
    else %if no column indicating modality, add one and do the same things
        master_dataout{i_file}(1,11)={'Stimulus Modality'};
        switch master_dataout{i_file}{1,4}
            case 'Visual Reward'
                column_titles=master_dataout{i_file}(1,:);
                new_filecount=new_filecount+1;
                totalfiles_names_separated_conditions{new_filecount}=horzcat('VIS_',totalfiles_names{i_file});
                master_dataout{i_file}(2:end,11)={'VIS'};
                separateconditions_master_dataout{new_filecount} = delete_failed_trials(master_dataout{i_file});
            case 'Auditory Reward'
                new_filecount=new_filecount+1;
                column_titles=master_dataout{i_file}(1,:);

                if sum(ismember(cell2mat(master_dataout{i_file}(2:end,9)),180))==0
                    totalfiles_names_separated_conditions{new_filecount}=horzcat('AUD_',totalfiles_names{i_file});
                    master_dataout{i_file}(2:end,11)={'AUD'};
                else
                    totalfiles_names_separated_conditions{new_filecount}=horzcat('VIS_',totalfiles_names{i_file});
                    master_dataout{i_file}(2:end,11)={'VIS'};
                end
                master_dataout{i_file}(strcmp(master_dataout{i_file}(:,6),'N/A'),:)=[]; %delete rows where subject quit before target presented

                %[master_dataout{i_file}] = delete_failed_trials(master_dataout{i_file})
                separateconditions_master_dataout{new_filecount}=master_dataout{i_file};
            case 'Stimulus Reward'
                column_titles=master_dataout{i_file}(1,:);
                new_filecount=new_filecount+1;
                totalfiles_names_separated_conditions{new_filecount}=horzcat('AV__',totalfiles_names{i_file});%add additional underscore so that modality is also 3 characters long
                master_dataout{i_file}(2:end,11)={'AV'};
                separateconditions_master_dataout{new_filecount} = delete_failed_trials(master_dataout{i_file})
        end
    end
end
n_newfiles=size(separateconditions_master_dataout,2);

thresholds_per_permutation=nan(n_permutations,n_newfiles);
slopes_per_permutation=nan(n_permutations,n_newfiles);
std_slopes_per_permutation=nan(n_permutations,n_newfiles);

mean_thresholds=nan(1,n_newfiles);
mean_slopes=nan(1,n_newfiles);
std_slopes=nan(1,n_newfiles);
min_max_slopes=nan(1,2,n_newfiles);

std_thresholds=nan(1,n_newfiles);
median_thresholds=nan(1,n_newfiles);
file_std_slope=nan(1,n_newfiles);

for i_newfile=1:n_newfiles
    newfile_dataout=separateconditions_master_dataout{i_newfile};
    newfile_condition=totalfiles_names_separated_conditions{i_newfile}(1:2);
    switch newfile_condition
        case 'VI'
            condition=1;
           % [newfile_dataout]=convert_vis_directioncode(newfile_dataout);
            file_coherences=cell2mat(newfile_dataout(2:end,8));
            [n_per_coherence, coherences] = groupcounts(file_coherences);
            n_coherences=length(coherences);
            [permutation_slope_at_50_percent,file_slope_VIS,file_std_slope_VIS,file_mu_VIS,file_curve_xvals_VIS,file_curve_yvals_VIS,file_threshold_VIS,file_prob_VIS] = get_threshold_combinedblocks(newfile_dataout,coherences',totalfiles_names_separated_conditions(i_newfile),condition,0);
           % [file_fit_mean_midpoint_VIS,file_slope_VIS,file_std_slope_VIS,file_curve_xvals_VIS,file_curve_yvals_VIS,~,file_threshold_VIS,file_prob_VIS] = get_threshold_combinedblocks(newfile_dataout,coherences',totalfiles_names_separated_conditions(i_newfile),condition,chosen_threshold,0);
            
        case 'AU'
            condition=2;
            file_coherences=cell2mat(newfile_dataout(2:end,8));
            [n_per_coherence, coherences] = groupcounts(file_coherences);
            n_coherences=length(coherences);
            %[file_fit_mean_midpoint_AUD,file_slope_AUD,file_std_slope_AUD,file_curve_xvals_AUD,file_curve_yvals_AUD,~,file_threshold_AUD,file_prob_AUD] = get_threshold_combinedblocks(newfile_dataout,coherences',totalfiles_names_separated_conditions(i_newfile),condition,chosen_threshold,0);
            [permutation_slope_at_50_percent,file_slope_AUD,file_std_slope_AUD,file_mu_AUD,file_curve_xvals_AUD,file_curve_yvals_AUD,file_threshold_AUD,file_prob_AUD] = get_threshold_combinedblocks(newfile_dataout,coherences',totalfiles_names_separated_conditions(i_newfile),condition,0);
           
        case 'AV'
            condition=3;
            file_coherences=cell2mat(newfile_dataout(2:end,8));
            [n_per_coherence, coherences] = groupcounts(file_coherences); %n_per_coherence in this case is n per unique coherence combos (still gives you column vector of these vals), and coherences gives you a cell per coherence column
            coherences=horzcat(coherences{:}); %convert separate coherence columns into array with each row being each unique coherence combo, corresponding to rows in n_per_coherence
            n_coherences=size(coherences,1); %n_coherences is number of unique coherence combos
            %[file_fit_mean_midpoint_AV,file_slope_AV,file_std_slope_AV,file_curve_xvals_AV,file_curve_yvals_AV,~,file_threshold_AV,file_prob_AV] = get_threshold_combinedblocks(newfile_dataout,coherences',totalfiles_names_separated_conditions(i_newfile),condition,chosen_threshold,0);
            [permutation_slope_at_50_percent,file_slope_AV,file_std_slope_AV,file_mu_AV,file_curve_xvals_AV,file_curve_yvals_AV,file_threshold_AV,file_prob_AV] = get_threshold_combinedblocks(newfile_dataout,coherences',totalfiles_names_separated_conditions(i_newfile),condition,0);

    end
    newfile_dataout=newfile_dataout(2:end,:);
    
    for i_permutation=1:n_permutations %how many times you want to get a threshold from resampled data
        permutation_dataout=column_titles;
        for i_coherence=1:n_coherences %for each coherence in data
            n_trials_in_icoherence=n_per_coherence(i_coherence,1);
            trial_coherences=cell2mat(newfile_dataout(:,8));
            icoherence_dataout=newfile_dataout(trial_coherences(:,1)==coherences(i_coherence,1),:);
            rand_index = randsample(1:n_trials_in_icoherence, n_trials_in_icoherence, true); %get index of randomly sampled trials with replacement
            permutation_dataout=vertcat(permutation_dataout,icoherence_dataout(rand_index,:));
        end %for each coherence
        [permutation_slope_at_50_percent,permutation_slope,permutation_standarddeviation_slope,mu,curve_xvals,curve_yvals,permutation_threshold,prob] = get_threshold_combinedblocks(permutation_dataout,coherences',totalfiles_names,condition,0);
    %    [permutation_fit_mean_midpoint,permutation_slope,permutation_standarddeviation_slope,permutation_curve_xvals,permutation_curve_yvals,permutation_threshold,permutation_prob] = get_threshold_combinedblocks(permutation_dataout,coherences',totalfiles_names,condition,chosen_threshold,0);
        slopes_per_permutation(i_permutation,i_newfile)=permutation_slope;
        std_slopes_per_permutation(i_permutation,i_newfile)=permutation_standarddeviation_slope;
        
        if size(permutation_threshold,2)~=0
            thresholds_per_permutation(i_permutation,i_newfile)=permutation_threshold;
        end
    end %for i_permutations
    mean_thresholds(1,i_newfile)=mean(thresholds_per_permutation(~isnan(thresholds_per_permutation)));
    mean_slopes(1,i_newfile)=mean(slopes_per_permutation(~isnan(slopes_per_permutation)));
    min_max_slopes(1,1,i_newfile)=min(slopes_per_permutation(~isnan(slopes_per_permutation)));
    min_max_slopes(1,2,i_newfile)=max(slopes_per_permutation(~isnan(slopes_per_permutation)));

    std_slopes(1,i_newfile)=mean(std_slopes_per_permutation(~isnan(std_slopes_per_permutation)));
    std_thresholds(1,i_newfile)=std(thresholds_per_permutation(~isnan(thresholds_per_permutation)));
    median_thresholds(1,i_newfile)=median(thresholds_per_permutation(~isnan(thresholds_per_permutation)));
    median_std_slopes(1,i_newfile)=median(std_slopes_per_permutation(~isnan(std_slopes_per_permutation)));

end
%[n_trials_with_response,n_trials_with_reward,proportion_response_reversals_after_correct_response,proportion_response_reversals_after_incorrect_response] = response_reversal_proportions_mixedmodality(dataout)
totalfiles_names_separated_conditions
mean_thresholds
mean_slopes
min_max_slopes=squeeze(min_max_slopes(1,:,:))

std_slopes
std_thresholds
median_thresholds
%% plot change in threshold a
%%get an array of dates corresponding to each value  
file_date_cells = cellfun(@(x) x(5:10), totalfiles_names_separated_conditions, 'UniformOutput', false);
% Convert the date strings into date format
file_dates = cellfun(@(x) datestr(datetime(x, 'InputFormat', 'MMddyy'), 'mm_dd_yy'), file_date_cells, 'UniformOutput', false);
%%get the block number corresponding to each data file
block_nums = cellfun(@(x) x(end-4), totalfiles_names_separated_conditions, 'UniformOutput', false);
block_nums = string(block_nums);
%%get string indicatingwhether file is A,V,or AV
file_condition_strings = string(cellfun(@(x) x(1:3), totalfiles_names_separated_conditions, 'UniformOutput', false));
%%get numerical array with corresponding condition values
file_condition_number = categorical(file_condition_strings, {'VIS', 'AUD', 'AV_'});% Convert the string array to a categorical array
file_condition_number = transpose(grp2idx(file_condition_number));% Convert the categorical array to numeric indices

% Sort the dates in ascending order
[sorted_dates, idx] = sort(datetime(file_dates, 'InputFormat', 'MM_dd_yy'));
sorted_mean_slopes = mean_slopes(idx);
sorted_std_slopes = std_slopes(idx);
sorted_mean_thresholds = mean_thresholds(idx);
sorted_std_thresholds = std_thresholds(idx);

sorted_file_condition_number = file_condition_number(idx);

% Create a new figure and axes
fig = figure();
ax = axes(fig);

% Define a color map for the different file_condition_number values
color_map = containers.Map({'1', '2', '3'}, {[0 0.4470 0.7410], [0.8500 0.3250 0.0980], [0.4660 0.6740 0.1880]});
colors = [
    0.2 0.2 1;   % blue
    1 0.2 0.2;   % red
    0 0.7 0;  ] ;  % green
% Plot mean_slopes with error bars
hold(ax, 'on');
visual_pts = [];
auditory_pts = [];
av_pts = [];
for i = 1:length(sorted_dates)
    x = datenum(sorted_dates(i));
    y = sorted_mean_slopes(i);
    err = sorted_std_slopes(i);
    c = color_map(string(sorted_file_condition_number(i)));
    plot(ax, x, y, '.', 'MarkerSize', 30, 'MarkerEdgeColor', c ,'MarkerFaceColor', c);
    
    h = errorbar(ax, x, y, err, 'o', 'MarkerSize', 6, 'Color', c, 'LineWidth', 1.5, 'DisplayName', '');
% add the data point to the appropriate category
    if sorted_file_condition_number(i) == 1
        visual_pts = [visual_pts h];
    elseif sorted_file_condition_number(i) == 2
        auditory_pts = [auditory_pts h];
    elseif sorted_file_condition_number(i) == 3
        av_pts = [av_pts h];
    end
end

% Set x-axis labels to the values in file_dates
xticks(ax, unique(datenum(sorted_dates)));
xticklabels(ax, unique(file_date_cells(idx),'stable'));
xtickangle(ax, 45);
%ylim([0.2 0.4]);

% Set the title and axis labels
title(ax, sprintf('Mean Slopes Across %d Permutations',n_permutations));
xlabel(ax, 'Date');
ylabel(ax, 'Mean Slope');

% Adjust the figure properties
grid(ax, 'on');
set(ax, 'FontSize', 22);
set(fig, 'Position', [100 100 1000 500]);
% create the legend with one entry per category

%legend([visual_pts(1) auditory_pts(1) av_pts(1)], {'Visual', 'Auditory', 'AV'},'Location', 'Best');
%legend([auditory_pts(1)], 'Auditory','Location', 'Best');

legend([visual_pts(1) auditory_pts(1) ], {'Visual', 'Auditory'},'Location', 'Best');

%%%%threshold fig

% Create a new figure and axes
fig = figure();
ax = axes(fig);

% Define a color map for the different file_condition_number values

% Plot mean_thresh with error bars
hold(ax, 'on');
visual_pts = [];
auditory_pts = [];
av_pts = [];
for i = 1:length(sorted_dates)
    x = datenum(sorted_dates(i));
    y = sorted_mean_thresholds(i);
    err = sorted_std_thresholds(i);
    c = color_map(string(sorted_file_condition_number(i)));
    plot(ax, x, y, '.', 'MarkerSize', 30, 'MarkerEdgeColor', c ,'MarkerFaceColor', c);
    
    h = errorbar(ax, x, y, err, 'o', 'MarkerSize', 6, 'Color', c, 'LineWidth', 1.5, 'DisplayName', '');
% add the data point to the appropriate category
    if sorted_file_condition_number(i) == 1
        visual_pts = [visual_pts h];
    elseif sorted_file_condition_number(i) == 2
        auditory_pts = [auditory_pts h];
    elseif sorted_file_condition_number(i) == 3
        av_pts = [av_pts h];
    end
end

% Set x-axis labels to the values in file_dates
xticks(ax, unique(datenum(sorted_dates)));
xticklabels(ax, unique(file_date_cells(idx),'stable'));
xtickangle(ax, 45);
%ylim([0.4 2]);
%ylim([0 4]);
% Set the title and axis labels
title(ax, 'Mean Thresholds (std of cumulative gaussian)');
xlabel(ax, 'Date');
ylabel(ax, 'Mean Threshold');

% Adjust the figure properties
grid(ax, 'on');
set(ax, 'FontSize', 22);
set(fig, 'Position', [100 100 1000 500]);
% create the legend with one entry per category
%legend([visual_pts(1) auditory_pts(1) av_pts(1)], {'Visual', 'Auditory', 'AV'},'Location', 'Best');
legend([visual_pts(1) auditory_pts(1) ], {'Visual', 'Auditory'},'Location', 'Best');
%legend([auditory_pts(1)], 'Auditory','Location', 'Best');
