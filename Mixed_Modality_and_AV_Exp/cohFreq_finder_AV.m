function [cohFreq_dir_aud, cohFreq_dir_vis] = cohFreq_finder_AV(AV_dataout, AVInfo)
    
    AV_dataout(strcmp(AV_dataout(:,6),'N/A'),:)=[]; %delete rows where subject quit before target presented
    AV_dataout(all(cellfun(@isempty, AV_dataout),2),:) = [];%delete empty rows from data cell

    columnIndex = 5; %Catch Trial Column
    filterCondition = @(x) strcmp(x, 'No'); %Filter to only regular Trials, ie Catch Trial = 'No' 
    filteredArray = {};
    for i = 1:size(AV_dataout, 1)
        if filterCondition(AV_dataout{i, columnIndex})
            filteredArray = [filteredArray; AV_dataout(i,:)];
        end
    end
    AV_coherence_list = cell2mat(filteredArray(:,8));
    %For - AV_coherence_list AUD Coh is 1st Column , VIS Coh is 2nd Column
    % First do this for AUD coherences
    if length(filteredArray(:,1)) > 1 && length(unique(AV_coherence_list(1:end,1))) > 1
        if  strcmp(filteredArray(1,1), 'Trial #')
            AV_coherence_list = cell2mat(filteredArray(2:end,8));
            [cnt_aud, uniq_aud] = hist(AV_coherence_list(2:end,1), unique(AV_coherence_list(2:end,1)));
        else
            AV_coherence_list = cell2mat(filteredArray(:,8));
            [cnt_aud, uniq_aud] = hist(AV_coherence_list(1:end,1), unique(AV_coherence_list(1:end,1)));
        end

        ii_aud = [uniq_aud';cnt_aud];
    else
        AV_coherence_list = cell2mat(filteredArray(:,8));
        ii_aud = [unique(AV_coherence_list(1:end,1));
                1];
    end
    
    cohFreq_dir_aud = [AVInfo.cohSet_aud;
                                zeros(1,length(AVInfo.cohSet_aud))];
    for i = 1:length(AVInfo.cohSet_dot)
        for j = 1:length(ii_aud(1,:))
            if ii_aud(1,j) == cohFreq_dir_aud(1,i)
                cohFreq_dir_aud(2,i) = ii_aud(2,j);
                break
            else
                cohFreq_dir_aud(2,i) = 0;
            end
        end
    end
    
    %Then do it for VIS Coherences, column 2 of AV_coherence list
    if length(filteredArray(:,1)) > 1 && length(unique(AV_coherence_list(1:end,2))) > 1
        if  strcmp(filteredArray(1,1), 'Trial #')
            AV_coherence_list = cell2mat(filteredArray(2:end,8));
            [cnt_vis, uniq_vis] = hist(AV_coherence_list(2:end,2), unique(AV_coherence_list(2:end,2)));
        else
            AV_coherence_list = cell2mat(filteredArray(:,8));
            [cnt_vis, uniq_vis] = hist(AV_coherence_list(1:end,2), unique(AV_coherence_list(1:end,2)));
        end

        ii_vis = [uniq_vis';cnt_vis];
    else
        AV_coherence_list = cell2mat(filteredArray(:,8));
        ii_vis = [ unique(AV_coherence_list(1:end,2));
                1];
    end
    cohFreq_dir_vis = [AVInfo.cohSet_dot;
                                zeros(1,length(AVInfo.cohSet_dot))];
    for i = 1:length(AVInfo.cohSet_dot)
        for j = 1:length(ii_vis(1,:))
            if ii_vis(1,j) == cohFreq_dir_vis(1,i)
                cohFreq_dir_vis(2,i) = ii_vis(2,j);
                break
            else
                cohFreq_dir_vis(2,i) = 0;
            end
        end
    end
    
    
end
  