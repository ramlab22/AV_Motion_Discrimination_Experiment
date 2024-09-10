function plotMixedEffectsPCAResults(condition_table, formula, interaction)
    % plotMixedEffectsPCAResults Plots the results of a mixed-effects model with PCA.
    %
    % This function fits a mixed-effects model using PCA to address multicollinearity,
    % and then creates plots to visualize the explained variance, PCA loadings, and
    % the contributions of the original variables to the dependent variable (slope)
    % through the principal components.
    %
    % Parameters:
    % - condition_table: Input table containing the data.
    % - formula: Initial formula for the mixed-effects model.
    % - interaction: Boolean indicating whether to include two-way interactions
    %                among the principal components.
    %
    % Usage:
    %   % Define the initial formula
    %   initial_formula = 'slope ~ velocity + duration + displacement + (1|subjectID)';
    %
    %   % Plot the results without interactions
    %   plotMixedEffectsPCAResults(condition_table, initial_formula, false);
    %
    %   % Plot the results with two-way interactions
    %   plotMixedEffectsPCAResults(condition_table, initial_formula, true);
    %
    % Example:
    %   % Define the initial formula excluding duration
    %   formula_noduration = 'slope ~ velocity + displacement + (1|subjectID)';
    %
    %   % Plot the results without interactions
    %   plotMixedEffectsPCAResults(condition_table, formula_noduration, false);
    %
    %   % Plot the results with two-way interactions
    %   plotMixedEffectsPCAResults(condition_table, formula_noduration, true);
    %
    % See also: fitlme, pca

    % Fit the mixed-effects model with PCA
    lme_pca = fitMixedEffectsPCA(condition_table, formula, interaction);

    % Extract explained variance, PCA loadings, and fixed effects coefficients
    predictor_vars = regexp(formula, '\w+', 'match');
    predictor_vars = setdiff(predictor_vars, {'slope', 'subjectID', '1'});
    predictors = condition_table{:, predictor_vars};
    standardized_predictors = zscore(predictors);
    [coeff, score, ~, ~, explained] = pca(standardized_predictors);
    explained_variance_threshold = 95;
    cumulative_explained = cumsum(explained);
    num_components = find(cumulative_explained >= explained_variance_threshold, 1);
    selected_scores = score(:, 1:num_components);

    % Plot explained variance
    figure;
    bar(explained);
    xlabel('Principal Component');
    ylabel('Explained Variance (%)');
    title('Explained Variance by Each Principal Component');
    ax = gca;
    ax.FontSize = 20;
    if min(explained) < 0
        ylim([min(explained) - 10, max(explained) + 10]);
    else
        ylim([0, max(explained) + 10]);
    end

    % Plot loadings of each predictor on principal components
    figure;
    bar(coeff(:, 1:num_components)');
    xlabel('Principal Components');
    ylabel('Loadings');
    title('Loadings of Each Predictor on Principal Components');
    set(gca, 'XTickLabel', arrayfun(@(x) sprintf('PC%d', x), 1:num_components, 'UniformOutput', false));
    legend(predictor_vars, 'Location', 'best');
    ax = gca;
    ax.FontSize = 20;

    % Plot fixed effects coefficients
    figure;
    fixed_effects_estimates = lme_pca.Coefficients.Estimate;
    fixed_effects_names = lme_pca.Coefficients.Name;
    bar(fixed_effects_estimates);
    set(gca, 'XTickLabel', fixed_effects_names);
    xlabel('Fixed Effects');
    ylabel('Coefficients');
    title('Fixed Effects Coefficients');
    ax = gca;
    ax.FontSize = 20;

    if interaction ~= 1 % if no interaction term
        % Plot fixed effects contributions by each motion parameter
        contributions = zeros(num_components, length(predictor_vars));
        for i = 1:num_components
            for j = 1:length(predictor_vars)
                contributions(i, j) = coeff(j, i) * fixed_effects_estimates(i+1);
            end
        end

        figure;
        bar(contributions);
        set(gca, 'XTickLabel', arrayfun(@(x) sprintf('PC%d', x), 1:num_components, 'UniformOutput', false));
        xlabel('Principal Components');
        ylabel('Fixed Effects Contributions');
        title('Contribution of Motion Parameters to Perceptual Sensitivity');
        legend(predictor_vars, 'Location', 'best');
        ax = gca;
        ax.FontSize = 20;

        % Calculate and plot overall contributions
        explained_normalized = explained(1:num_components) / sum(explained(1:num_components));
        explained_normalized = repmat(explained_normalized, 1, length(predictor_vars));
        overall_contributions = sum(contributions(1:num_components, :) .* explained_normalized, 1);
        figure;
        bar(overall_contributions, 'FaceColor', 'flat');
        hold on;
        colors = get(gca, 'ColorOrder');
        disp('Overall Contribution to Motion Sensitivity:');
        for i = 1:length(overall_contributions)
            bar(i, overall_contributions(i), 'FaceColor', colors(i, :));
            fprintf('  %s: %.4f\n', predictor_vars{i}, overall_contributions(i));
        end
        set(gca, 'XTick', 1:length(overall_contributions));
        set(gca, 'XTickLabel', predictor_vars);
        xlabel('Predictors');
        ylabel('Overall Contribution');
        title('Overall Contribution of Each Predictor to Slope');
        ax = gca;
        ax.FontSize = 20;
    else % if interaction = 1
        % Plot fixed effects contributions by each motion parameter
        figure;
        contributions = zeros(num_components + interaction, length(predictor_vars));
        for i = 1:num_components
            for j = 1:length(predictor_vars)
                contributions(i, j) = coeff(j, i) * fixed_effects_estimates(i+1);
            end
        end
        if interaction && num_components >= 2
            interaction_contributions = zeros(length(predictor_vars), 1);
            for j = 1:length(predictor_vars)
                interaction_contributions(j) = coeff(j, 1) * coeff(j, 2) * fixed_effects_estimates(num_components + 1);
            end
            contributions(num_components + 1, :) = interaction_contributions;
        end

        bar(contributions', 'grouped');
        set(gca, 'XTickLabel', {'PC1', 'PC2', 'PC1*PC2'});
        xlabel('Principal Components');
        ylabel('PCA Coefficient * MEM Coefficient');
        title('Contribution of Motion Parameters to Perceptual Sensitivity');
        legend(predictor_vars, 'Location', 'best');
        ax = gca;
        ax.FontSize = 20;
    end

    resizeFigures();

    % Function to fit mixed-effects model with PCA
    function lme_pca = fitMixedEffectsPCA(condition_table, formula, interaction)
        % Extract predictors from the formula
        predictor_vars = regexp(formula, '\w+', 'match');
        predictor_vars = setdiff(predictor_vars, {'slope', 'subjectID', '1'});

        % Extract predictors from the table
        predictors = condition_table{:, predictor_vars};

        % Standardize the predictors
        standardized_predictors = zscore(predictors);

        % Perform PCA
        [coeff, score, ~, ~, explained] = pca(standardized_predictors);

        % Display the explained variance
        disp('Explained variance by each component:');
        disp(explained);

        % Select principal components that explain 95% of the variance
        explained_variance_threshold = 95;
        cumulative_explained = cumsum(explained);
        num_components = find(cumulative_explained >= explained_variance_threshold, 1);

        % Select the scores of the chosen principal components
        selected_scores = score(:, 1:num_components);

        % Create a new table with the principal components and other variables
        pca_table = condition_table;
        for i = 1:num_components
            pca_table.(['PC', num2str(i)]) = selected_scores(:, i);
        end

        % Define the formula for the mixed-effects model using the principal components
        fixed_effects = '';
        for i = 1:num_components
            fixed_effects = [fixed_effects, 'PC', num2str(i)];
            if i < num_components
                fixed_effects = [fixed_effects, ' + '];
            end
        end

        if interaction && num_components >= 2
            % Add interaction terms between principal components
            fixed_effects = [fixed_effects, '+ PC1*PC2'];
        end

        % Extract the random effects part from the initial formula
        random_effects = regexp(formula, '\(.*\)', 'match', 'once');

        % Combine fixed and random effects into the final formula
        pca_formula = ['slope ~ 1 + ', fixed_effects, ' + ', random_effects];

        % Fit the mixed-effects model
        lme_pca = fitlme(pca_table, pca_formula);

        % Display the results
        disp(lme_pca);

        % Display the PCA loadings in a table
        disp('PCA Loadings (Coefficients):');
        loading_table = array2table(coeff(:, 1:num_components), 'VariableNames', ...
            arrayfun(@(x) sprintf('PC%d', x), 1:num_components, 'UniformOutput', false), ...
            'RowNames', predictor_vars);
        disp(loading_table);

        disp('Interpretation of Fixed Effects:');
        fixed_effects_estimates = lme_pca.Coefficients.Estimate;
        for i = 1:num_components
            fprintf('Effect of PC%d:\n', i);
            for j = 1:length(predictor_vars)
                fprintf('  %s: %.4f\n', predictor_vars{j}, coeff(j, i) * fixed_effects_estimates(i+1));
            end
        end

        % Display the interpretation for interaction terms if present
        if interaction && num_components >= 2
            interaction_index = num_components + 1;
            fprintf('Effect of PC1*PC2:\n');
            for j = 1:length(predictor_vars)
                fprintf('  %s: %.4f\n', predictor_vars{j}, coeff(j, 1) * coeff(j, 2) * fixed_effects_estimates(interaction_index));
            end
        end
    end
end
