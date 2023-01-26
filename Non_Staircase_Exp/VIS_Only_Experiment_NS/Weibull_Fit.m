

%%
[x, y] = psychometric_plotter(prob_Right,prob_Left);

PC = rmmissing(y)/100; 
coh_list =  x(find(~isnan(y))); 

[curve,params] = createFitERFv2(coh_list,PC)

% param = wblfit(PC);
% alpha = param(1);
% gamma = param(2);
% 
% w_cdf = 1 - exp(-(x./alpha).^gamma);

% figure(2)
% plot(x,w_cdf)
% xlim([-1 1])
% ylim([0 1])