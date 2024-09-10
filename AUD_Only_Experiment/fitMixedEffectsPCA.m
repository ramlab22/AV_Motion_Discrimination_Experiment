function lme_pca = fitMixedEffectsPCA(condition_table, formula, interaction)
    % Fit a mixed-effects model with PCA to address multicollinearity
    % Parameters:
    % - condition_table: input table with the data
    % - formula: initial formula for the mixed-effects model
    % - interaction: boolean indicating whether to include two-way interactions
    
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

        if interaction
            if num_components == 2
                fixed_effects = [fixed_effects, ' + PC1*PC2'];
            elseif num_components == 3
                fixed_effects = [fixed_effects, ' + PC1*PC2 + PC1*PC3 + PC2*PC3'];
            else
                % Include all possible 2-way interactions for more than 3 components
                for i = 1:num_components-1
                    for j = i+1:num_components
                        fixed_effects = [fixed_effects, ' + PC', num2str(i), '*PC', num2str(j)];
                    end
                end
            end
        end

        % Extract the random effects part from the initial formula
        random_effects = regexp(formula, '\(.*\)', 'match', 'once');

        % Combine fixed and random effects into the final formula
        pca_formula = ['slope ~ ', fixed_effects, ' + ', random_effects];

        % Fit the mixed-effects model
        lme_pca = fitlme(pca_table, pca_formula);

        % Display the results
        disp(lme_pca);

        % Display the PCA loadings
        disp('PCA Loadings (Coefficients):');
        disp(coeff(:, 1:num_components));

        % Display the interpretation
        disp('Interpretation of Fixed Effects:');
        fixed_effects_estimates = lme_pca.Coefficients.Estimate;
        for i = 1:num_components
            fprintf('Effect of PC%d:\n', i);
            for j = 1:length(predictor_vars)
                fprintf('  %s: %.4f\n', predictor_vars{j}, coeff(j, i) * fixed_effects_estimates(i+1));
            end
        end
    end