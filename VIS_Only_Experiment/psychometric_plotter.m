function [x, y, fitresult, gof] = psychometric_plotter(prob_Right, prob_Left, prob_zero)
%PYSCHOMETRIC_PLOTTER Summary of this function goes here
%  Must take 1-prob_Left to get the probability of a rightward choice, the
%  input probabilities are in regards to the corrrect choice(i.e. in that
%  direction)

xR = prob_Right(2:end,1)'; 
xL = flip(-1*(prob_Left(2:end,1)))'; %-1 to get on other side of x axis
x = cat(2,xL,xR); 
yL = flip(prob_Left(2:end,2))';
yR = prob_Right(2:end,2)';
y = cat(2,yL,yR);  

plot_data = [x; y]'; 
plot_data(end+1,:) = prob_zero(:,1:2); 
plot_data = plot_data(~isnan(plot_data(:,2)),:); 

[fitresult, gof] = createFit_Weibull(plot_data(:,1)+10, plot_data(:,2)/100); 
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

