function [h, adj_p] = holm_bonferroni(pvals, alpha)
% HOLM_BONFERRONI Holm-Bonferroni method for controlling the family-wise error rate
%
% Syntax: [h, adj_p] = holm_bonferroni(pvals, alpha)
%
% This function applies the Holm-Bonferroni correction method to a matrix
% of p-values for controlling the family-wise error rate. It sorts the
% p-values, adjusts them, and determines which hypotheses to reject.
%
% Inputs:
%   pvals - Matrix of observed p-values (each element should be between 0 and 1)
%   alpha - (Optional) Significance level (default is 0.05)
%
% Outputs:
%   h - Logical matrix indicating which hypotheses are rejected (1 if rejected)
%   adj_p - Matrix of adjusted p-values
%
% Example:
%   [h, adj_p] = holm_bonferroni(pvals);

if nargin < 2
    alpha = 0.05;
end

[n, m] = size(pvals);
vecPvals = reshape(pvals, n*m, 1);  % Convert matrix to vector
[sortedPvals, sortidx] = sort(vecPvals, 'ascend');  % Sort p-values in ascending order

adj_p = ones(n*m, 1);  % Initialize adjusted p-values to 1 (default non-significant)

% Apply Holm-Bonferroni correction
for i = 1:n*m
    adj_p(sortidx(i)) = min(sortedPvals(i) * (n*m - i + 1), 1);
end

adj_p = reshape(adj_p, n, m);  % Reshape back to original matrix size

% Determine which hypotheses are rejected
h = adj_p <= alpha;

end
