function  [fig] = create_dotnum_fig(dotInfo,prob_correct,save_name)
all_sizes = nonzeros(dotInfo.dotnumFreq(2,:));
%all_sizes = vertcat(sizes_L, sizes_R);
xData = dotInfo.dotnumSet ;
if length(xData) ~= length(all_sizes)
    all_sizes = all_sizes(1:length(prob_correct(:,1)'));
end
yData = prob_correct(:,2)';
% 
% mu = mean(yData);
% sigma =std(yData);
% parms = [mu, sigma];
% 
% fun_1 = @(b, x)cdf('Normal', x, b(1), b(2));
% fun = @(b)sum((fun_1(b,xData) - yData).^2); 
% opts = optimset('MaxFunEvals',50000, 'MaxIter',10000); 
% fit_par = fminsearch(fun, parms, opts);
% 
% %New mdl to account for weights of PCs 
% normalcdf_fun = @(b, x) 0.5 * (1 + erf((x - b(1)) ./ (b(2) * sqrt(2))));
% mdl = fitnlm(xData, yData, normalcdf_fun, parms, 'Weights', all_sizes);
% x = min(xData):10:max(xData);
% p = cdf('Normal', x, mdl.Coefficients{1,1}, mdl.Coefficients{2,1});
% %get std of cumulative gaussian (reflects the inherent variability of the psychophysical data)
% std_gaussian= mdl.Coefficients{2,1};
% Plot fit with data.
fig = figure( 'Name', 'Accuracy vs. DotNum' );
scatter(xData, yData, all_sizes,'blue', 'filled')
hold on 
%plot(x, p);
legend('Accuracy',  'Location', 'NorthEast', 'Interpreter', 'none' );
%legend('Accuracy', 'NormCDF', 'Location', 'NorthEast', 'Interpreter', 'none' );
ylim([0 100])
% Label axes
title(sprintf('Vis Accuracy Across Dot Quantities for %d Coherence \n%s',dotInfo.coherences,save_name),'Interpreter', 'none');
xlabel( 'Number of Dots', 'Interpreter', 'none' );
ylabel( 'Percent Correct', 'Interpreter', 'none' );

grid on

