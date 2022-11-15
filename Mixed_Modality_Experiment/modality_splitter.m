function [AUD_dataout, VIS_dataout] = modality_splitter(dataout)
    modality_list = dataout(2:end,11); 
    mat = cell2mat(modality_list); 
    AUD_test = (strcmp(mat, 'AUD')) ;
    VIS_test = (strcmp(mat, 'VIS')); 
    AUD_indeces = find(AUD_test == 1); 
    VIS_indeces = find(VIS_test == 1);
    AUD_dataout = dataout(AUD_indeces+1,:); 
    VIS_dataout = dataout(VIS_indeces+1,:); 
    
end