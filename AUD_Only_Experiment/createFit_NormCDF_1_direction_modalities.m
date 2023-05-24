function [fig] = createFit_NormCDF_1_direction_modalities(AUD_coh_list, AUD_pc,...
                                                          VIS_coh_list, VIS_pc,...
                                                          AV_coh_list_aud, AV_aud_pc,...
                                                           AV_coh_list_vis, AV_vis_pc,...
                                                          direction, audInfo, dotInfo, AVInfo, save_name)
%CREATEFIT(COH_LIST,PC_AUD)
%  Create a fit.
% direction = string 'RIGHT' or "LEFT' 


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
if strcmp(direction, "RIGHT ONLY")
    % Objective Function (gaussian/normal)
    fun_1 = @(b, x)cdf('Normal', x, b(1), b(2));
elseif strcmp(direction, "LEFT ONLY")
    % Objective Function (gaussian/normal INVERTED)
    fun_1 = @(b, x) 1-(cdf('Normal', x, b(1), b(2)));
end
AUD_fun = @(b)sum((fun_1(b,AUD_xData) - AUD_yData).^2); 
VIS_fun = @(b)sum((fun_1(b,VIS_xData) - VIS_yData).^2); 
AV_aud_fun = @(b)sum((fun_1(b,AV_aud_xData) - AV_aud_yData).^2);
AV_vis_fun = @(b)sum((fun_1(b,AV_vis_xData) - AV_vis_yData).^2);
opts = optimset('MaxFunEvals',50000, 'MaxIter',10000); 

 % Estimate Parameters using error minimization procedure
AUD_fit_par = fminsearch(AUD_fun, AUD_parms, opts);
VIS_fit_par = fminsearch(VIS_fun, VIS_parms, opts);
AV_aud_fit_par = fminsearch(AV_aud_fun, AV_aud_parms, opts);
AV_vis_fit_par = fminsearch(AV_vis_fun, AV_vis_parms, opts);


x = -1:.01:1;
AUD_p = cdf('Normal', x, AUD_fit_par(1), AUD_fit_par(2));
VIS_p = cdf('Normal', x, VIS_fit_par(1), VIS_fit_par(2));
AV_aud_p = cdf('Normal', x, AV_aud_fit_par(1), AV_aud_fit_par(2));
AV_vis_p = cdf('Normal', x, AV_vis_fit_par(1), AV_vis_fit_par(2));


%Size of scatter point based on frequency
if strcmp(direction, "RIGHT ONLY")
    sizes_AUD = nonzeros(audInfo.cohFreq_right(2,:)');
    sizes_VIS = nonzeros(dotInfo.cohFreq_right(2,:)');
    sizes_AV_aud = nonzeros(AVInfo.cohFreq_right_aud(2,:)');
    sizes_AV_vis = nonzeros(AVInfo.cohFreq_right_vis(2,:)');

elseif strcmp(direction, "LEFT ONLY")
    sizes_AUD = nonzeros(audInfo.cohFreq_left(2,:)');
    sizes_VIS = nonzeros(dotInfo.cohFreq_left(2,:)');
    sizes_AV_aud = nonzeros(AVInfo.cohFreq_left_aud(2,:)');
    sizes_AV_vis = nonzeros(AVInfo.cohFreq_left_vis(2,:)');
    
end

if length(AUD_xData) ~= length(sizes_AUD)
    sizes_AUD = sizes_AUD(1:length(AUD_xData));
end

if length(VIS_xData) ~= length(sizes_VIS)
    sizes_VIS = sizes_VIS(1:length(VIS_xData));
end

if length(AV_aud_xData) ~= length(sizes_AV_aud)
    sizes_AV_aud = sizes_AV_aud(1:length(AV_aud_xData));
end

if length(AV_vis_xData) ~= length(sizes_AV_vis)
    sizes_AV_vis = sizes_AV_vis(1:length(AV_vis_xData));
end

% Plot fit with data.
fig = figure( 'Name', sprintf('Psychometric Function %s',direction) );
scatter(AUD_xData, AUD_yData, sizes_AUD, 'red', 'LineWidth',2)
hold on 
scatter(VIS_xData, VIS_yData, sizes_VIS, 'blue', 'LineWidth',2)
%scatter(AV_aud_xData, AV_aud_yData, sizes_AV_aud, 'green', 'LineWidth',2)
scatter(AV_vis_xData, AV_vis_yData, sizes_AV_vis, 'black','LineWidth',2)

% plot(x, AUD_p, "red",...
%         x, VIS_p, "blue",...
%         x, AV_aud_p, 'green',...
%         x, AV_vis_p, 'black','LineWidth',3);
if strcmp(direction, "RIGHT ONLY")
    plot(x, AUD_p, "red",...
        x, VIS_p, "blue",...
        x, AV_vis_p, 'black','LineWidth',3);
elseif strcmp(direction, "LEFT ONLY")
    plot(x, 1-AUD_p, "red",...
        x, 1-VIS_p, "blue",...
        x, 1-AV_vis_p, 'black','LineWidth',3);
end


%legend('AUD','VIS','AV_aud','AV_vis', 'AUD - NormCDF', 'VIS - NormCDF','AV_aud - NormCDF', 'AV_vis - NormCDF', 'Location', 'Best', 'Interpreter', 'none' );
legend('AUD','VIS','AV', 'AUD - NormCDF', 'VIS - NormCDF','AV - NormCDF', 'Location', 'Best', 'Interpreter', 'none' );

% Label axes
title(sprintf('AUD & VIS Psych. Func. %s\n%s', direction, save_name), 'Interpreter', 'none');
xlabel( 'Coherence %', 'Interpreter', 'none' );
ylabel( '% Rightward Response', 'Interpreter', 'none' );
xlim([0 1])
ylim([0 1])
ax = gca; 
ax.FontSize = 16;
grid on


