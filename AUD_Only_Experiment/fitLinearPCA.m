    function [lm_pca, pca_table, num_components] = fitLinearPCA(condition_table, formula, interaction)
        %% Function to fit linear regression model with PCA

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

        % Select the scores of the chosen principal components, rounded to
        % 12 digits after the decimal point
        selected_scores = round(score(:, 1:num_components),12);
        % Create a new table with the principal components and other variables
        pca_table = condition_table;
        for i = 1:num_components
            pca_table.(['PC', num2str(i)]) = selected_scores(:, i);
        end

        % Define the formula for the linear regression model using the principal components
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

        % Combine fixed effects into the final formula
        lm_formula = ['slope ~ 1 + ', fixed_effects];

        % Fit the linear regression model
        lm_pca = fitlm(pca_table, lm_formula);

        % Display the results
        disp(lm_pca);

        % Display the PCA loadings in a table
        disp('PCA Loadings (Coefficients):');
        loading_table = array2table(coeff(:, 1:num_components), 'VariableNames', ...
            arrayfun(@(x) sprintf('PC%d', x), 1:num_components, 'UniformOutput', false), ...
            'RowNames', predictor_vars);
        disp(loading_table);

        disp('Interpretation of Fixed Effects:');
        fixed_effects_estimates = table2array(lm_pca.Coefficients(:, 'Estimate'));
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