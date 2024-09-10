function pca_table=compareRegressionModelToData(lm_pca, pca_table, num_components)
    % compareRegressionModelToData Generates slopes based on the model and compares them to the actual data.
    %
    % Parameters:
    % - lm_pca: The linear regression model object.
    % - pca_table: The table containing the principal components and original variables.
    % - num_components: The number of principal components used in the model.
    %
    % This function generates slopes based on the model and compares them to the actual data.
    % It plots the predicted vs actual slopes to visualize the model fit.

    % Generate predicted slopes based on the model
    [predicted_slopes, CI] = predict(lm_pca, pca_table);
    pca_table.predicted_slopes=predicted_slopes;
    pca_table.CI_low=CI(:,1);
    pca_table.CI_high=CI(:,2);

    % Extract actual slopes
    actual_slopes = pca_table.slope;

    % Extract unique subject IDs
    unique_subjects = unique(pca_table.subjectID);

    % Define marker shapes
    marker_shapes = {'o', '^', 's', 'd', 'v', '>', '<', 'p', 'h'};
    num_shapes = length(marker_shapes);
    num_subjects = length(unique_subjects);

    % Check if number of unique subjects exceeds available marker shapes
    if num_subjects > num_shapes
        error('Number of unique subjects exceeds available marker shapes.');
    end

    % Define colors based on the values of duration, displacement, and velocity
    colors = zeros(size(pca_table, 1), 3); % Initialize colors array
    for i = 1:size(pca_table, 1)
        duration = pca_table.duration(i);
        displacement = pca_table.displacement(i);
        velocity = pca_table.velocity(i);

        if duration == 0.834 && displacement == 22 && velocity == 59.95
            colors(i, :) = [1, 0, 1]; % Combination of red, blue, and yellow
        elseif duration == 0.834 && displacement == 22
            colors(i, :) = [0.5, 0, 0.5]; % Combination of red and blue (purple)
        elseif duration == 0.834 && velocity == 59.95
            colors(i, :) = [1, 0.5, 0]; % Combination of red and yellow (orange)
        elseif displacement == 22 && velocity == 59.95
            colors(i, :) = [0, 1, 0]; % Combination of blue and yellow (green)
        elseif duration == 0.834
            colors(i, :) = [1, 0, 0]; % Red
        elseif displacement == 22
            colors(i, :) = [0, 0, 1]; % Blue
        elseif velocity == 59.95
            colors(i, :) = [1, 1, 0]; % Yellow
        else
            colors(i, :) = [0, 0, 0]; % Default to black for unspecified conditions
        end
    end

    % Plot predicted vs actual slopes with confidence intervals
    figure;
    hold on;
    legend_entries = cell(1, num_subjects + 4);
    legend_handles = zeros(1, num_subjects + 4);

    for i = 1:num_subjects
        subject_mask = strcmp(pca_table.subjectID, unique_subjects{i});
        scatter(actual_slopes(subject_mask), predicted_slopes(subject_mask), ...
            'Marker', marker_shapes{i}, 'MarkerFaceColor', 'flat');
        % Save the legend entry
        legend_entries{i} = sprintf('Subject %s', unique_subjects{i});
        legend_handles(i) = scatter(nan, nan, 'Marker', marker_shapes{i}, 'MarkerFaceColor', 'k'); % Placeholder for legend
        % Plot confidence intervals
        for j = find(subject_mask)'
            line([actual_slopes(j), actual_slopes(j)], CI(j, :), 'Color', 'k');
            scatter(actual_slopes(j), predicted_slopes(j), 100, 'Marker', marker_shapes{i}, ...
                'MarkerFaceColor', colors(j, :), 'MarkerEdgeColor', 'k');
        end
    end

  %  plot([min(actual_slopes), max(actual_slopes)], [min(actual_slopes), max(actual_slopes)], 'r--');
 %   plot([0, 2.6], [0, 2.6], 'k--');
    plot([0,max([max(actual_slopes), max(predicted_slopes)])+.2], [0, max([max(actual_slopes) max(predicted_slopes)])+.2], 'k--');

    % Add additional legend entries for color coding
    legend_entries{num_subjects + 1} = 'Duration = 0.834 (Red)';
    legend_entries{num_subjects + 2} = 'Displacement = 22 (Blue)';
    legend_entries{num_subjects + 3} = 'Velocity = 59.95 (Yellow)';
    legend_entries{num_subjects + 4} = 'Combination Colors';
    legend_handles(num_subjects + 1) = scatter(nan, nan, 100, 'o', 'MarkerFaceColor', [1, 0, 0], 'MarkerEdgeColor', 'k');
    legend_handles(num_subjects + 2) = scatter(nan, nan, 100, 'o', 'MarkerFaceColor', [0, 0, 1], 'MarkerEdgeColor', 'k');
    legend_handles(num_subjects + 3) = scatter(nan, nan, 100, 'o', 'MarkerFaceColor', [1, 1, 0], 'MarkerEdgeColor', 'k');
    legend_handles(num_subjects + 4) = scatter(nan, nan, 100, 'o', 'MarkerFaceColor', [0.5, 0, 0.5], 'MarkerEdgeColor', 'k'); % Placeholder for combination colors
   % ylim([min([min(actual_slopes), min(predicted_slopes)]),max([max(actual_slopes), max(predicted_slopes)])]+.2);
   % xlim([min([min(actual_slopes), min(predicted_slopes)]),max([max(actual_slopes), max(predicted_slopes)])]+.2);
    hold off;

    xlabel('Actual Slopes');
    ylabel('Predicted Slopes');
    title('Model Fit: Predicted vs Actual Slopes with Confidence Intervals');
    ax = gca;
    ax.FontSize = 20;
    legend(legend_handles, legend_entries, 'Location', 'best');
    resizeFigures();
end
