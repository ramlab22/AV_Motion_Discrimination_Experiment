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

fun_1 = @(b, x)cdf('Normal', x, b(1), b(2));
AUD_fun = @(b)sum((fun_1(b,AUD_xData) - AUD_yData).^2); 
VIS_fun = @(b)sum((fun_1(b,VIS_xData) - VIS_yData).^2); 
opts = optimset('MaxFunEvals',50000, 'MaxIter',10000); 

AUD_fit_par = fminsearch(AUD_fun, AUD_parms, opts);
VIS_fit_par = fminsearch(VIS_fun, VIS_parms, opts);


x = -1:.01:1;
AUD_p = cdf('Normal', x, AUD_fit_par(1), AUD_fit_par(2));
VIS_p = cdf('Normal', x, VIS_fit_par(1), VIS_fit_par(2));

[AUD_p_values, bootstat_AUD] = p_value_calc(AUD_yData,AUD_parms);
[VIS_p_values, bootstat_VIS] = p_value_calc(VIS_yData,VIS_parms);

%Plot different sizes based on amount of frequency of each coh
sizes_L_AUD = flip(audInfo.cohFreq_left(2,:)');%Slpit to left and Right 
sizes_R_AUD = audInfo.cohFreq_right(2,:)';
all_sizes_AUD = nonzeros(vertcat(sizes_L_AUD, sizes_R_AUD));

sizes_L_VIS = flip(dotInfo.cohFreq_left(2,:)');%Slpit to left and Right 
sizes_R_VIS = dotInfo.cohFreq_right(2,:)';
all_sizes_VIS = nonzeros(vertcat(sizes_L_VIS, sizes_R_VIS));

if length(AUD_xData) ~= length(all_sizes_AUD)
    all_sizes_AUD = all_sizes_AUD(1:length(AUD_xData));
end

if length(VIS_xData) ~= length(all_sizes_VIS)
    all_sizes_VIS = all_sizes_VIS(1:length(VIS_xData));
end
AUD_threshold_location=find(AUD_p >= chosen_threshold, 1);
AUD_threshold=x(1,AUD_threshold_location);
VIS_threshold_location=find(VIS_p >= chosen_threshold, 1);
VIS_threshold=x(1,VIS_threshold_location);
% Plot fit with data.
fig = figure( 'Name', 'Psychometric Function' );
scatter(AUD_xData, AUD_yData, all_sizes_AUD)
hold on
scatter(VIS_xData, VIS_yData, all_sizes_VIS)
plot(x, AUD_p, x, VIS_p);
legend('AUD','VIS', 'AUD - NormCDF', 'VIS - NormCDF', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
title(sprintf('AUD & VIS Psych. Func. L&R\n%s', save_name), 'Interpreter', 'none');
xlabel( 'Coherence ((+)Rightward, (-)Leftward)', 'Interpreter', 'none' );
ylabel( '% Rightward Response', 'Interpreter', 'none' );
xlim([-1 1])
ylim([0 1])
grid on

end
