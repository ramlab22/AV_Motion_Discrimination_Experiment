function [fig, AUD_mu, VIS_mu, AV_mu, AUD_std_cumulative_gaussian, VIS_std_cumulative_gaussian, AV_std_cumulative_gaussian,Results_MLE] = createFit_NormCDF_modalities(AUD_coh_list, AUD_probRresp, VIS_coh_list, VIS_probRresp, AV_coh_list, AV_probRresp, audInfo, dotInfo, AVInfo, save_name)
%fit psychometric function to A,V,andAV discrimination data collected via staircase method, with each
%data point weighted in the psychometric function fit by the # of trials it represents
    [AUD_xData, AUD_yData] = prepareCurveData(AUD_coh_list, AUD_probRresp);
    [VIS_xData, VIS_yData] = prepareCurveData(VIS_coh_list, VIS_probRresp);
    [AV_xData, AV_yData] = prepareCurveData(AV_coh_list, AV_probRresp);

    % AUD
    AUD_mu = mean(AUD_yData);
    AUD_sigma = std(AUD_yData);
    AUD_parms = [AUD_mu, AUD_sigma];

    % VIS
    VIS_mu = mean(VIS_yData);
    VIS_sigma = std(VIS_yData);
    VIS_parms = [VIS_mu, VIS_sigma];
    
    % AV
    AV_mu = mean(AV_yData);
    AV_sigma = std(AV_yData);
    AV_parms = [AV_mu, AV_sigma];
    
    %get frequency of trials corresponding to each coherence for weights
    all_sizes_AUD = nonzeros([flip(audInfo.cohFreq_left(2,:)'), audInfo.cohFreq_right(2,:)']);
    all_sizes_AUD = all_sizes_AUD(1:length(AUD_xData));
    
    all_sizes_VIS = nonzeros([flip(dotInfo.cohFreq_left(2,:)'), dotInfo.cohFreq_right(2,:)']);
    all_sizes_VIS = all_sizes_VIS(1:length(VIS_xData));

    all_sizes_AV = nonzeros([flip(AVInfo.cohFreq_left_vis(2,:)'), AVInfo.cohFreq_right_vis(2,:)']);
    all_sizes_AV = all_sizes_AV(1:length(AV_xData));

    normalcdf_fun = @(b, x) 0.5 * (1 + erf((x - b(1)) ./ (b(2) * sqrt(2))));

    AUD_mdl = fitnlm(AUD_xData, AUD_yData, normalcdf_fun, AUD_parms, 'Weights', all_sizes_AUD);
    VIS_mdl = fitnlm(VIS_xData, VIS_yData, normalcdf_fun, VIS_parms, 'Weights', all_sizes_VIS);
    AV_mdl = fitnlm(AV_xData, AV_yData, normalcdf_fun, AV_parms, 'Weights', all_sizes_AV);

    x = min([AUD_xData(:); VIS_xData(:); AV_xData(:)]):0.01:max([AUD_xData(:); VIS_xData(:); AV_xData(:)]);

    AUD_p = cdf('Normal', x, AUD_mdl.Coefficients{1, 1}, AUD_mdl.Coefficients{2, 1});
    VIS_p = cdf('Normal', x, VIS_mdl.Coefficients{1, 1}, VIS_mdl.Coefficients{2, 1});
    AV_p = cdf('Normal', x, AV_mdl.Coefficients{1, 1}, AV_mdl.Coefficients{2, 1});

    AUD_mu = AUD_mdl.Coefficients{1, 1};
    VIS_mu = VIS_mdl.Coefficients{1, 1};
    AV_mu = AV_mdl.Coefficients{1, 1};

    AUD_std_cumulative_gaussian = AUD_mdl.Coefficients{2, 1}
    VIS_std_cumulative_gaussian = VIS_mdl.Coefficients{2, 1}
    AV_std_cumulative_gaussian = AV_mdl.Coefficients{2, 1}

    % Plot fit with data.
    fig = figure('Name', 'Psychometric Function');
    scatter(AUD_xData, AUD_yData, all_sizes_AUD, 'red','LineWidth',2);
    hold on
    scatter(VIS_xData, VIS_yData, all_sizes_VIS, 'blue', 'LineWidth',2);
    scatter(AV_xData, AV_yData, all_sizes_AV, 'black', 'LineWidth',2);
    plot(x, AUD_p, 'red', x, VIS_p, 'blue', x, AV_p, 'black','LineWidth',2.5);

    % Label axes
    title(sprintf('AUD,VIS,AV Psych. Func. L&R\n%s', save_name), 'Interpreter', 'none');
    xlabel('Coherence ((+)Rightward, (-)Leftward)', 'Interpreter', 'none');
    ylabel('% Rightward Response', 'Interpreter', 'none');
    max_cohval = max([VIS_xData(:); AUD_xData(:); AV_xData(:)]);
    xlim([-max_cohval max_cohval]);
    ylim([0 1]);
   % axis equal
    
    grid on
    legend('AUD', 'VIS', 'AV', 'AUD - NormCDF', 'VIS - NormCDF', 'AV - NormCDF', 'Location', 'NorthWest', 'Interpreter', 'none');
    ax = gca; 
    ax.FontSize = 16;
    [Results_MLE] = MLE_Calculations_A_V_AV(x,AUD_p,VIS_p,AV_p,AUD_mdl, VIS_mdl, AV_mdl,AUD_yData,VIS_yData, AV_yData,AUD_xData,VIS_xData, AV_xData)
end

