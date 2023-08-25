function [fig, AUD_p_values, VIS_p_values,AUD_threshold,VIS_threshold] = createFit_NormCDF_modalities(AUD_coh_list, AUD_pc, VIS_coh_list, VIS_pc, audInfo, dotInfo, chosen_threshold,save_name)
%CREATEFIT(COH_LIST,PC_AUD)
%  Create a fit.



%% Fit: 'untitled fit 1'.
[AUD_xData, AUD_yData] = prepareCurveData( AUD_coh_list, AUD_pc );
[VIS_xData, VIS_yData] = prepareCurveData( VIS_coh_list, VIS_pc );

%%AUD
AUD_mu = mean(AUD_yData);
AUD_sigma =std(AUD_yData);
AUD_parms = [AUD_mu, AUD_sigma];
%%VIS
VIS_mu = mean(VIS_yData);
VIS_sigma =std(VIS_yData);
VIS_parms = [VIS_mu, VIS_sigma];

   
    
    % Plot different sizes based on the amount of frequency of each coh
    all_sizes_AUD = nonzeros([flip(audInfo.cohFreq_left(2,:)'), audInfo.cohFreq_right(2,:)']);
    all_sizes_AUD = all_sizes_AUD(1:length(AUD_xData));
    
    all_sizes_VIS = nonzeros([flip(dotInfo.cohFreq_left(2,:)'), dotInfo.cohFreq_right(2,:)']);
    all_sizes_VIS = all_sizes_VIS(1:length(VIS_xData));

fun_1 = @(b, x)cdf('Normal', x, b(1), b(2));
 
    AUD_fun = @(b) sum((fun_1(b, AUD_xData) - AUD_yData).^2);
    VIS_fun = @(b) sum((fun_1(b, VIS_xData) - VIS_yData).^2);

    opts = optimset('MaxFunEvals', 50000, 'MaxIter', 10000);

AUD_fit_par = fminsearch(AUD_fun, AUD_parms, opts);
VIS_fit_par = fminsearch(VIS_fun, VIS_parms, opts);

    normalcdf_fun = @(b, x) 0.5 * (1 + erf((x - b(1)) ./ (b(2) * sqrt(2))));

    AUD_mdl = fitnlm(AUD_xData, AUD_yData, normalcdf_fun, AUD_parms, 'Weights', all_sizes_AUD);
    VIS_mdl = fitnlm(VIS_xData, VIS_yData, normalcdf_fun, VIS_parms, 'Weights', all_sizes_VIS);

    curve_xvals = min([AUD_xData(:); VIS_xData(:)]):0.01:max([AUD_xData(:); VIS_xData(:)]);

    AUD_curve_yvals = cdf('Normal', curve_xvals, AUD_mdl.Coefficients{1, 1}, AUD_mdl.Coefficients{2, 1});
    VIS_curve_yvals = cdf('Normal', curve_xvals, VIS_mdl.Coefficients{1, 1}, VIS_mdl.Coefficients{2, 1});

    AUD_mu = AUD_mdl.Coefficients{1, 1}
    VIS_mu = VIS_mdl.Coefficients{1, 1}

    AUD_std_cumulative_gaussian = AUD_mdl.Coefficients{2, 1}
    VIS_std_cumulative_gaussian = VIS_mdl.Coefficients{2, 1}
aud_dy_dx = diff(AUD_curve_yvals) ./ diff(curve_xvals); % calculates the slope of the CDF curve by taking the difference between consecutive y-values and dividing by the difference between their corresponding x-values
AUD_slope = mean(aud_dy_dx)
vis_dy_dx = diff(VIS_curve_yvals) ./ diff(curve_xvals); % calculates the slope of the CDF curve by taking the difference between consecutive y-values and dividing by the difference between their corresponding x-values
VIS_slope = mean(vis_dy_dx)

AUD_slope_at_50_percent = 1 / (AUD_std_cumulative_gaussian * sqrt(2 * pi))
VIS_slope_at_50_percent = 1 / (VIS_std_cumulative_gaussian * sqrt(2 * pi))

n_trials_aud=sum(all_sizes_AUD)
n_trials_vis=sum(all_sizes_VIS)

% Plot fit with data.
ax = gca; 
ax.FontSize = 22;
fig = figure( 'Name', 'Psychometric Function' );
scatter(AUD_xData, AUD_yData, all_sizes_AUD, 'red', 'filled')
hold on
scatter(VIS_xData, VIS_yData, all_sizes_VIS, 'blue', 'filled')
plot(curve_xvals, AUD_curve_yvals, "red", curve_xvals, VIS_curve_yvals, "blue",'LineWidth',2.5);
legend('AUD','VIS', 'AUD - NormCDF', 'VIS - NormCDF', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
title(sprintf('AUD & VIS Psych. Func. L&R\n%s', save_name), 'Interpreter', 'none');
xlabel( 'Coherence ((+)Rightward, (-)Leftward)', 'Interpreter', 'none' );
ylabel( '% Rightward Response', 'Interpreter', 'none' );
xlim([-1 1])
ylim([0 1])
grid on

% get residuals of all models
AUD_fittedValues = feval(AUD_mdl, AUD_xData);
AUD_residuals = AUD_yData - AUD_fittedValues;
VIS_fittedValues = feval(VIS_mdl, VIS_xData);
VIS_residuals = VIS_yData - VIS_fittedValues;

%get measured AUD and VIS parameters
Results_MLE.AUD_R2 = 1-sum(AUD_residuals.^2)/sum((AUD_yData-mean(AUD_yData)).^2); % R2 = 1 – SSresid / SStotal
Results_MLE.AUD_Mu = AUD_mdl.Coefficients{1, 1};
Results_MLE.AUD_SD = AUD_mdl.Coefficients{2, 1};
Results_MLE.AUD_Variance = Results_MLE.AUD_SD^2;

Results_MLE.VIS_R2 = 1-sum(VIS_residuals.^2)/sum((VIS_yData-mean(VIS_yData)).^2); % R2 = 1 – SSresid / SStotal
Results_MLE.VIS_Mu = VIS_mdl.Coefficients{1, 1};
Results_MLE.VIS_SD = VIS_mdl.Coefficients{2, 1};
Results_MLE.VIS_Variance = Results_MLE.VIS_SD^2;

%Get MLE results
Results_MLE.AUD_Westimate= (1/Results_MLE.AUD_Variance)/((1/Results_MLE.AUD_Variance)+(1/Results_MLE.VIS_Variance));
Results_MLE.VIS_Westimate= (1/Results_MLE.VIS_Variance)/((1/Results_MLE.VIS_Variance)+(1/Results_MLE.AUD_Variance));
Results_MLE.AV_EstimatedVariance=(Results_MLE.AUD_Variance*Results_MLE.VIS_Variance)/(Results_MLE.AUD_Variance+Results_MLE.VIS_Variance);

Results_MLE.AV_EstimatedSD=sqrt(Results_MLE.AV_EstimatedVariance);

Results_MLE

end
