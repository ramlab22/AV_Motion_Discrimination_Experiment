function [BF_AUD_VIS, BF_AUD_AV, BF_VIS_AV] = comparePsychometricFunctions_A_V_AV(x,AUD_mdl, VIS_mdl, AV_mdl,AUD_fit_par,VIS_fit_par,AV_fit_par)

%--------------------------------------------------------------------------
% DESCRIPTION: Bayesian Hypothesis Testing for Comparing Psychometric Functions
%
% This function performs Bayesian hypothesis testing to compare the
% significance of three psychometric functions (AUD, VIS, and AV) obtained
% from human multisensory psychophysics research using 2-AFC discrimination
% tasks. The function calculates Bayes factors for pairwise comparisons of
% the psychometric functions and returns the results.
%
% The likelihood functions for AUD,VIS, and AV are defined based on their
% respective fitted parameters from the psychometric modeling. Prior
% distributions are also specified for the parameters. The script then
% performs Bayesian hypothesis testing by calculating the evidence
% (marginal likelihood) for each model using numerical integration
% (trapezoidal rule) over the parameter space. The Bayes factor is computed
% as the ratio of evidence between pairwise combos of AUD, VIS, and AV.
% Finally, the significance of the difference is determined by comparing
% the Bayes factor to a predefined threshold (BF_threshold).
%
% AUTHOR: Adriana Schoenhaut-5/21/23
%
% INPUTS:
%   - AUD_mdl: Object containing the AUD psychometric model (e.g., from fitnlm).
%   - VIS_mdl: Object containing the VIS psychometric model (e.g., from fitnlm).
%   - AV_mdl: Object containing the AV psychometric model (e.g., from fitnlm).
%   - AUD_fit_par: Array containing the AUD fit parameters.
%   - VIS_fit_par: Array containing the VIS fit parameters.
%   - AV_fit_par: Array containing the AV fit parameters.
%
% OUTPUTS:
%   - BF_AUD_VIS: Bayes factor indicating the evidence for the difference between AUD and VIS.
%   - BF_AUD_AV: Bayes factor indicating the evidence for the difference between AUD and AV.
%   - BF_VIS_AV: Bayes factor indicating the evidence for the difference between VIS and AV.
%
% USAGE: 
%   1. Ensure the required variables (AUD_mdl, VIS_mdl, AV_mdl, etc.) are defined
%      in the workspace.
%   2. Adjust the parameters and options in the script as needed.
%   3. Run the script in MATLAB.
%
% NOTES:
%   - This script assumes that the necessary functions and data are
%   available in the MATLAB workspace.
%   - Modify the output statements based on the specific combinations of
%     significant differences you want to highlight.
%   -this script assumes a simple uniform prior for the
%    standard deviation parameters. You can modify the prior distributions
%    and adjust other aspects of the code based on your specific
%    requirements and prior knowledge.
%
%--------------------------------------------------------------------------

% Define likelihood functions for AUD, VIS, and AV
likelihood_AUD = @(x) normpdf(x, AUD_mdl.Coefficients{1, 1}, AUD_mdl.Coefficients{2, 1});
likelihood_VIS = @(x) normpdf(x, VIS_mdl.Coefficients{1, 1}, VIS_mdl.Coefficients{2, 1});
likelihood_AV = @(x) normpdf(x, AV_mdl.Coefficients{1, 1}, AV_mdl.Coefficients{2, 1});

% Define prior distributions for the parameters
prior_mu_AUD = @(mu) normpdf(mu, AUD_fit_par(1), sqrt(AUD_fit_par(2)));
prior_sigma_AUD = @(sigma) 1 / sigma;  % Assuming uniform prior for simplicity

prior_mu_VIS = @(mu) normpdf(mu, VIS_fit_par(1), sqrt(VIS_fit_par(2)));
prior_sigma_VIS = @(sigma) 1 / sigma;  % Assuming uniform prior for simplicity

prior_mu_AV = @(mu) normpdf(mu, AV_fit_par(1), sqrt(AV_fit_par(2)));
prior_sigma_AV = @(sigma) 1 / sigma;  % Assuming uniform prior for simplicity

