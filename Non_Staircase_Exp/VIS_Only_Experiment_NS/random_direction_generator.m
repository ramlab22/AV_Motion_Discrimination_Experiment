dotInfo.dirSet = [180 0];   
dotInfo.random_dir_list = zeros(1,20);
   

    numberOfElements = 20; 
    per_R = 50; % the percentage of Right Targets, 50% will make an even number of L and R trials
    numberOfOnes = round(numberOfElements * per_R / 100); 
    % Make initial signal with proper number of 0's and 1's.
    signal = [ones(1, numberOfOnes), zeros(1, numberOfElements - numberOfOnes)];
    % Scramble them up with randperm
    signal = signal(randperm(length(signal)));
    
    for i = 1:20
      r_index = signal(i);
      if signal(i) == 0
          dotInfo.random_dir_list(i) = dotInfo.dirSet(r_index+1);
      elseif signal(i) == 1
          dotInfo.random_dir_list(i) = dotInfo.dirSet(r_index+1);
      end
    end