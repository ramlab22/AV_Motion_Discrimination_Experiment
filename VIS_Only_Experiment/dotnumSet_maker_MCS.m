function [dotnumSet] = dotnumSet_maker_MCS(dotInfo)
    %Makes as many dot number values needed for amount of regular trials
    dotnumSet = cell2mat(arrayfun(@(x,y) repmat(y, 1, x), dotInfo.dotnum_Freq_Set, dotInfo.dotnumSet, 'UniformOutput', false));

    dotnumSet = dotnumSet(randperm(length(dotnumSet))); %Randomly Scatter the coherence valuesfor regular trials
   
    
    end
