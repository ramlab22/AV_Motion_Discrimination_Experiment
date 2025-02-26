function [fig, AUD_curve_xvals, VIS_curve_xvals,...
               AV_curve_xvals, AUD_curve_yvals,VIS_curve_yvals,AV_curve_yvals,...
               AUD_xData, AUD_yData,VIS_xData, VIS_yData,AV_xData, AV_yData,...
               AUD_mu, VIS_mu, AV_mu, AUD_std_gaussian, VIS_std_gaussian, AV_std_gaussian,AUD_prop_Rresp_zerocoh,VIS_prop_Rresp_zerocoh,AV_prop_Rresp_zerocoh] = createFit_NormCDF_modalities(AUD_dataout,VIS_dataout,AV_dataout,AUD_coh_list, AUD_pc,...
                                                                              VIS_coh_list, VIS_pc,...
                                                                             AV_coh_list, AV_pc,...
                                                                              audInfo, dotInfo, AVInfo,save_name)
%CREATEFIT(COH_LIST,PC_AUD)
%  Create a fit.



%% Fit: 'untitled fit 1'.
[AUD_xData, AUD_yData] = prepareCurveData( AUD_coh_list, AUD_pc );
[VIS_xData, VIS_yData] = prepareCurveData( VIS_coh_list, VIS_pc );
[AV_xData, AV_yData] = prepareCurveData( AV_coh_list, AV_pc );

%%AUD
AUD_mu = mean(AUD_yData);
AUD_sigma =std(AUD_yData);
AUD_parms = [AUD_mu, AUD_sigma];
%%VIS
VIS_mu = mean(VIS_yData);
VIS_sigma =std(VIS_yData);
VIS_parms = [VIS_mu, VIS_sigma];

