function [fig] = createFit_NormCDF_1_direction_modalities(AUD_coh_list, AUD_pc, VIS_coh_list, VIS_pc, direction)
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
VIS_p = cdf('Normal', x, AUD_fit_par(1), AUD_fit_par(2));


% Plot fit with data.
fig = figure( 'Name', sprintf('Psychometric Function %s',direction) );
scatter(AUD_xData, AUD_yData, VIS_xData, VIS_yData)
hold on 
plot(x, AUD_p, x, VIS_p);
legend('AUD', 'AUD - NormCDF','VIS', 'VIS - NormCDF', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'Coherence %', 'Interpreter', 'none' );
ylabel( '% Rightward Response', 'Interpreter', 'none' );
xlim([0 1])
ylim([0 1])
grid on


