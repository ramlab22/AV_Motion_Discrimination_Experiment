function [slope_at_50_percent,slope,slope_std,mu,curve_xvals,curve_yvals,std_gaussian,prob] = get_threshold_combinedblocks(dataout,coherences,totalfiles_names,condition,show_results_and_figs)
%condition: 1=visual, 2=auditory, 3=AV
%show_results_and_figs: 1=generate psychometric function figure and print results of analysis in command window, else: don't generate figure
total_trials = length(dataout);  
num_regular_trials = length(dataout);    
num_catch_trials =0; 
%Break down of each success rate based on coherence level 
%Count how many rew and N/A per coherence 
if condition==1
    dataout=convert_vis_directioncode(dataout);
end
if condition==1 || condition==2
    audInfo.coherences=coherences;
    audInfo.cohFreq = cohFreq_finder(dataout, audInfo); %how many trials successfully completed per coh level
    if show_results_and_figs==1
        prob = coherence_probability(dataout,audInfo)
    else
        prob = coherence_probability(dataout,audInfo);
    end
end
if condition==3
    
    audInfo.cohSet_aud=coherences(1,:);
    audInfo.cohSet_dot=coherences(2,:);
    %not sure what the dif btwn cohSet and coherences is for this but the
    %function requires both
    audInfo.coherences_aud=coherences(1,:);
    audInfo.coherences_dot=coherences(2,:);

    [audInfo.cohFreq_aud, audInfo.cohFreq_vis] = cohFreq_finder_AV(dataout, audInfo);
    if show_results_and_figs==1
        prob = coherence_probability_AV(dataout,audInfo)
    else
        prob = coherence_probability_AV(dataout,audInfo);
    end
end

 %will need to change this for AV once we have incongruent trials and once
%AV congruent no longer has equal coherences!!!
[RightTrials_dataout, LeftTrials_dataout] = direction_splitter(dataout);
if condition==1 || condition==2
    audInfo.cohFreq_right = cohFreq_finder(RightTrials_dataout, audInfo);
    audInfo.cohFreq_left = cohFreq_finder(LeftTrials_dataout, audInfo);
    probR_RightTrials = directional_probability(RightTrials_dataout, audInfo); 
    probR_LeftTrials = directional_probability(LeftTrials_dataout, audInfo); 
else
    [audInfo.cohFreq_right_aud, audInfo.cohFreq_right_vis] = cohFreq_finder_AV(RightTrials_dataout, audInfo);
    [audInfo.cohFreq_left_aud, audInfo.cohFreq_left_vis] = cohFreq_finder_AV(LeftTrials_dataout, audInfo);
    probR_RightTrials = directional_probability_AV(RightTrials_dataout, audInfo,'Right');
    probR_RightTrials(:,1)=audInfo.coherences_aud';
    probR_LeftTrials = directional_probability_AV(LeftTrials_dataout, audInfo,'Left'); 
    probR_LeftTrials(:,1)=audInfo.coherences_aud';

end




%[x, y, fig_both] = psychometric_plotter(prob_Right,prob_Left, audInfo, save_name);

xR = probR_RightTrials(:,1)'; 
xL = flip(-1*(probR_LeftTrials(:,1)))'; %-1 to get on other side of x axis
curve_xvals = cat(2,xL,xR); 
yL = flip(probR_LeftTrials(:,2))';
yR = probR_RightTrials(:,2)';
y = cat(2,yL,yR);  

plot_data = [curve_xvals; y]'; 
%plot_data(end+1,:) = prob_zero(:,1:2); 
plot_data = plot_data(~isnan(plot_data(:,2)),:); 


coh_list=plot_data(:,1);
probability_rightward_response=plot_data(:,2)/100;

