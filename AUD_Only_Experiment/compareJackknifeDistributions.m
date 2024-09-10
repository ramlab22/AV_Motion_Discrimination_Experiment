function results = compareJackknifeDistributions(slope_distributions, totalfiles_names)
%COMPAREJACKKNIFEDISTRIBUTIONS Compares pairs of slope distributions.
%
% Syntax: results = compareJackknifeDistributions(slope_distributions, totalfiles_names)
%
% This function takes a cell array of slope distributions, where each cell
% corresponds to a different file and contains a distribution of slopes,
% and a cell array with the names of these files. It performs a Wilcoxon
% rank sum test on each possible pairing of these distributions. Multiple
% comparison corrections are made using the Benjamini-Hochberg procedure.
% It returns a structure indicating which file pairings have significantly
% different distributions.
%
% Inputs:
%   slope_distributions - A 1xn cell array, each containing a 1xj array of doubles
%   totalfiles_names - A cell array of strings, each corresponding to the names of the files in slope_distributions
%
% Outputs:
%   results - A struct containing the pair names and their corresponding p-values and whether they are significant after correction
%
% Example:
%   results = compareJackknifeDistributions({[0.1, 0.2], [0.1, 0.4], [0.5, 0.6]}, {'file1', 'file2', 'file3'});
%   disp(results)
alpha = 0.05; % You can adjust the alpha level as needed
n = length(slope_distributions);
pvals = ones(n); % Initialize with ones (assuming non-significance as default)
for i = 1:n
    filename_x{i}=totalfiles_names{i};
    for j = i+1:n
        filename_y{j}=totalfiles_names{j};
        pvals(i, j) = ranksum(slope_distributions{i}, slope_distributions{j});
        pvals(j, i) = pvals(i, j); % Symmetric matrix
        filename_grid{i,j} = [totalfiles_names{i}, ' vs ', totalfiles_names{j}];
        filename_grid{j,i} = [totalfiles_names{i}, ' vs ', totalfiles_names{j}];
    end
end
raw_pvals_significance = pvals <= alpha;

disp('Raw p-values:');
disp(pvals);

% Assuming pvals is the matrix of pairwise p-values
alpha = 0.05; % You can adjust the alpha level as needed
[logical, ~, adj_pvals_bhfdr] = fdr_bh(pvals, alpha);

disp('Benjamini-Hochberg adjusted p-values:');
disp(adj_pvals_bhfdr(:,1:n));

[logical_holmbonferroni, adj_pvals_holmbonferroni] = holm_bonferroni(pvals, alpha);
disp('holm-bonferroni adjusted p-values:');
disp(adj_pvals_holmbonferroni);

[velocities, ~,~] = extract_file_parameters(filename_x);
generate_pval_heatmaps(velocities, pvals, adj_pvals_bhfdr, adj_pvals_holmbonferroni);

% Prepare output
results = struct();
k = 1;
for i = 1:n
    for j = i+1:n
        if logical(i, j)
            results(k).files = [totalfiles_names{i}, ' vs ', totalfiles_names{j}];
            
            results(k).bhfdr_adj_pValue = adj_pvals_bhfdr(i, j);
            results(k).bhfdr_adj_significant = 'Yes';
            k = k + 1;
        else
            results(k).files = [totalfiles_names{i}, ' vs ', totalfiles_names{j}];
            results(k).bhfdr_adj_pValue = adj_pvals_bhfdr(i, j);
            results(k).bhfdr_adj_significant = 'No';
            k = k + 1;
        end
    end
end
k = 1;
for i = 1:n
    for j = i+1:n
        if raw_pvals_significance(i, j)
            results(k).raw_pValue = pvals(i, j);
            results(k).raw_significant = 'Yes';
            k = k + 1;
        else
            results(k).raw_pValue = pvals(i, j);
            results(k).raw_significant = 'No';
            k = k + 1;
        end
    end
end
k = 1;
for i = 1:n
    for j = i+1:n
        if logical_holmbonferroni(i, j)
            results(k).holmbonferroni_adj_pValue = adj_pvals_holmbonferroni(i, j);
            results(k).holmbonferroni_adj_significant = 'Yes';
            k = k + 1;
        else
            results(k).holmbonferroni_adj_pValue = adj_pvals_holmbonferroni(i, j);
            results(k).holmbonferroni_adj_significant = 'No';
            k = k + 1;
        end
    end
end
disp('comparisons:');
disp(filename_grid);

end
