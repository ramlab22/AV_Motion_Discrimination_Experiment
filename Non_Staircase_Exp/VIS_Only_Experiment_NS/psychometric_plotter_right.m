function [] = psychometric_plotter_right(prob,coherence_rew_numbers)
%PYSCHOMETRIC_PLOTTER Summary of this function goes here
%  Input : prob(2,:) = List of percetages at each coherence
figure(1)
clf
plot(coherence_rew_numbers(1,:),prob(2,:),'o-','MarkerFaceColor','b');
set(gca,'XLim',[0 1]); 
set(gca,'YLim',[0,100]);
xlabel('Coherence');
ylabel('Percent Correct');


end

