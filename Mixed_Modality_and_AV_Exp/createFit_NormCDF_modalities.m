function [fig, AUD_p_values, VIS_p_values,...
               AV_aud_p_values, AV_vis_p_values,...
               AUD_slope,VIS_slope, AV_slope,AUD_mu, VIS_mu, AV_mu, AUD_std, VIS_std, AV_std] = createFit_NormCDF_modalities(AUD_coh_list, AUD_pc,...
                                                                              VIS_coh_list, VIS_pc,...
                                                                              AV_coh_list_aud, AV_aud_pc,...
                                                                              AV_coh_list_vis, AV_vis_pc,...
                                                                              audInfo, dotInfo, AVInfo,save_name)
%CREATEFIT(COH_LIST,PC_AUD)
%  Create a fit.



%% Fit: 'untitled fit 1'.
[AUD_xData, AUD_yData] = prepareCurveData( AUD_coh_list, AUD_pc );
[VIS_xData, VIS_yData] = prepareCurveData( VIS_coh_list, VIS_pc );
[AV_aud_xData, AV_aud_yData] = prepareCurveData( AV_coh_list_aud, AV_aud_pc );
[AV_vis_xData, AV_vis_yData] = prepareCurveData( AV_coh_list_vis, AV_vis_pc );

%%AUD
AUD_mu = mean(AUD_yData);
AUD_sigma =std(AUD_yData);
AUD_parms = [AUD_mu, AUD_sigma];
%%VIS
VIS_mu = mean(VIS_yData);
VIS_sigma =std(VIS_yData);
VIS_parms = [VIS_mu, VIS_sigma];
%AV_aud
AV_aud_mu = mean(AV_aud_yData);
AV_aud_sigma =std(AV_aud_yData);
AV_aud_parms = [AV_aud_mu, AV_aud_sigma];
%AV_vis
AV_vis_mu = mean(AV_vis_yData);
AV_vis_sigma =std(AV_vis_yData);
AV_vis_parms = [AV_vis_mu, AV_vis_sigma];
%Plot different sizes based on amount of frequency of each coh
sizes_L_AUD = flip(audInfo.cohFreq_left(2,:)');%Slpit to left and Right 
sizes_R_AUD = audInfo.cohFreq_right(2,:)';
all_sizes_AUD = nonzeros(vertcat(sizes_L_AUD, sizes_R_AUD));

sizes_L_VIS = flip(dotInfo.cohFreq_left(2,:)');%Slpit to left and Right 
sizes_R_VIS = dotInfo.cohFreq_right(2,:)';
all_sizes_VIS = nonzeros(vertcat(sizes_L_VIS, sizes_R_VIS));

sizes_L_AV_aud = flip(AVInfo.cohFreq_left_aud(2,:)');%Slpit to left and Right 
sizes_R_AV_aud = AVInfo.cohFreq_right_aud(2,:)';
all_sizes_AV_aud = nonzeros(vertcat(sizes_L_AV_aud, sizes_R_AV_aud));

sizes_L_AV_vis = flip(AVInfo.cohFreq_left_vis(2,:)');%Slpit to left and Right 
sizes_R_AV_vis = AVInfo.cohFreq_right_vis(2,:)';
all_sizes_AV_vis = nonzeros(vertcat(sizes_L_AV_vis, sizes_R_AV_vis));

if length(AUD_xData) ~= length(all_sizes_AUD)
    all_sizes_AUD = all_sizes_AUD(1:length(AUD_xData));
end

if length(VIS_xData) ~= length(all_sizes_VIS)
    all_sizes_VIS = all_sizes_VIS(1:length(VIS_xData));
end

if length(AV_aud_xData) ~= length(all_sizes_AV_aud)
    all_sizes_AV_aud = all_sizes_AV_aud(1:length(AV_aud_xData));
end

if length(AV_vis_xData) ~= length(all_sizes_AV_vis)
    all_sizes_AV_vis = all_sizes_AV_vis(1:length(AV_vis_xData));
end

fun_1 = @(b, x)cdf('Normal', x, b(1), b(2));
AUD_fun = @(b)sum((fun_1(b,AUD_xData) - AUD_yData).^2); 
VIS_fun = @(b)sum((fun_1(b,VIS_xData) - VIS_yData).^2); 
AV_aud_fun = @(b)sum((fun_1(b,AV_aud_xData) - AV_aud_yData).^2);
AV_vis_fun = @(b)sum((fun_1(b,AV_vis_xData) - AV_vis_yData).^2);
opts = optimset('MaxFunEvals',50000, 'MaxIter',10000); 

AUD_fit_par = fminsearch(AUD_fun, AUD_parms, opts);
VIS_fit_par = fminsearch(VIS_fun, VIS_parms, opts);
AV_aud_fit_par = fminsearch(AV_aud_fun, AV_aud_parms, opts);
AV_vis_fit_par = fminsearch(AV_vis_fun, AV_vis_parms, opts);
%New mdl to account for weights of PCs 
normalcdf_fun = @(b, x) 0.5 * (1 + erf((x - b(1)) ./ (b(2) * sqrt(2))));
AUD_mdl = fitnlm(AUD_xData, AUD_yData, normalcdf_fun, AUD_fit_par, 'Weights', all_sizes_AUD);
VIS_mdl = fitnlm(VIS_xData, VIS_yData, normalcdf_fun, VIS_fit_par, 'Weights', all_sizes_VIS);
AV_aud_mdl = fitnlm(AV_aud_xData, AV_aud_yData, normalcdf_fun,AV_aud_fit_par, 'Weights', all_sizes_AV_aud);
AV_vis_mdl = fitnlm(AV_vis_xData, AV_vis_yData, normalcdf_fun,AV_vis_fit_par, 'Weights', all_sizes_AV_vis);

curve_xvals = -1:.01:1;
% AUD_p = cdf('Normal', x, AUD_fit_par(1), AUD_fit_par(2));
% VIS_p = cdf('Normal', x, VIS_fit_par(1), VIS_fit_par(2));
% AV_aud_p = cdf('Normal', x, AV_aud_fit_par(1), AV_aud_fit_par(2));
% AV_vis_p = cdf('Normal', x, AV_vis_fit_par(1), AV_vis_fit_par(2));

% AUD_mdl.Coefficients{1,1}=mu, AUD_mdl.Coefficients{1,2}=std of gaussian
% distribution (reflects the inherent variability of the psychophysical data), 
% AUD_mdl.Coefficients{2,1}=standard error of the estimated threshold 
% (reflects the uncertainty/variability of estimated threshold obtained through the model fitting process.)
AUD_curve_yvals = cdf('Normal', curve_xvals, AUD_mdl.Coefficients{1,1}, AUD_mdl.Coefficients{2,1});
VIS_curve_yvals = cdf('Normal', curve_xvals, VIS_mdl.Coefficients{1,1}, VIS_mdl.Coefficients{2,1});
AV_aud_curve_yvals = cdf('Normal', curve_xvals, AV_aud_mdl.Coefficients{1,1}, AV_aud_mdl.Coefficients{2,1});
AV_vis_curve_yvals = cdf('Normal', curve_xvals, AV_vis_mdl.Coefficients{1,1}, AV_vis_mdl.Coefficients{2,1});

[AUD_p_values, bootstat_AUD] = p_value_calc(AUD_yData,AUD_parms);
[VIS_p_values, bootstat_VIS] = p_value_calc(VIS_yData,VIS_parms);
[AV_aud_p_values, bootstat_AV_aud] = p_value_calc(AV_aud_yData,AV_aud_parms);
[AV_vis_p_values, bootstat_AV_vis] = p_value_calc(AV_vis_yData,AV_vis_parms);



% AUD_threshold_location=find(AUD_p >= chosen_threshold, 1);
% AUD_threshold=x(1,AUD_threshold_location);
% VIS_threshold_location=find(VIS_p >= chosen_threshold, 1);
% VIS_threshold=x(1,VIS_threshold_location);

AUD_mu= AUD_mdl.Coefficients{1,1};
VIS_mu= VIS_mdl.Coefficients{1,1};
AV_mu= AV_vis_mdl.Coefficients{1,1};

AUD_std= AUD_mdl.Coefficients{2,1};
VIS_std= VIS_mdl.Coefficients{2,1};
AV_std= AV_vis_mdl.Coefficients{2,1};

AUD_dy_dx = diff(AUD_curve_yvals) ./ diff(curve_xvals); % calculates the slope of the CDF curve by taking the difference between consecutive y-values and dividing by the difference between their corresponding x-values
VIS_dy_dx = diff(VIS_curve_yvals) ./ diff(curve_xvals); % calculates the slope of the CDF curve by taking the difference between consecutive y-values and dividing by the difference between their corresponding x-values
AV_dy_dx = diff(AV_vis_curve_yvals) ./ diff(curve_xvals); % calculates the slope of the CDF curve by taking the difference between consecutive y-values and dividing by the difference between their corresponding x-values

AUD_slope = mean(AUD_dy_dx);
VIS_slope = mean(VIS_dy_dx);
AV_slope = mean(AV_dy_dx);

% Plot fit with data.
fig = figure( 'Name', 'Psychometric Function' );
scatter(AUD_xData, AUD_yData, all_sizes_AUD, 'red', 'filled')
hold on
scatter(VIS_xData, VIS_yData, all_sizes_VIS, 'blue', 'filled')
scatter(AV_aud_xData, AV_aud_yData, all_sizes_AV_aud, 'green', 'filled')
scatter(AV_vis_xData, AV_vis_yData, all_sizes_AV_vis, 'black', 'filled')
max_cohval=max([VIS_xData(:); AUD_xData(:); AV_vis_xData(:)]);
plot(curve_xvals, AUD_curve_yvals, "red",...
        curve_xvals, VIS_curve_yvals, "blue",...
        curve_xvals, AV_aud_curve_yvals, 'green',...
        curve_xvals, AV_vis_curve_yvals, 'black');

legend('AUD','VIS','AV_aud','AV_vis', 'AUD - NormCDF', 'VIS - NormCDF','AV_aud - NormCDF', 'AV_vis - NormCDF', 'Location', 'Best', 'Interpreter', 'none' );
% Label axes
title(sprintf('AUD,VIS,AV Psych. Func. L&R\n%s', save_name), 'Interpreter', 'none');
xlabel( 'Coherence ((+)Rightward, (-)Leftward)', 'Interpreter', 'none' );
ylabel( '% Rightward Response', 'Interpreter', 'none' );
xlim([(-1*max_cohval) max_cohval])
ylim([0 1])
grid on
[Results_MLE] = MLE_Calculations_A_V_AV(AUD_mdl, VIS_mdl, AV_vis_mdl,AUD_yData,VIS_yData, AV_vis_yData,AUD_xData,VIS_xData, AV_aud_xData)
end
