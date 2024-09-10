function [bootstrap_slopes,bootstrap_slope_sd,bootstrap_slope_mean,bootstrap_slope_SE,bootstrap_slope_median,save_name]=BootstrapUnisensorySlopeStats(Path,n_permutations,data_proportion_to_include)
% BootstrapUnisensorySlopeStats performs bootstrap analysis on unisensory slope data.
%
% This function combines data across blocks, performs a specified number of bootstrap permutations,
% and computes statistical metrics on the slope values obtained from the bootstrapped data.
%
% INPUTS:
%   Path - A string specifying the path to the data files.
%   n_permutations - An integer specifying the number of bootstrap permutations to perform.
%   data_proportion_to_include - A float specifying the proportion of data to include in each bootstrap sample.
%
% OUTPUTS:
%   bootstrap_slopes - A 1xn_permutations array containing the slope values obtained from each bootstrap permutation.
%   bootstrap_slope_sd - The standard deviation of the bootstrap slope values.
%   bootstrap_slope_mean - The mean of the bootstrap slope values.
%   bootstrap_slope_SE - The standard error of the bootstrap slope values.
%   bootstrap_slope_median - The median of the bootstrap slope values.
%   save_name - A string specifying the name used to save output or figures.
%
% Example:
%   [slopes, sd, mean, SE, median, save_name] = BootstrapUnisensorySlopeStats('data/path', 1000, 0.9);
%
% See also combine_data_acrossblocks, deduce_analysis_save_info, process_and_analyze_bootstrap_data.
%
% Author: Adriana Schoenhaut
% Date: 7/5/24

% Combine the data across the blocks
[dataout, column_titles, totalfiles_names] = combine_data_acrossblocks(Path);
dataout = dataout(2:end, :);

% Get name to save output or figs to
[~, save_name] = deduce_analysis_save_info(Path);

% Get the total number of rows in the combined data
total_dataout_rows = size(dataout, 1);

% Calculate the number of rows for the included proportion and left out portion splits
n_rows_included = round(data_proportion_to_include * total_dataout_rows);
n_rows_leftout = total_dataout_rows - n_rows_included;

bootstrap_slopes = zeros(1, n_permutations);

for i_permutation = 1:n_permutations
    slope_dynamicrange = NaN;
    while isnan(slope_dynamicrange)
        [data_included, data_leftout, prob_Right, prob_Left, audInfo, slope_dynamicrange, LR_xdata, LR_ydata, LR_curve_xvals, LR_curve_yvals] = process_and_analyze_bootstrap_data(dataout, n_rows_included, save_name);
    end
    % Store results for the current permutation
    bootstrap_slopes(1, i_permutation) = slope_dynamicrange;
    close all
end

% Calculate statistical metrics
bootstrap_slope_mean = mean(bootstrap_slopes);
bootstrap_slope_sd = std(bootstrap_slopes);
bootstrap_slope_SE = sqrt((n_permutations - 1) / n_permutations * sum((bootstrap_slopes - bootstrap_slope_mean).^2));
bootstrap_slope_median = median(bootstrap_slopes);

end % main function
