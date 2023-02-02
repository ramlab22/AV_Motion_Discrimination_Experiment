function [random_dir_list] = randomizer(ExpInfo,dotInfo)
%RANDOMIZER - Takes the Directions randomly
%places them in different trial positions based on regular coherence
%locations and catch trial(1 coherence) locations

    %Make a list of random directions with and equal amount of each
    %direction from dotInfo.dir_set, Currently only works for L and R
    %directions, need to adapt for U and D directions

    %We also want to take into acoount the coherence level thats being played,
    %we want an even number of L and R trials for each coherence category
    random_dir_list = zeros(1,ExpInfo.num_trials);
    %Direction Randomizer
    for c = dotInfo.coherences 

        if length(dotInfo.dirSet) > 1 %If we have more than 1 direction to choose from

            numberOfElements = sum(dotInfo.cohSet == c); %Sums all of the same coherences from the random list cohSet
            per_R = 50; % the percentage of Right Targets, 50% will make an even number of L and R trials
            numberOfOnes = round(numberOfElements * per_R / 100);
            % Make initial signal with proper number of 0's and 1's.
            signal = [ones(1, numberOfOnes), zeros(1, numberOfElements - numberOfOnes)];
            % Scramble them up with randperm
            signal = signal(randperm(length(signal)));%For Direction
            indeces = find(dotInfo.cohSet == c); 
            
            for i = 1:numberOfElements
                if signal(i) == 0
                     random_dir_list(indeces(i)) = dotInfo.dirSet(1); %Left wherever that coherence appears 
                elseif signal(i) == 1
                    random_dir_list(indeces(i)) = dotInfo.dirSet(2); %Right wherever that coherence appears 
                end

            end
        else
            random_dir_list(:) = dotInfo.dirSet;
        end
    end
   
end

