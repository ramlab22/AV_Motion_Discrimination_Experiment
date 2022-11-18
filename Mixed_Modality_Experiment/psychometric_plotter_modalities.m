[fig_both_AUD_VIS] = psychometric_plotter_modalities(AUD_prob_Right, AUD_prob_Left, VIS_prob_Right, VIS_prob_Left);
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
AUD.plot_data = [x; y]'; 
AUD.plot_data = AUD.plot_data(~isnan(AUD.plot_data(:,2)),:); 


VIS.xR = AUD_prob_Right(:,1)'; 
VIS.xL = flip(-1*(AUD_prob_Left(:,1)))'; %-1 to get on other side of x axis
VIS.x = cat(2,VIS.xL,VIS.xR); 
VIS.yL = flip(AUD_prob_Left(:,2))';
VIS.yR = AUD_prob_Right(:,2)';
VIS.y = cat(2,VIS.yL,VIS.yR);  
VIS.plot_data = [x; y]'; 
VIS.plot_data = VIS.plot_data(~isnan(VIS.plot_data(:,2)),:); 

[fig] = createFit_NormCDF_modalities(AUD.plot_data(:,1), AUD.plot_data(:,2)/100, VIS.plot_data(:,1), VIS.plot_data(:,2)/100); 




end
