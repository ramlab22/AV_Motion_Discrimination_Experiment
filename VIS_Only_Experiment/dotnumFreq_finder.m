function [dotnumFreq_dir] = dotnumFreq_finder(dir_dataout, modalityInfo)
    
    columnIndex = 5; %Catch Trial Column
    filterCondition = @(x) strcmp(x, 'No'); %Filter to only regular Trials, ie Catch Trial = 'No' 
    filteredArray = {};
    for i = 2:size(dir_dataout, 1)
        if filterCondition(dir_dataout{i, columnIndex})
            filteredArray = [filteredArray; dir_dataout(i,:)];
        end
    end

    if  strcmp(filteredArray(1,1), 'Trial #')
        [cnt, uniq] = hist(cell2mat(filteredArray(2:end,8)), unique(cell2mat(filteredArray(2:end,8))));
    else
        [cnt, uniq] = hist(cell2mat(filteredArray(1:end,8)), unique(cell2mat(filteredArray(1:end,8))));
    end
    
    ii = [uniq';cnt];

    dotnumFreq_dir = [modalityInfo.dotnumSet;
                                zeros(1,length(modalityInfo.dotnumSet))];
    for i = 1:length(modalityInfo.dotnumSet)
        for j = 1:length(ii)
            if ii(1,j) == dotnumFreq_dir(1,i)
                dotnumFreq_dir(2,i) = ii(2,j);
                break
            else
                dotnumFreq_dir(2,i) = 0;
            end
        end
    end
    
end
  