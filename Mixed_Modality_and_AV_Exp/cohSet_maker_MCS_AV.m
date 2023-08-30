function [cohSet_aud,cohSet_vis] = cohSet_maker_MCS_AV(AVInfo)
%Makes as many coherence values needed for amount of regular trials
cohSet_vis = cell2mat(arrayfun(@(x,y) repmat(y, 1, x), AVInfo.coh_Freq_Set, AVInfo.coherences_dot, 'UniformOutput', false));
cohSet_aud = cell2mat(arrayfun(@(x,y) repmat(y, 1, x), AVInfo.coh_Freq_Set, AVInfo.coherences_aud, 'UniformOutput', false));
% Randomly rearrange the order of elements in both cohSet_vis and cohSet_aud
% ensuring the same random order is applied to both arrays.
randOrder = randperm(length(cohSet_vis));
cohSet_vis = cohSet_vis(randOrder);
cohSet_aud = cohSet_aud(randOrder);

% %Now we insert the catch trials to the cohSet_aud list so we have all the
% %trials in one array, both regular and catch 
% for k = 1:length(AVInfo.random_incorrect_opacity_list)% 0 = Catch Trial, Insert a 1 coherence to cohSet_aud at that index
%    if  AVInfo.random_incorrect_opacity_list(k) == 0 && k > 1 && k < length(AVInfo.random_incorrect_opacity_list)
%        cohSet_aud = [cohSet_aud(1:k-1) 1 cohSet_aud(k:end)]; %Inserts a 1 at index k without deleting previous values
%    elseif AVInfo.random_incorrect_opacity_list(k) == 0 && k == 1
%        cohSet_aud = [1 cohSet_aud(1:end)];
%    elseif AVInfo.random_incorrect_opacity_list(k) == 0 && k == length(AVInfo.random_incorrect_opacity_list)
%        cohSet_aud = [cohSet_aud(1:end) 1];
%    end
% 
% end
% 
% %Now we insert the catch trials to the cohSet_vis list so we have all the
% %trials in one array, both regular and catch 
% for k = 1:length(AVInfo.random_incorrect_opacity_list)% 0 = Catch Trial, Insert a 1 coherence to cohSet_vis at that index
%    if  AVInfo.random_incorrect_opacity_list(k) == 0 && k > 1 && k < length(AVInfo.random_incorrect_opacity_list)
%        cohSet_vis = [cohSet_vis(1:k-1) 1 cohSet_vis(k:end)]; %Inserts a 1 at index k without deleting previous values
%    elseif AVInfo.random_incorrect_opacity_list(k) == 0 && k == 1
%        cohSet_vis = [1 cohSet_vis(1:end)];
%    elseif AVInfo.random_incorrect_opacity_list(k) == 0 && k == length(AVInfo.random_incorrect_opacity_list)
%        cohSet_vis = [cohSet_vis(1:end) 1];
%    end
% 
% end

end