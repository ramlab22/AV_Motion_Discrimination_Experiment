function [cohFreq_dir] = cohFreq_finder_vis(dir_dataout, dotInfo)
    if  strcmp(dir_dataout(1,1), 'Trial #')
        [cnt, uniq] = hist(cell2mat(dir_dataout(2:end,11)), unique(cell2mat(dir_dataout(2:end,11))));
    else
        [cnt, uniq] = hist(cell2mat(dir_dataout(1:end,11)), unique(cell2mat(dir_dataout(1:end,11))));
    end
    
    ii = [uniq';cnt];

    cohFreq_dir = [dotInfo.coherences;
                                zeros(1,length(dotInfo.coherences))];
    for i = 1:length(dotInfo.coherences)
        for j = 1:length(ii)
            if ii(1,j) == cohFreq_dir(1,i)
                cohFreq_dir(2,i) = ii(2,j);
                break
            else
                cohFreq_dir(2,i) = 0;
            end
        end
    end
    
end
  