function [cohSet] = cohSet_maker_MCS(audInfo)
%Makes as many coherence values needed for amount of regular trials
% cohSet = []; 
% 
% for i = 1:length(audInfo.cohSet)
%     for j = 1:audInfo.coh_Freq_Set(i)   
%               cohSet(end+1) = audInfo.coherences(i);
%     end
% end
cohSet = cell2mat(arrayfun(@(x,y) repmat(y, 1, x), audInfo.coh_Freq_Set, audInfo.coherences, 'UniformOutput', false));

cohSet = cohSet(randperm(length(cohSet))); %Randomly Scatter the coherence valuesfor regular trials

end