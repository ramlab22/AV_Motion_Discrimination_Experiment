function [fig, AUD_mu, VIS_mu, AUD_std_cumulative_gaussian, VIS_std_cumulative_gaussian, Results_MLE] = createFit_NormCDF_AandV(AUD_coh_list, AUD_probRresp, VIS_coh_list, VIS_probRresp, audInfo, dotInfo,save_name)
    % Fit: 'untitled fit 1'.
    [AUD_xData, AUD_yData] = prepareCurveData(AUD_coh_list, AUD_probRresp);
    [VIS_xData, VIS_yData] = prepareCurveData(VIS_coh_list, VIS_probRresp);

    % AUD
    AUD_mu = mean(AUD_yData);
    AUD_sigma = std(AUD_yData);
    AUD_parms = [AUD_mu, AUD_sigma];

    % VIS
    VIS_mu = mean(VIS_yData);
    VIS_sigma = std(VIS_yData);
    VIS_parms = [VIS_mu, VIS_sigma];
    
  
    
    % Plot different sizes based on the amount of frequency of each coh
    all_sizes_AUD = nonzeros([flip(audInfo.cohFreq_left(2,:)'), audInfo.cohFreq_right(2,:)']);
    all_sizes_AUD = all_sizes_AUD(1:length(AUD_xData));
    
    all_sizes_VIS = nonzeros([flip(dotInfo.cohFreq_left(2,:)'), dotInfo.cohFreq_right(2,:)']);
    all_sizes_VIS = all_sizes_VIS(1:length(VIS_xData));

  
    fun_1 = @(b, x)cdf('Normal', x, b(1), b(2));
 
    AUD_fun = @(b) sum((fun_1(b, AUD_xData) - AUD_yData).^2);
    VIS_fun = @(b) sum((fun_1(b, VIS_xData) - VIS_yData).^2);

    %opts = optimset('MaxFunEvals', 50000, 'MaxIter', 10000);

    % AUD_fit_par = fminsearch(AUD_fun, AUD_parms, opts);
    % VIS_fit_par = fminsearch(VIS_fun, VIS_parms, opts);
    % AV_fit_par = fminsearch(AV_fun, AV_parms, opts);
    fun_1 = @(b, x)cdf('Normal', x, b(1), b(2));
 
    AUD_fun = @(b) sum((fun_1(b, AUD_xData) - AUD_yData).^2);
    VIS_fun = @(b) sum((fun_1(b, VIS_xData) - VIS_yData).^2);

    normalcdf_fun = @(b, x) 0.5 * (1 + erf((x - b(1)) ./ (b(2) * sqrt(2))));

    AUD_mdl = fitnlm(AUD_xData, AUD_yData, normalcdf_fun, AUD_parms, 'Weights', all_sizes_AUD);
    VIS_mdl = fitnlm(VIS_xData, VIS_yData, normalcdf_fun, VIS_parms, 'Weights', all_sizes_VIS);

    x = min([AUD_xData(:); VIS_xData(:)]):0.01:max([AUD_xData(:); VIS_xData(:)]);

    AUD_p = cdf('Normal', x, AUD_mdl.Coefficients{1, 1}, AUD_mdl.Coefficients{2, 1});
    VIS_p = cdf('Normal', x, VIS_mdl.Coefficients{1, 1}, VIS_mdl.Coefficients{2, 1});

    AUD_mu = AUD_mdl.Coefficients{1, 1};
    VIS_mu = VIS_mdl.Coefficients{1, 1};

    AUD_std_cumulative_gaussian = AUD_mdl.Coefficients{2, 1}
    VIS_std_cumulative_gaussian = VIS_mdl.Coefficients{2, 1}

    % Plot fit with data.
    fig = figure('Name', 'Psychometric Function');
    scatter(AUD_xData, AUD_yData, all_sizes_AUD, 'red','LineWidth',2.2);
    hold on
    scatter(VIS_xData, VIS_yData, all_sizes_VIS, 'blue', 'LineWidth',2.2);
    plot(x, AUD_p, 'red', x, VIS_p, 'blue','LineWidth',7);

    % Label axes
    title(sprintf('Auditory and Visual Psychometric Function\n%s', save_name), 'Interpreter', 'none');
    xlabel('Coherence ((+)Rightward, (-)Leftward)', 'Interpreter', 'none');
    ylabel('Proportion Rightward Response', 'Interpreter', 'none');
    max_cohval = max([VIS_xData(:); AUD_xData(:)]);
    xlim([-max_cohval max_cohval]);
    ylim([0 1]);
   % axis equal
    
    grid on
    legend('AUD', 'VIS', 'AUD - NormCDF', 'VIS - NormCDF', 'Location', 'NorthWest', 'Interpreter', 'none');
    ax = gca; 
    ax.FontSize = 30;

[Results_MLE] = MLE_Calculations_A_V(AUD_mdl, VIS_mdl,AUD_yData,VIS_yData, AUD_xData,VIS_xData,all_sizes_AUD,all_sizes_VIS)
end
