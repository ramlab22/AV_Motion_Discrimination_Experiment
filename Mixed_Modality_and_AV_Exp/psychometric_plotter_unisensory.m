function [x, y, fig, coeff_p_values,ci,threshold,std_gaussian_scaled] = psychometric_plotter_unisensory(uni_dataout,uni_prob_Right, uni_prob_Left,uniInfo,save_name)
%PYSCHOMETRIC_PLOTTER Summary of this function goes here
%  Must take 1-prob_Left to get the probability of a rightward choice, the
%  input probabilities are in regards to the corrrect choice(i.e. in that
%  direction)

xR = uni_prob_Right(:,1)'; 
xL = flip(-1*(uni_prob_Left(:,1)))'; %-1 to get on other side of x axis
x = cat(2,xL,xR); 
yL = flip(uni_prob_Left(:,2))';
yR = uni_prob_Right(:,2)';
y = cat(2,yL,yR);  

plot_data = [x; y]'; 
%plot_data(end+1,:) = prob_zero(:,1:2); 
plot_data = plot_data(~isnan(plot_data(:,2)),:); 
coeff_p_values=0;
ci=0;
threshold=0;
% [fig_old, coeff_p_values,ci,threshold,std_gaussian] = createFit_NormCDF(uni_dataout,plot_data(:,1), plot_data(:,2)/100, uniInfo,save_name); 
% close(fig_old);
if isfield(uniInfo,'n_aud_trials')
    [fig, ~, std_gaussian_scaled, ~, ~, ~, ~] = createFit_NormCDF_FLRnCLNG_scalingfix_unisensory(uni_dataout,plot_data(:,1),plot_data(:,2)/100, uniInfo, save_name, 'red');
end
if isfield(uniInfo,'n_vis_trials')
    [fig, ~, std_gaussian_scaled, ~, ~, ~, ~] = createFit_NormCDF_FLRnCLNG_scalingfix_unisensory(uni_dataout,plot_data(:,1),plot_data(:,2)/100, uniInfo, save_name, 'blue');
end
% figure(1)
% clf
% 
% scatter(x,y,'MarkerFaceColor','b');
% title('Psychometric Function')
% set(gca,'XLim',[-1 1]); 
% set(gca,'YLim',[0,100]);
% xlabel('Coherence (Neg. Val. = Leftward Motion)');
% ylabel('Probability of Rightward Response (%)');


end

