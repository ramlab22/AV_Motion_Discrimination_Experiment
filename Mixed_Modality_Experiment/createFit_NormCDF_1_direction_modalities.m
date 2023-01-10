function [fig] = createFit_NormCDF_1_direction_modalities(AUD_coh_list, AUD_pc, VIS_coh_list, VIS_pc, direction, audInfo, dotInfo, save_name)
%CREATEFIT(COH_LIST,PC_AUD)
%  Create a fit.
% direction = string 'RIGHT' or "LEFT' 


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

%Size of scatter point absed on frequency
if strcmp(direction, "RIGHT ONLY")
    sizes_AUD = nonzeros(audInfo.cohFreq_right(2,:)');
    sizes_VIS = nonzeros(dotInfo.cohFreq_right(2,:)');
elseif strcmp(direction, "LEFT ONLY")
    sizes_AUD = nonzeros(audInfo.cohFreq_left(2,:)');
    sizes_VIS = nonzeros(dotInfo.cohFreq_left(2,:)');
end

if length(AUD_xData) ~= length(sizes_AUD)
    sizes_AUD = sizes_AUD(1:length(AUD_xData));
end

if length(VIS_xData) ~= length(sizes_VIS)
    sizes_VIS = sizes_VIS(1:length(AUD_xData));
end

% Plot fit with data.
fig = figure( 'Name', sprintf('Psychometric Function %s',direction) );
scatter(AUD_xData, AUD_yData, sizes_AUD)
hold on 
scatter(VIS_xData, VIS_yData, sizes_VIS)
plot(x, AUD_p, x, VIS_p);
legend('AUD','VIS', 'AUD - NormCDF','VIS - NormCDF', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
title(sprintf('AUD & VIS Psych. Func. %s\n%s', direction, save_name), 'Interpreter', 'none');
xlabel( 'Coherence %', 'Interpreter', 'none' );
ylabel( '% Rightward Response', 'Interpreter', 'none' );
xlim([0 1])
ylim([0 1])
grid on


