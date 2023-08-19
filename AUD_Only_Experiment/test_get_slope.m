% Generate some example data
x = -10:0.5:10;
y = [0.1, 0.15, 0.2, 0.25, 0.3, 0.4, 0.6, 0.8, 0.9, 0.95, 0.975, 0.99, 0.995, 0.9975, 0.999];

% Define the NormCDF function
normcdf_fit = @(p,x) p(1) + (1-p(1)-p(2)) .* normcdf(x,p(3),p(4));

% Fit the NormCDF function to the data using maximum likelihood estimation
p0 = [0.1, 0.1, 0, 1]; % initial parameter values
[p,~,~] = mle(x, 'pdf',normcdf_fit, 'start',p0, 'y',y, 'lower',[0,0,-inf,0], 'upper',[1,1,inf,inf]);

% Plot the fitted curve and the data
figure;
plot(x, y, 'o', 'MarkerSize', 8);
hold on;
plot(x, normcdf_fit(p,x), '-', 'LineWidth', 2);
xlabel('Stimulus intensity');
ylabel('Proportion correct');

% Calculate the slope of the curve at the mean of the data
mean_x = mean(x);
mean_y = normcdf_fit(p, mean_x);
slope = (1-p(1)-p(2)) * (1 / (p(4) * sqrt(2*pi))) * exp(-(mean_x-p(3))^2 / (2*p(4)^2)) / mean_y * (1-mean_y);
disp(['Slope at mean: ', num2str(slope)]);