[xData, yData] = prepareCurveData(coh_list,probability_rightward_response);
%Plot different sizes based on amount of frequency of each coh
if condition==1 || condition==2
    sizes_L = flip(audInfo.cohFreq_left(2,:)');%Slpit to left and Right 
    sizes_R = audInfo.cohFreq_right(2,:)';
    all_sizes = nonzeros(vertcat(sizes_L, sizes_R));
else %NEED TO CHANGE THIS ONCE A AND V NO LONGER HAVE SAME COHERENCES
    sizes_L = flip(audInfo.cohFreq_left_aud(2,:)');%Slpit to left and Right 
    sizes_R = audInfo.cohFreq_right_aud(2,:)';
    all_sizes = nonzeros(vertcat(sizes_L, sizes_R));
end


mu = mean(yData);
sigma =std(yData);
parms=[mu, sigma]; %initial parameter estimates

% fun_1 = @(b, x)cdf('Normal', x, b(1), b(2)); %normal cumulative distribution function with mean b(1) and standard deviation b(2)
% fun = @(b)sum((fun_1(b,xData) - yData).^2); %calculates the sum of squared residuals between the observed data yData and the model prediction fun_1(b, xData).
% opts = optimset('MaxFunEvals',50000, 'MaxIter',10000); %structure of fminsearch optimization options (maximum number of function evaluations and iterations)
% fit_params = fminsearch(fun, parms, opts); %vector of two parameters estimated by minimizing the sum of squared residuals between the observed data yData and the model prediction fun_1(b, xData).
% fit_mean_midpoint=fit_params(1);
% fit_standarddeviation_slope=fit_params(2); %estimated standard deviation of the CDF that is used as a model to fit the data. controls the spread of the normal distribution and affects the shape of the fitted curve
% %New mdl to account for weights of PCs 
% normalcdf_fun = @(b, x) 0.5 * (1 + erf((x - b(1)) ./ (b(2) * sqrt(2))));
% mdl = fitnlm(xData, yData, normalcdf_fun, parms, 'Weights', all_sizes);
% fun_1 = @(b, x)cdf('Normal', x, b(1), b(2));
% fun = @(b)sum((fun_1(b,xData) - yData).^2); 
% opts = optimset('MaxFunEvals',50000, 'MaxIter',10000); 
% fit_par = fminsearch(fun, parms, opts);

%non-linear model to add weights to function fit based on # of trials per data point  
normalcdf_fun = @(b, x) 0.5 * (1 + erf((x - b(1)) ./ (b(2) * sqrt(2))));
mdl = fitnlm(xData, yData, normalcdf_fun, parms, 'Weights', all_sizes);

curve_xvals = min(xData(:)):.01:max(xData(:));

% Significance of fits 
[p_values, bootstat,ci] = p_value_calc(yData, parms);


curve_yvals = cdf('Normal', curve_xvals, mdl.Coefficients{1,1}, mdl.Coefficients{2,1});
%get threshold
mu= mdl.Coefficients{1,1};
%get std of cumulative gaussian (reflects the inherent variability of the psychophysical data)
std_gaussian= mdl.Coefficients{2,1};
slope_at_50_percent = 1 / (std_gaussian * sqrt(2 * pi));

%curve_xvals = -1:.01:1;
[ci,bootstat] = bootci(100,@(curve_xvals)[mean(curve_xvals) std(curve_xvals)],yData);

% if show_results_and_figs==1 
%     [ci,bootstat] = bootci(100,@(curve_xvals)[mean(curve_xvals) std(curve_xvals)],yData)
% else
%     [ci,bootstat] = bootci(100,@(curve_xvals)[mean(curve_xvals) std(curve_xvals)],yData);
% 
% end
% SE = (ci(2,:) - ci(1,:))./(2*1.96); %measure of the precision of the estimated mean of the data. reflects variability of the sample mean across different samples
% z = parms./SE; %slope?
%p_values = exp(-0.717.*z - 0.416.*z.^2);

%curve_yvals = cdf('Normal', curve_xvals, fit_params(1), fit_params(2));
% 
dy_dx = diff(curve_yvals) ./ diff(curve_xvals); % calculates the slope of the CDF curve by taking the difference between consecutive y-values and dividing by the difference between their corresponding x-values
slope = mean(dy_dx);
slope_std = std(bootstat(:,2));
% %get threshold
% threshold_location=find(curve_yvals >= chosen_threshold, 1);
% threshold=curve_xvals(1,threshold_location);

%[x, y, fig_both] = psychometric_plotter(prob_Right,prob_Left, audInfo, save_name);
if show_results_and_figs==1
    % Plot fit with data.
    fig = figure( 'Name', 'Psychometric Function' );
   
    scatter(xData, yData, all_sizes,'filled','LineWidth',5,'MarkerEdgeColor','k','MarkerFaceColor','k');
    hold on
    plot(curve_xvals, curve_yvals,'LineWidth',5);
    text(0,.2,"mu: " + mu);
    text(0,.1, "std cummulative gaussian: " + std_gaussian);
    text(0,.3, "slope at 50 percent: " + slope_at_50_percent);

    legend('% Rightward Resp. vs. Coherence', 'NormCDF','Location', 'Best', 'Interpreter', 'none' );

end
% Label axes

    if condition==1
        title(sprintf('Visual Psych. Func. L&R\n%s',totalfiles_names{1,1}(1:10)), 'Interpreter','none');
    elseif condition==2
        title(sprintf('Auditory Psych. Func. L&R\n%s',totalfiles_names{1,1}(1:10)), 'Interpreter','none');
    else
        title(sprintf('AV Psych. Func. L&R\n%s',totalfiles_names{1,1}(1:10)), 'Interpreter','none');
    end


    xlabel( 'Coherence ((-)Leftward,(+)Rightward)', 'Interpreter', 'none' );
    ylabel( '% Rightward Response', 'Interpreter', 'none' );
    xlim([-1 1]);
    ylim([0 1]);
    text(0,.2,"mu: " + mu);
    text(0,.1, "std cummulative gaussian: " + std_gaussian);
    text(0,.3, "slope at 50 percent: " + slope_at_50_percent);

    grid on
end %if generate_figure 

