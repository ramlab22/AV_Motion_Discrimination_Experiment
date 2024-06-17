function generate_pval_heatmaps(x_labels, raw_p_values, bh_p_values, holm_p_values)
%GENERATEHEATMAPS Generates heatmaps for statistical p-values
%
%   Inputs:
%       x_labels - A 1xN double array of axis labels
%       raw_p_values - An NxN double matrix of raw p-values
%       bh_p_values - An NxN double matrix of Benjamini-Hochberg adjusted p-values
%       holm_p_values - An NxN double matrix of Holm-Bonferroni adjusted p-values
%
%   This function creates three heatmaps in a single figure:
%   one for raw p-values, one for Benjamini-Hochberg adjusted p-values,
%   and one for Holm-Bonferroni adjusted p-values. Each heatmap uses a diverging
%   color map centered on a specific value, includes a color bar, and is square-shaped.
%   All titles, axes labels, and legend text are set to font size 22.

    % Sort the labels and data accordingly
    [sorted_labels, sortIdx] = sort(x_labels);
    sorted_raw_p_values = raw_p_values(sortIdx, sortIdx);
    sorted_bh_p_values = bh_p_values(sortIdx, sortIdx);
    sorted_holm_p_values = holm_p_values(sortIdx, sortIdx);
  % Calculate the appropriate caxis limits centered around center_val
    max_value = max([raw_p_values(:); bh_p_values(:); holm_p_values(:)]);
    center_val=0.1;
    min_value = 0; % Ensuring the scale starts from zero
    color_range = max(max_value - center_val, center_val - min_value);
    color_limits = [min_value, center_val + color_range]; % This keeps the scale non-negative
    % Create figure and subplots
    figure;
    
    % Subplot 1 for Raw p-values
    subplot(1,3,1);
    imagesc(sorted_raw_p_values);
    title('Raw p-values', 'FontSize', 22);
    % cb = colorbar;
    % cb.Label.String = 'p-value';
    % cb.Label.FontSize = 22;
    colormap('parula'); % Using 'parula' as an alternative diverging colormap
    caxis(color_limits); % Color axis limits
   % clim([0 1]);

    axis square; % Ensuring the heatmap is square-shaped
    set(gca, 'XTick', 1:length(x_labels), 'XTickLabel', sorted_labels, 'FontSize', 22);
    set(gca, 'YTick', 1:length(x_labels), 'YTickLabel', sorted_labels, 'FontSize', 22);

    % Subplot 2 for Benjamini-Hochberg Adjusted p-values
    subplot(1,3,2);
    imagesc(sorted_bh_p_values);
    title('Benjamini-Hochberg Adjusted p-values', 'FontSize', 22);
    % cb = colorbar;
    % cb.Label.String = 'p-value';
    % cb.Label.FontSize = 22;
    colormap('parula');
    caxis(color_limits);
   % clim([0 1]);

    axis square;
    set(gca, 'XTick', 1:length(x_labels), 'XTickLabel', sorted_labels, 'FontSize', 22);
    set(gca, 'YTick', 1:length(x_labels), 'YTickLabel', sorted_labels, 'FontSize', 22);

    % Subplot 3 for Holm-Bonferroni Adjusted p-values
    subplot(1,3,3);
    imagesc(sorted_holm_p_values);
    title('Holm-Bonferroni Adjusted p-values', 'FontSize', 22);
    axis square;

    cb = colorbar('eastoutside');
    cb.Label.String = 'p-value';
    cb.Label.FontSize = 22;
    colormap('parula');
    caxis(color_limits);
    %clim([0 1]);

    set(gca, 'XTick', 1:length(x_labels), 'XTickLabel', sorted_labels, 'FontSize', 22);
    set(gca, 'YTick', 1:length(x_labels), 'YTickLabel', sorted_labels, 'FontSize', 22);
resizeFigures();
end
