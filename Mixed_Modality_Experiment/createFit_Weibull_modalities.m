function [fitresult, gof, fig] = createFit_Weibull(AUD_coh_list, AUD_pc, VIS_coh_list, VIS_pc)
%CREATEFIT(COH_LIST,PC_AUD)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : coh_list
%      Y Output: pc
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 10-Aug-2022 10:09:38


%% Fit: 'untitled fit 1'.
[AUD_xData, AUD_yData] = prepareCurveData( AUD_coh_list, AUD_pc );
[VIS_xData, VIS_yData] = prepareCurveData( VIS_coh_list, VIS_pc );

% Set up fittype and options.
ft = fittype( '1-exp(-(x/a)^k)', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [1e-06 -Inf];
opts.StartPoint = [0.884990233378475 0.276025076998578];

% Fit model to data.
[AUD_fitresult, AUD_gof] = fit( AUD_xData, AUD_yData, ft, opts );
[VIS_fitresult, VIS_gof] = fit( VIS_xData, VIS_yData, ft, opts );

% Plot fit with data.
fig = figure( 'Name', 'Psychometric Function' );
h_AUD = plot(AUD_fitresult, AUD_xData, AUD_yData, 'DisplayName', 'AUD');
hold on
h_VIS = plot(VIS_fitresult, VIS_xData, VIS_yData, 'DisplayName', 'VIS');
hold off
legend('Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'Coherence (9 = -1 Coh (Leftward) / 11 = +1 Coh (Rightward))', 'Interpreter', 'none' );
ylabel( '% Rightward Response', 'Interpreter', 'none' );
xlim([9 11])
ylim([0 1])
grid on


