function [fig,mu,std_gaussian] = createfit_normCDF_weighted(coh_list, pc, dotInfo, save_name)
%fit psychometric function to visual discrimination data collected via staircase method, with each
%data point weighted in the psychometric function fit by the # of trials it represents
% 
[xData, yData] = prepareCurveData(coh_list, pc);

%get # of trials per coh for weighting fit by trial # and scaling dot size 
sizes_L = flip(dotInfo.cohFreq_left(2,:)');%Slpit to left and Right 
sizes_R = dotInfo.cohFreq_right(2,:)';
all_sizes = nonzeros(vertcat(sizes_L, sizes_R));

if length(xData) ~= length(all_sizes)
    all_sizes = all_sizes(1:length(xData));

end

mu = mean(yData);
sigma =std(yData);
parms = [mu, sigma];

% mdl to account for weights of PCs 
normalcdf_fun = @(b, x) 0.5 * (1 + erf((x - b(1)) ./ (b(2) * sqrt(2))));
mdl = fitnlm(xData, yData, normalcdf_fun, parms, 'Weights', all_sizes);
fit_x = -1:.01:1;
fit_y = cdf('Normal', fit_x, mdl.Coefficients{1,1}, mdl.Coefficients{2,1});


%get slope
mu= mdl.Coefficients{1,1};
%get std of cumulative gaussian (reflects the inherent variability of the psychophysical data)
std_gaussian= mdl.Coefficients{2,1};

% Plot fit with data.
fig = figure( 'Name', 'Psychometric Function' );
scatter(xData, yData, all_sizes)
hold on 
plot(fit_x, fit_y);
legend('% Rightward Resp. vs. Coherence', 'NormCDF', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
title(sprintf('Visual Psych. Func. L&R\n%s',save_name),'Interpreter', 'none');
xlabel( 'Coherence ((+)Rightward, (-)Leftward)', 'Interpreter', 'none' );
ylabel( '% Rightward Response', 'Interpreter', 'none' );
xlim([-1 1])
ylim([0 1])
grid on
end
