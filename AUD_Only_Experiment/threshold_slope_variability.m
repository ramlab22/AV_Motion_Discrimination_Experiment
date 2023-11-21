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

todays_date=datetime(datetime(),'Format','MMddyy');
Path = '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/Alv_aud_dbSNR10_fixedspeakers/' ;% wherever you want to search
condition=2; %1=visual, 2=auditory, 3=AV
[master_dataout,column_titles,totalfiles_names] = combine_data_acrossblocks(Path);


master_dataout(strcmp(master_dataout(:,6),'N/A'),:)=[]; %delete rows where subject quit before target presented
master_coherences=[master_dataout{2:end,8}]';
[n_per_coherence, coherences] = groupcounts(master_coherences);
n_coherences=length(coherences);
[fit_mean_midpoint,fit_slope,slope_std,curve_xvals,curve_yvals,ci,master_threshold] = get_threshold_combinedblocks(master_dataout,coherences',totalfiles_names,condition,1);

%[n_trials_with_response,n_trials_with_reward,proportion_response_reversals_after_correct_response,proportion_response_reversals_after_incorrect_response] = response_reversal_proportions(master_dataout)    
master_dataout=master_dataout(2:end,:);
thresholds_per_permutation=nan(n_permutations,1);
slopes_per_permutation=nan(n_permutations,1);
std_slopes_per_permutation=nan(n_permutations,1);
n_permutations_without_threshold=0;
for i_permutation=1:n_permutations %how many times you want to get a threshold from resampled data
    permutation_dataout=column_titles;
    for i_coherence=1:n_coherences %for each coherence in data
        n_trials_in_icoherence=n_per_coherence(i_coherence,1);
        icoherence_dataout=master_dataout(cell2mat(master_dataout(:,8))==coherences(i_coherence),:);
        rand_index = randsample(1:n_trials_in_icoherence, n_trials_in_icoherence, true); %get index of randomly sampled trials with replacement
        permutation_dataout=vertcat(permutation_dataout,icoherence_dataout(rand_index,:));             
    end %for each coherence
    [permutation_slope_at_50_percent,permutation_slope,permutation_slope_std,mu,curve_xvals,curve_yvals,permutation_threshold,prob] = get_threshold_combinedblocks(permutation_dataout,coherences',totalfiles_names,condition,0);

    %[permutation_fit_mean_midpoint,permutation_slope,permutation_standarddeviation_slope,permutation_curve_xvals,permutation_curve_yvals,permutation_ci,permutation_threshold] = get_threshold_combinedblocks(permutation_dataout,coherences',totalfiles_names,condition,chosen_threshold,0);
    slopes_per_permutation(i_permutation,1)=permutation_slope;
    std_slopes_per_permutation(i_permutation,1)=permutation_slope_std;

    %skip permutations where there isnt a threshold, and count how many
    %this is true for
    if size(permutation_threshold,2)==0
        n_permutations_without_threshold=n_permutations_without_threshold+1;
    else
        thresholds_per_permutation(i_permutation,1)=permutation_threshold;
    end
end %for i_permutations
mean_threshold=mean(thresholds_per_permutation(~isnan(thresholds_per_permutation)))
mean_slope=mean(thresholds_per_permutation(~isnan(slopes_per_permutation)))
std_slope=mean(std_slopes_per_permutation(~isnan(std_slopes_per_permutation)))
std_threshold=std(thresholds_per_permutation(~isnan(thresholds_per_permutation)))
median_threshold=median(thresholds_per_permutation(~isnan(thresholds_per_permutation)))
