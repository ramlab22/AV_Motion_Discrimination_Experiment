function [fig, AUD_mu, VIS_mu,  AUD_std_cumulative_gaussian, VIS_std_cumulative_gaussian, Results_MLE] =...
    psychometric_plotter_AandV(AUD_prob_Right, AUD_prob_Left, VIS_prob_Right, VIS_prob_Left,audInfo, dotInfo, save_name)


%PYSCHOMETRIC_PLOTTER Summary of this function goes here
%  Must take 1-prob_Left to get the probability of a rightward choice, the
%  input probabilities are in regards to the corrrect choice(i.e. in that
%  direction)

AUD.xR = AUD_prob_Right(:,1)'; 
AUD.xL = flip(-1*(AUD_prob_Left(:,1)))'; %-1 to get on other side of x axis
AUD.x = cat(2,AUD.xL,AUD.xR); 
AUD.yL = flip(AUD_prob_Left(:,2))';
AUD.yR = AUD_prob_Right(:,2)';
AUD.y = cat(2,AUD.yL,AUD.yR);  
AUD.plot_data = [AUD.x; AUD.y]'; 
AUD.plot_data = AUD.plot_data(~isnan(AUD.plot_data(:,2)),:); 


VIS.xR = VIS_prob_Right(:,1)'; 
VIS.xL = flip(-1*(VIS_prob_Left(:,1)))'; %-1 to get on other side of x axis
VIS.x = cat(2,VIS.xL,VIS.xR); 
VIS.yL = flip(VIS_prob_Left(:,2))';
VIS.yR = VIS_prob_Right(:,2)';
VIS.y = cat(2,VIS.yL,VIS.yR);  
VIS.plot_data = [VIS.x; VIS.y]'; 
VIS.plot_data = VIS.plot_data(~isnan(VIS.plot_data(:,2)),:); 



[fig, AUD_mu, VIS_mu, AUD_std_cumulative_gaussian, VIS_std_cumulative_gaussian, Results_MLE] = createFit_NormCDF_AandV(AUD.plot_data(:,1), AUD.plot_data(:,2)/100,...
                                         VIS.plot_data(:,1), VIS.plot_data(:,2)/100,audInfo, dotInfo,save_name);

% [fig,  AUD_p_values, VIS_p_values,...
%        AV_aud_p_values, AV_vis_p_values,...
%        AUD_threshold, VIS_threshold, AV_threshold,AUD_std, VIS_std, AV_std] = ...
%                         createFit_NormCDF_modalities(AUD.plot_data(:,1), AUD.plot_data(:,2)/100,...
%                                          VIS.plot_data(:,1), VIS.plot_data(:,2)/100,...
%                                          AV_aud.plot_data(:,1), AV_aud.plot_data(:,2)/100,...
%                                          AV_vis.plot_data(:,1), AV_vis.plot_data(:,2)/100,...
%                                          audInfo, dotInfo, AVInfo, chosen_threshold,save_name); 
% 


end

