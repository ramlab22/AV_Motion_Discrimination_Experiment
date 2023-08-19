function [fit_mean_midpoint,fit_standarddeviation_slope,curve_xvals,curve_yvals] = get_LRfunction_threshold(dataout,audInfo,ExpInfo)

total_trials = ExpInfo.num_trials;  
num_regular_trials = total_trials - audInfo.catchtrials;  
num_catch_trials = audInfo.catchtrials; 

[Fixation_Success_Rate, AUD_Success_Rate, Target_Success_Rate_Regular, Target_Success_Rate_Catch] = SR_CALC(dataout,total_trials,num_regular_trials,num_catch_trials)

%Break down of each success rate based on coherence level 
%Count how many rew and N/A per coherence 
audInfo.cohFreq = cohFreq_finder(dataout, audInfo); %how many trials successfully completed per coh level

prob = coherence_probability(dataout,audInfo)
%    prob_zero = prob(1,:); 

[RightTrials_dataout, LeftTrials_dataout] = direction_splitter(dataout);

audInfo.cohFreq_right = cohFreq_finder(RightTrials_dataout, audInfo);
audInfo.cohFreq_left = cohFreq_finder(LeftTrials_dataout, audInfo);

probR_RightTrials = directional_probability(RightTrials_dataout, audInfo); 
probR_LeftTrials = directional_probability(LeftTrials_dataout, audInfo); 

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

mu = mean(yData);
sigma =std(yData);

fun_1 = @(b, x)cdf('Normal', x, b(1), b(2));
fun = @(b)sum((fun_1(b,xData) - yData).^2); 
opts = optimset('MaxFunEvals',50000, 'MaxIter',10000); 
fit_params = fminsearch(fun, [mu, sigma], opts);
fit_mean_midpoint=fit_params(1);
fit_standarddeviation_slope=fit_params(2);

curve_xvals = -1:.01:1;
curve_yvals = cdf('Normal', curve_xvals, fit_params(1), fit_params(2));

%Plot different sizes based on amount of frequency of each coh
sizes_L = flip(audInfo.cohFreq_left(2,:)');%Slpit to left and Right 
sizes_R = audInfo.cohFreq_right(2,:)';
all_sizes = nonzeros(vertcat(sizes_L, sizes_R));

%[x, y, fig_both] = psychometric_plotter(prob_Right,prob_Left, audInfo, save_name);

% Plot fit with data.
fig = figure( 'Name', 'Psychometric Function' );
scatter(xData, yData, all_sizes)
hold on 
plot(curve_xvals, curve_yvals);
legend('% Rightward Resp. vs. Coherence', 'NormCDF', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
%title(sprintf('Auditory Psych. Func. L&R\n%s',save_name), 'Interpreter','none');
xlabel( 'Coherence ((-)Leftward,(+)Rightward)', 'Interpreter', 'none' );
ylabel( '% Rightward Response', 'Interpreter', 'none' );
xlim([-1 1])
ylim([0 1])
grid on

end