function [cohSet] = cohSet_maker(audInfo)
%Makes as many coherence values needed for amount of regular trials
cohSet = cell2mat(arrayfun(@(x,y) repmat(y, 1, x), audInfo.cohFreq, audInfo.coherences, 'UniformOutput', false));


cohSet = cohSet(randperm(length(cohSet))); %Randomly Scatter the coherence valuesfor regular trials
%Now we insert the catch trials to the cohSet list so we have all the
%trials in one array, both regular and catch 
for k = 1:length(audInfo.random_incorrect_opacity_list)% 0 = Catch Trial, Insert a 1 coherence to cohSet at that index
   if  audInfo.random_incorrect_opacity_list(k) == 0 && k > 1 && k < length(audInfo.random_incorrect_opacity_list)
       cohSet = [cohSet(1:k-1) 1 cohSet(k:end)]; %Inserts a 1 at index k without deleting previous values
   elseif audInfo.random_incorrect_opacity_list(k) == 0 && k == 1
       cohSet = [1 cohSet(1:end)];
   elseif audInfo.random_incorrect_opacity_list(k) == 0 && k == length(audInfo.random_incorrect_opacity_list)
       cohSet = [cohSet(1:end) 1];
   end
    
end
end