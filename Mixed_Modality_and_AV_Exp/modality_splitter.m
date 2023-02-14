function [AUD_dataout, VIS_dataout, AV_dataout] = modality_splitter(dataout)
    modality_list = dataout(2:end,11); 

AUD_indeces =[];
VIS_indeces =[];
AV_indeces =[];
    for i = 1:length(modality_list)
        if (strcmp(modality_list(i), 'AUD')) 
            AUD_indeces(end+1) = i; 
        elseif (strcmp(modality_list(i), 'VIS'))
            VIS_indeces(end+1) = i;
        elseif (strcmp(modality_list(i), 'AV'))
            AV_indeces(end+1) = i;
        end
    end

    AUD_dataout = dataout(AUD_indeces+1,:); 
    VIS_dataout = dataout(VIS_indeces+1,:); 
    AV_dataout = dataout(AV_indeces+1,:);

    
end