%AV
AV_mu = mean(AV_yData);
AV_sigma =std(AV_yData);
AV_parms = [AV_mu, AV_sigma];
%Plot different sizes based on amount of frequency of each coh
sizes_L_AUD = flip(audInfo.cohFreq_left(2,:)');%Slpit to left and Right 
sizes_R_AUD = audInfo.cohFreq_right(2,:)';
all_sizes_AUD = nonzeros(vertcat(sizes_L_AUD, sizes_R_AUD));
if length(AUD_xData) ~= length(all_sizes_AUD)
    all_sizes_AUD = all_sizes_AUD(1:length(AUD_xData));
end
if any(AUD_coh_list == 0)
        [AUD_prop_Rresp_zerocoh] = propRresp_catchtrials(AUD_dataout) ;
        AUD_catch_idx=find(AUD_xData==0);
        
        AUD_prop_Rresp_zerocoh_array = AUD_prop_Rresp_zerocoh/100 * ones(size(AUD_catch_idx));
        AUD_yData(AUD_catch_idx,1)=AUD_prop_Rresp_zerocoh_array;

        AUD_dotsize_zerocoh_array =  sum(all_sizes_AUD(AUD_catch_idx)) * ones(size(AUD_catch_idx));
        all_sizes_AUD(AUD_catch_idx,1)=AUD_dotsize_zerocoh_array;
else
    AUD_prop_Rresp_zerocoh=NaN;
end

sizes_L_VIS = flip(dotInfo.cohFreq_left(2,:)');%Slpit to left and Right 
sizes_R_VIS = dotInfo.cohFreq_right(2,:)';
all_sizes_VIS = nonzeros(vertcat(sizes_L_VIS, sizes_R_VIS));
if length(VIS_xData) ~= length(all_sizes_VIS)
    all_sizes_VIS = all_sizes_VIS(1:length(VIS_xData));
end
if any(VIS_coh_list == 0)
        [VIS_prop_Rresp_zerocoh] = propRresp_catchtrials(VIS_dataout) ;
        VIS_catch_idx=find(VIS_xData==0);
        
        VIS_prop_Rresp_zerocoh_array = VIS_prop_Rresp_zerocoh/100 * ones(size(VIS_catch_idx));
        VIS_yData(VIS_catch_idx,1)=VIS_prop_Rresp_zerocoh_array;

        VIS_dotsize_zerocoh_array = sum(all_sizes_VIS(VIS_catch_idx)) * ones(size(VIS_catch_idx));
        all_sizes_VIS(VIS_catch_idx,1)=VIS_dotsize_zerocoh_array;
else
    VIS_prop_Rresp_zerocoh=NaN;
end

sizes_L_AV = flip(AVInfo.cohFreq_left_vis(2,:)');%Slpit to left and Right 
sizes_R_AV = AVInfo.cohFreq_right_vis(2,:)';
all_sizes_AV = nonzeros(vertcat(sizes_L_AV, sizes_R_AV));
if length(AV_xData) ~= length(all_sizes_AV)
    all_sizes_AV = all_sizes_AV(1:length(AV_xData));
end
if any(AV_coh_list == 0)
        [AV_prop_Rresp_zerocoh] = propRresp_catchtrials(AV_dataout) ;
        AV_catch_idx=find(AV_xData==0);
        
        AV_prop_Rresp_zerocoh_array = AV_prop_Rresp_zerocoh/100 * ones(size(AV_catch_idx));
        AV_yData(AV_catch_idx,1)=AV_prop_Rresp_zerocoh_array;

        AV_dotsize_zerocoh_array = sum(all_sizes_AV(AV_catch_idx)) * ones(size(AV_catch_idx));
        all_sizes_AV(AV_catch_idx,1)=AV_dotsize_zerocoh_array;
 else
    AV_prop_Rresp_zerocoh=NaN;
end



% Initialize parameters for fitting
AUD_mu = mean(AUD_xData); % Use mean of xData for the initial guess of mu
AUD_sigma = std(AUD_xData); % Use standard deviation of xData for initial guess of sigma
AUD_floor_value = min(AUD_yData);
AUD_ceiling_value = max(AUD_yData);
AUD_parms = [AUD_mu, AUD_sigma, AUD_floor_value, AUD_ceiling_value];
VIS_mu = mean(VIS_xData); % Use mean of xData for the initial guess of mu
VIS_sigma = std(VIS_xData); % Use standard deviation of xData for initial guess of sigma
VIS_floor_value = min(VIS_yData);
VIS_ceiling_value = max(VIS_yData);
VIS_parms = [VIS_mu, VIS_sigma, VIS_floor_value, VIS_ceiling_value];
AV_mu = mean(AV_xData); % Use mean of xData for the initial guess of mu
AV_sigma = std(AV_xData); % Use standard deviation of xData for initial guess of sigma
AV_floor_value = min(AV_yData);
AV_ceiling_value = max(AV_yData);
AV_parms = [AV_mu, AV_sigma, AV_floor_value, AV_ceiling_value];
% Define modified normal CDF function with floor and ceiling
% b(1) = mu, b(2) = sigma, b(3) = floor_value, b(4) = ceiling_value
modified_cdf = @(b, x) b(3) + (b(4) - b(3)) * (1 + erf((x - b(1)) / (b(2) * sqrt(2)))) / 2;
% Optimization settings
opts = optimset('MaxFunEvals', 50000, 'MaxIter', 10000);
%lb = [-Inf, 0, floor_value, -Inf]; % Ensure non-negative sigma
%ub = [Inf, Inf, ceiling_value, Inf];
lb = [-Inf, 0, 0, 0]; % lb = [mu_lower, sigma_lower, floor_value_lower, ceiling_value_lower]
ub = [Inf, Inf, 1, 1]; % ub = [mu_upper, sigma_upper, floor_value_upper, ceiling_value_upper]

% Fit the model with bounds
AUD_mdl = lsqcurvefit(@(b, x) modified_cdf(b, x), AUD_parms, AUD_xData, AUD_yData, lb, ub, opts);
VIS_mdl = lsqcurvefit(@(b, x) modified_cdf(b, x), VIS_parms, VIS_xData, VIS_yData, lb, ub, opts);
AV_mdl = lsqcurvefit(@(b, x) modified_cdf(b, x), AV_parms, AV_xData, AV_yData, lb, ub, opts);
% Calculate the slope of the dynamic range
[AUD_slope_dynamicrange,AUD_std_gaussian_scaled,AUD_coherence_low,AUD_coherence_high] = calculate_slope_dynamic_range(AUD_mdl);
fprintf('Slope of the AUD_dynamic range: %.4f\n', AUD_slope_dynamicrange);
[VIS_slope_dynamicrange,VIS_std_gaussian_scaled,VIS_coherence_low,VIS_coherence_high] = calculate_slope_dynamic_range(VIS_mdl);
fprintf('Slope of the VIS_dynamic range: %.4f\n', VIS_slope_dynamicrange);
[AV_slope_dynamicrange,AV_std_gaussian_scaled,AV_coherence_low,AV_coherence_high] = calculate_slope_dynamic_range(AV_mdl);
fprintf('Slope of the AV_dynamic range: %.4f\n', AV_slope_dynamicrange);
% Generate values for plotting the fitted curve
AUD_curve_xvals = min(AUD_xData(:)):.01:max(AUD_xData(:));
AUD_curve_yvals = modified_cdf(AUD_mdl, AUD_curve_xvals);
VIS_curve_xvals = min(VIS_xData(:)):.01:max(VIS_xData(:));
VIS_curve_yvals = modified_cdf(VIS_mdl, VIS_curve_xvals);
AV_curve_xvals = min(AV_xData(:)):.01:max(AV_xData(:));
AV_curve_yvals = modified_cdf(AV_mdl, AV_curve_xvals);

 % Extract and calculate relevant statistics
    AUD_mu = AUD_mdl(1);  % Mean of the distribution
    AUD_std_gaussian = AUD_mdl(2);  % Standard deviation of the Gaussian
    AUD_dy_dx = diff(AUD_curve_yvals) ./ diff(AUD_curve_xvals);  % Slope of the CDF curve
    AUD_overall_slope = mean(AUD_dy_dx);  % Average  overall slope. ignore, not informative bc of dynamic range
    AUD_slope_at_50_percent = 1 / (AUD_std_gaussian * sqrt(2 * pi));  % Slope at 50% response

  % Extract and calculate relevant statistics
    VIS_mu = VIS_mdl(1);  % Mean of the distribution
    VIS_std_gaussian = VIS_mdl(2);  % Standard deviation of the Gaussian
    VIS_dy_dx = diff(VIS_curve_yvals) ./ diff(VIS_curve_xvals);  % Slope of the CDF curve
    VIS_overall_slope = mean(VIS_dy_dx);  % Average  overall slope. ignore, not informative bc of dynamic range
    VIS_slope_at_50_percent = 1 / (VIS_std_gaussian * sqrt(2 * pi));  % Slope at 50% response

   AV_mu = AV_mdl(1);  % Mean of the distribution
    AV_std_gaussian = AV_mdl(2);  % Standard deviation of the Gaussian
    AV_dy_dx = diff(AV_curve_yvals) ./ diff(AV_curve_xvals);  % Slope of the CDF curve
    AV_overall_slope = mean(AV_dy_dx);  % Average  overall slope. ignore, not informative bc of dynamic range
    AV_slope_at_50_percent = 1 / (AV_std_gaussian * sqrt(2 * pi));  % Slope at 50% response


% Plot fit with data.
fig = figure( 'Name', 'Psychometric Function' );
scatter(AUD_xData, AUD_yData, all_sizes_AUD, 'red', 'filled', 'LineWidth', 2.2)
hold on
scatter(VIS_xData, VIS_yData, all_sizes_VIS, 'blue', 'filled', 'LineWidth', 2.2)
scatter(AV_xData, AV_yData, all_sizes_AV, 'black', 'filled', 'LineWidth', 2.2)
max_cohval=max([VIS_xData(:); AUD_xData(:); AV_xData(:)]);
plot(AUD_curve_xvals, AUD_curve_yvals, "red",...
        VIS_curve_xvals, VIS_curve_yvals, "blue",...
        AV_curve_xvals, AV_curve_yvals, 'black','LineWidth', 2.5);

legend('AUD','VIS','AV', 'AUD - NormCDF', 'VIS - NormCDF', 'AV - NormCDF', 'Location', 'northwest', 'Interpreter', 'none' );
% Label axes
title(sprintf('AUD,VIS,AV Psych. Func. L&R\n%s', save_name), 'Interpreter', 'none');
xlabel( 'Coherence ((+)Rightward, (-)Leftward)', 'Interpreter', 'none' );
ylabel( '% Rightward Response', 'Interpreter', 'none' );
xlim([(-1*max_cohval) max_cohval])
ylim([0 1.1])
ax = gca; 
ax.FontSize = 22;
    text(0.15, .2, "AUD slope of dynamic range: " + sprintf('%.3f', AUD_slope_dynamicrange), 'FontSize', 16);
    text(0.15, .15, "VIS slope of dynamic range: " + sprintf('%.3f', VIS_slope_dynamicrange), 'FontSize', 16);
    text(0.15, .1, "AV slope of dynamic range: " + sprintf('%.3f', AV_slope_dynamicrange), 'FontSize', 16);

grid on

end
