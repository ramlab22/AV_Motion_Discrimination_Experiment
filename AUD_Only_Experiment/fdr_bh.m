function [h, crit_p, adj_p] = fdr_bh(pvals, alpha)
%FDR_BH Benjamini-Hochberg procedure for controlling the false discovery rate
%
% This function controls the false discovery rate (FDR) at level alpha using
% the Benjamini-Hochberg procedure. It adjusts the p-values and returns
% which hypotheses are rejected.
%
% Inputs:
%   pvals - Matrix of observed p-values (each element should be between 0 and 1)
%   alpha - (Optional) Significance level (default 0.05)
%
% Outputs:
%   h - Logical matrix indicating which hypotheses are rejected
%   crit_p - Critical p-values for each test
%   adj_p - Adjusted p-values

if nargin < 2
    alpha = 0.05;
end

[n, m] = size(pvals);
vecPvals = reshape(pvals, n*m, 1);
sortedIndices = find(vecPvals > 0); % Find indices of non-zero p-values
sortedPvals = vecPvals(sortedIndices);
[sortedPvals, sortidx] = sort(sortedPvals);
thresholds = (1:length(sortedPvals))' * (alpha / (n*m));
adj_pvals = sortedPvals .* (n*m ./ (1:length(sortedPvals))');
adj_pvals = min(adj_pvals, 1); % Cap at 1 to not exceed valid p-value range
adj_p = ones(n*m, 1); % Default adjusted p-values to 1 (non-significant default)
adj_p(sortedIndices(sortidx)) = adj_pvals; % Place adjusted p-values back into their original positions
adj_p = reshape(adj_p, n, m); % Reshape to original matrix size

% Ensure the matrix is symmetric by copying the lower triangle to the upper triangle
adj_p = tril(adj_p) + triu(adj_p', 1);

h = adj_p <= alpha;
crit_p = ones(n, m); % Set all critical p-values to a default non-significant value
crit_p(sortedIndices(sortidx)) = thresholds; % Place the computed thresholds back into their original positions
crit_p = tril(crit_p) + triu(crit_p', 1); % Ensure symmetry for critical p-values

end
