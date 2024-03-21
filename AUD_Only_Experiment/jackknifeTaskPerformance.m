function [slope_variability, std_gaussian_variability, slope_at_50_percent_variability,slope_sd,std_gaussian_sd,slope_at_50_percent_sd] = jackknifeTaskPerformance(slope_per_date, std_gaussian_per_date, slope_at_50_percent_per_date)
%JACKKNIFETASKPERFORMANCE Quantifies variability (standard error)in task performance across sessions
%using jackknife resampling for slope, standard deviation of the Gaussian fit, 
%and slope at 50% threshold of the psychometric curve.
%
% The jackknife method, by systematically excluding one observation at a time,
% generates multiple estimates of the statistic of interest. The variability among
% these estimates gives insight into the stability of the statistic across samples.
% The standard error is a natural choice here because it reflects the precision of
% the estimate of the population parameter (e.g., the mean slope across sessions).
% It accounts for the sample size, which is particularly relevant when comparing
% the reliability of estimates derived from datasets of different sizes.
%
% We also calculated standard deviation across sessions in case you wanted to focus 
% on the variability across sessions of the data itself, rather than the 
% variability of an estimate of the mean. Standard deviation provides a
% measure of the spread of your data points around the mean, making it
% the appropriate statistic for understanding the variability in the
% actual measurements across sessions.
%
% Inputs:
%   slope_per_date - Array of slopes for the psychometric curve at each session.
%   std_gaussian_per_date - Array of standard deviations of the Gaussian fit for each session's curve.
%   slope_at_50_percent_per_date - Array of slopes at the 50% threshold for each session's curve.
%
% Outputs:
%   slope_variability - Variability (standard error) of the slope of the psychometric curve across sessions.
%   std_gaussian_variability - Variability (standard error) of the standard deviation of the Gaussian fit across sessions.
%   slope_at_50_percent_variability - Variability (standard error) of the slope at the 50% threshold across sessions.
%   slope_sd - Standard deviation of the slope of the psychometric curve across sessions.
%   std_gaussian_sd - Standard deviation of the Gaussian fit's standard deviation across sessions.
%   slope_at_50_percent_sd - Standard deviation of the slope at the 50% threshold across sessions.
%
% Example:
%   [sv, gv, spv, ssd, gsd, spsd] = jackknifeTaskPerformance(slope, stdGaussian, slope50Percent);
%   disp(['Slope Variability: ', num2str(sv)]);
%   disp(['Standard Deviation of Slope: ', num2str(ssd)]);
%
% Note:
%   This function is designed for analyzing the variability and standard deviation in task performance across multiple
%   sessions, providing both a measure of precision (variability) and spread (standard deviation) for key performance metrics.

n = length(slope_per_date); % Number of sessions
% Checks if there is only one session
if n == 1
    warning('Only one session provided. Variability cannot be estimated with a single session.');
    slope_variability = NaN;
    std_gaussian_variability = NaN;
    slope_at_50_percent_variability = NaN;
    return;
end
% Initialize arrays to store jackknife estimates
slope_jackknife = zeros(1, n);
std_gaussian_jackknife = zeros(1, n);
slope_at_50_percent_jackknife = zeros(1, n);

% Perform jackknife resampling for each parameter
for i = 1:n
    % Exclude the i-th session for slope
    slope_subset = slope_per_date([1:i-1, i+1:end]);
    slope_jackknife(i) = mean(slope_subset);
    
    % Exclude the i-th session for standard deviation
    std_gaussian_subset = std_gaussian_per_date([1:i-1, i+1:end]);
    std_gaussian_jackknife(i) = mean(std_gaussian_subset);
    
    % Exclude the i-th session for slope at 50% threshold
    slope_at_50_percent_subset = slope_at_50_percent_per_date([1:i-1, i+1:end]);
    slope_at_50_percent_jackknife(i) = mean(slope_at_50_percent_subset);
end

% Calculate the jackknife estimate of variability (standard error) for each measure
slope_variability = sqrt((n-1)/n * sum((slope_jackknife - mean(slope_jackknife)).^2));
std_gaussian_variability = sqrt((n-1)/n * sum((std_gaussian_jackknife - mean(std_gaussian_jackknife)).^2));
slope_at_50_percent_variability = sqrt((n-1)/n * sum((slope_at_50_percent_jackknife - mean(slope_at_50_percent_jackknife)).^2));

% Calculate the standard deviation directly for each measure across sessions
slope_sd = std(slope_per_date);
std_gaussian_sd = std(std_gaussian_per_date);
slope_at_50_percent_sd = std(slope_at_50_percent_per_date);

end