% % Define range of parameter values for sampling
% n_samples = 10000;  % Adjust the number of samples as needed
% mu_values = linspace(min([AUD_fit_par(1), VIS_fit_par(1), AV_fit_par(1)]), max([AUD_fit_par(1), VIS_fit_par(1), AV_fit_par(1)]), n_samples);
% sigma_values = linspace(min([AUD_fit_par(2), VIS_fit_par(2), AV_fit_par(2)]), max([AUD_fit_par(2), VIS_fit_par(2), AV_fit_par(2)]), n_samples);
% 
% % Perform Bayesian hypothesis testing
% evidence_AUD = zeros(n_samples, n_samples);
% evidence_VIS = zeros(n_samples, n_samples);
% evidence_AV = zeros(n_samples, n_samples);
% 
% % Create a grid to ensure that posterior_AUD, posterior_VIS, and
% % posterior_AV are evaluated at every combination of sigma_values and
% % mu_values.
% [sigma_grid, mu_grid] = meshgrid(sigma_values, mu_values);  
% 
% for i = 1:n_samples
%     for j = 1:n_samples
%         % Calculate posterior probabilities using Bayes' theorem
% %         posterior_AUD = likelihood_AUD(x) * prior_mu_AUD(mu_values(i)) * prior_sigma_AUD(sigma_values(j));
% %         posterior_VIS = likelihood_VIS(x) * prior_mu_VIS(mu_values(i)) * prior_sigma_VIS(sigma_values(j));
% %         posterior_AV = likelihood_AV(x) * prior_mu_AV(mu_values(i)) * prior_sigma_AV(sigma_values(j));
%         posterior_AUD = likelihood_AUD(x) .* prior_mu_AUD(mu_grid(i, j)) .* prior_sigma_AUD(sigma_grid(i, j));
%         posterior_VIS = likelihood_VIS(x) .* prior_mu_VIS(mu_grid(i, j)) .* prior_sigma_VIS(sigma_grid(i, j));
%         posterior_AV = likelihood_AV(x) .* prior_mu_AV(mu_grid(i, j)) .* prior_sigma_AV(sigma_grid(i, j));
%         
%         % Calculate the evidence by integrating over the parameter space
%                 %calculates the definite integral of a function using the
%                 %trapezoidal rule. The trapezoidal rule approximates the
%                 %area under a curve by dividing it into a series of
%                 %trapezoids and summing their areas. The rule assumes that
%                 %the curve is piecewise linear between adjacent data
%                 %points.
% %         evidence_AUD(i, j) = trapz(sigma_values, trapz(mu_values, posterior_AUD));
% %         evidence_VIS(i, j) = trapz(sigma_values, trapz(mu_values, posterior_VIS));
% %         evidence_AV(i, j) = trapz(sigma_values, trapz(mu_values, posterior_AV));
%         
%     end
% end
% Define range of parameter values for sampling
%n_samples = 10000;  % Adjust the number of samples as needed
n_samples = 100;  % Adjust the number of samples as needed

mu_values = linspace(min([AUD_fit_par(1), VIS_fit_par(1), AV_fit_par(1)]), max([AUD_fit_par(1), VIS_fit_par(1), AV_fit_par(1)]), n_samples);
sigma_values = linspace(min([AUD_fit_par(2), VIS_fit_par(2), AV_fit_par(2)]), max([AUD_fit_par(2), VIS_fit_par(2), AV_fit_par(2)]), n_samples);

% Perform Bayesian hypothesis testing
evidence_AUD = zeros(n_samples, n_samples);
evidence_VIS = zeros(n_samples, n_samples);
evidence_AV = zeros(n_samples, n_samples);

% Create a grid to ensure that posterior_AUD, posterior_VIS, and posterior_AV
% are evaluated at every combination of sigma_values and mu_values.
[sigma_grid, mu_grid] = meshgrid(sigma_values, mu_values);

