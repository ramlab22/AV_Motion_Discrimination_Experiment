Path= '/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_duration/';
n_permutations=20;
condition=2; %auditory
condition_names = getSubfolders(Path); 

for i_condition=1:length(condition_names)
    condition_path=horzcat(Path,condition_names{1,i_condition},'/');
    [condition_thresholds_per_permutation] = threshold_slope_variability(condition_path,n_permutations,condition);
    permutation_thresholds_all_conditions{i_condition}=condition_thresholds_per_permutation';
end
std_significant_pairs_Alv = compareJackknifeDistributions(permutation_thresholds_all_conditions, condition_names)
