function [cohFreq_dir] = cohFreq_finder(dataout, audInfo)
    
    columnIndex = 5; %Catch Trial Column
    filterCondition = @(x) strcmp(x, 'No'); %Filter to only regular Trials, ie Catch Trial = 'No' 
    filteredArray = {};
     
    for i = 1:size(dataout, 1)
        if filterCondition(dataout{i, columnIndex})
            filteredArray = [filteredArray; dataout(i,:)];
        end
    end

    if length(filteredArray(:,1)) > 1 && length(unique(cell2mat(filteredArray(1:end,8)))) > 1
        if  strcmp(filteredArray(1,1), 'Trial #')
            [cnt, uniq] = hist(cell2mat(filteredArray(2:end,8)), unique(cell2mat(filteredArray(2:end,8))));
        else
            [cnt, uniq] = hist(cell2mat(filteredArray(1:end,8)), unique(cell2mat(filteredArray(1:end,8))));
        end
    
        ii = [uniq';cnt];
    else
        ii = [unique(cell2mat(filteredArray(1:end,8)));
                1];
    end
    
    cohFreq_dir = [audInfo.coherences;
                                zeros(1,length(audInfo.coherences))];
    for i = 1:length(audInfo.coherences)
        for j = 1:length(ii(1,:))
            if ii(1,j) == cohFreq_dir(1,i)
                cohFreq_dir(2,i) = ii(2,j);
                break
            else
                cohFreq_dir(2,i) = 0;
            end
        end
    end
    
end
  