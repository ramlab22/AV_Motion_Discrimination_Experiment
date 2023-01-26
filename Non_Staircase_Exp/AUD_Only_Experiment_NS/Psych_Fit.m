

%%
% [x, y] = psychometric_plotter(prob_Right,prob_Left);
% 
% PC = rmmissing(y)/100; 
% coh_list =  x(find(~isnan(y))); 
% This is Alv_072822_4 and Alv_072822_5 Combined % correct for each
% coherence in VIS modality 

%For AUD i used Baron 072622_4 and_5

coh_list = [0
0.05
0.1
0.15
0.2
0.25
0.35
0.4
0.5
0.6
0.8
1];
% -0.5
% -0.1
% -0.15
% -0.2
% -0.25
% -0.35
% -0.4
% -0.5
% -0.6
% -0.8
% -1]; 

pc_vis = [33
46
57
59
62
56
58
62
64
63
85
82
% 54
% 43
% 56
% 38
% 50
% 42
% 38
% 36
% 37
% 15
% 18
]/100; 

pc_aud = [
31
38
41
40
57
55
63
61
62
72
85
95
%     67
%     48
%     59
%     43
%     50
%     22
%     32
%     27
%     34
%     15
%      5
]/100; 
figure(1)
scatter(coh_list,pc_aud)
hold on
plot(AUD_Weibull(:,1),AUD_Weibull(:,2))

figure(2)
scatter(coh_list,pc_vis)
hold on 
plot(VIS_Weibull(:,1),VIS_Weibull(:,2))
% 
% [curve,params] = createFitERFv2(coh_list,pc/100);

% param = wblfit(pc./100);
% alpha = param(1);
% gamma = param(2);
% 
% w_cdf = 1 - exp(-((coh_list+10)/alpha).^gamma);
% 
% figure(2)
% plot((coh_list+10),w_cdf)
% xlim([9 11])
% ylim([0 1])