for i = 1:n_samples
    for j = 1:n_samples
        % Calculate posterior probabilities using Bayes' theorem
        posterior_AUD = likelihood_AUD(x) .* prior_mu_AUD(mu_grid(i, j)) .* prior_sigma_AUD(sigma_grid(i, j));
        posterior_VIS = likelihood_VIS(x) .* prior_mu_VIS(mu_grid(i, j)) .* prior_sigma_VIS(sigma_grid(i, j));
        posterior_AV = likelihood_AV(x) .* prior_mu_AV(mu_grid(i, j)) .* prior_sigma_AV(sigma_grid(i, j));
        
    end
end
posterior_AUD_reshaped = repmat(posterior_AUD, n_samples, 1);
posterior_VIS_reshaped = repmat(posterior_VIS, n_samples, 1);
posterior_AV_reshaped = repmat(posterior_AV, n_samples, 1);
for i = 1:n_samples
    for j = 1:n_samples
        % Calculate the evidence by integrating over the parameter space
        evidence_AUD(i, j) = trapz(mu_values, trapz(sigma_values, posterior_AUD_reshaped, 2));
        evidence_VIS(i, j) = trapz(mu_values, trapz(sigma_values, posterior_VIS_reshaped, 2));
        evidence_AV(i, j) = trapz(mu_values, trapz(sigma_values, posterior_AV_reshaped, 2));
    end
end
% Calculate the Bayes factors
BF_AUD_VIS = evidence_AUD ./ evidence_VIS;
BF_AUD_AV = evidence_AUD ./ evidence_AV;
BF_VIS_AV = evidence_VIS ./ evidence_AV;

% Set the significance threshold for the Bayes factor
BF_threshold = 3;  % Adjust the threshold as needed

% Determine the significance of the differences
if max(BF_AUD_VIS(:)) > BF_threshold && max(BF_AUD_AV(:)) > BF_threshold && max(BF_VIS_AV(:)) > BF_threshold
    disp('The psychometric functions AUD, VIS, and AV are all significantly different from each other.');
elseif max(BF_AUD_VIS(:)) > BF_threshold && max(BF_AUD_AV(:)) > BF_threshold
    disp('The psychometric functions AUD and VIS, as well as AUD and AV, are significantly different from each other, but VIS and AV are not significantly different.');
elseif max(BF_AUD_VIS(:)) > BF_threshold && max(BF_VIS_AV(:)) > BF_threshold
    disp('The psychometric functions AUD and VIS, as well as VIS and AV, are significantly different from each other, but AUD and AV are not significantly different.');
elseif max(BF_AUD_AV(:)) > BF_threshold && max(BF_VIS_AV(:)) > BF_threshold
    disp('The psychometric functions AUD and AV, as well as VIS and AV, are significantly different from each other, but AUD and VIS are not significantly different.');
else
    disp('The psychometric functions AUD, VIS, and AV are not all significantly different from each other.');
end

% Plotting the evidence surfaces
figure;
subplot(1, 3, 1);
surf(mu_values, sigma_values, evidence_AUD);
xlabel('mu (mean)');
ylabel('sigma (std of cum. gaussian)');
zlabel('Evidence');
title('AUD');

subplot(1, 3, 2);
surf(mu_values, sigma_values, evidence_VIS);
xlabel('mu (mean)');
ylabel('sigma (std of cum. gaussian)');
zlabel('Evidence');
title('VIS');

subplot(1, 3, 3);
surf(mu_values, sigma_values, evidence_AV);
xlabel('mu (mean)');
ylabel('sigma (std of cum. gaussian)');
zlabel('Evidence');
title('AV');

% Plotting the Bayes factors
figure;
subplot(1, 3, 1);
surf(mu_values, sigma_values, BF_AUD_VIS);
xlabel('mu (mean)');
ylabel('sigma (std of cum. gaussian)');
zlabel('Bayes Factor');
title('BF: AUD vs. VIS');

subplot(1, 3, 2);
surf(mu_values, sigma_values, BF_AUD_AV);
xlabel('mu (mean)');
ylabel('sigma (std of cum. gaussian)');
zlabel('Bayes Factor');
title('BF: AUD vs. AV');

subplot(1, 3, 3);
surf(mu_values, sigma_values, BF_VIS_AV);
xlabel('mu (mean)');
ylabel('sigma (std of cum. gaussian)');
zlabel('Bayes Factor');
title('BF: VIS vs. AV');

end %define function