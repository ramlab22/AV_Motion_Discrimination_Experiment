function pls_slope_model(condition_table)
    % PLS_SLOPE_MODEL Perform Partial Least Squares Regression on slope data.
    %
    % This function takes a table containing velocity, duration, displacement,
    % slope, and subjectID columns. It normalizes the data, performs PLS regression
    % to handle multicollinearity, and evaluates the model by calculating R-squared
    % and plotting observed vs. fitted slope values.
    %
    % Usage:
    %   pls_slope_model(condition_table)
    %
    % Input:
    %   condition_table - A table with columns: velocity, duration, displacement,
    %                     slope, and subjectID.
    %
    % Example:
    %   % Assuming condition_table is already in your workspace
    %   pls_slope_model(condition_table);
    %
    % Output:
    %   Displays the PLS regression coefficients and R-squared value.
    %   Plots observed vs. fitted slope values.

    % Extract relevant data from the table
    velocity = condition_table.velocity;
    duration = condition_table.duration;
    displacement = condition_table.displacement;
    slope = condition_table.slope;
    subjectID = condition_table.subjectID;

    % Normalize the data
    X = [velocity, duration, displacement];
    [X_norm, mu, sigma] = zscore(X);
    y_norm = (slope - mean(slope)) / std(slope);

    % Run PLS regression
    numComponents = 2; % You can adjust this number as needed
    [XL, YL, XS, YS, beta, PCTVAR, MSE, stats] = plsregress(X_norm, y_norm, numComponents);

    % Label the coefficients
    coeff_labels = {'Intercept', 'Velocity', 'Duration', 'Displacement'};
    coefficients = table(beta, 'RowNames', coeff_labels);

    % Display the results
    disp('PLS Regression Coefficients:');
    disp(coefficients);

    % Evaluate the model
    yfit = [ones(size(X_norm,1),1) X_norm] * beta;
    yfit = yfit * std(slope) + mean(slope); % Convert back to original scale

    % Calculate R-squared
    SST = sum((slope - mean(slope)).^2);
    SSE = sum((slope - yfit).^2);
    R_squared = 1 - SSE/SST;

    disp('R-squared:');
    disp(R_squared);

    % Plot the results
    figure;
    plot(slope, yfit, 'o');
    hold on;
    plot([min(slope) max(slope)], [min(slope) max(slope)], '-r');
    xlabel('Observed Slope');
    ylabel('Fitted Slope');
    title('PLS Regression: Observed vs Fitted Slope');
    hold off;
    pls_permutation_test(condition_table, 1000);




end
