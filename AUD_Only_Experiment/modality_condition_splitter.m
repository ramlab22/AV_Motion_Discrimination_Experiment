function [AUD_dataout, VIS_dataout,AV_dataout] = modality_condition_splitter(dataout)
%splits dataout input by modality condition when conditions can be A,V,or AV
modality_list = dataout(2:end,11);
%     mat = cell2mat(modality_list);
AUD_indeces =[];
VIS_indeces =[];
AV_indeces = [];
for i_trial = 1:length(modality_list)
    switch modality_list{i_trial}
        case 'AUD'
            AUD_indeces(end+1) = i_trial;
        case 'VIS'
            VIS_indeces(end+1) = i_trial;
        case 'AV'
            AV_indeces(end+1) = i_trial;
    end
end
%     AUD_indeces = find(AUD_test == 1);
%     VIS_indeces = find(VIS_test == 1);
AUD_dataout = dataout(AUD_indeces+1,:);
VIS_dataout = dataout(VIS_indeces+1,:);
AV_dataout = dataout(AV_indeces+1,:);

end