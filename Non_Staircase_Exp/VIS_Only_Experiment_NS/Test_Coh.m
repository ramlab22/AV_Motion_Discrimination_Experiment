cohSet = []; 

for i = 1:length(cohFreq)
    for j = 1:cohFreq(i)
        if i == 1
            cohSet(end+1) = 0.0;
        elseif i == 2
            cohSet(end+1) = 0.2;
        elseif i == 3
            cohSet(end+1) = 0.4;
        elseif i == 4
            cohSet(end+1) = 0.6;
        elseif i == 5
            cohSet(end+1) = 0.8;
        elseif i == 6
            cohSet(end+1) = 1.0;
            
        end
    end
end

cohSet = cohSet(randperm(length(cohSet))); %Randomly Scatter the coherence values