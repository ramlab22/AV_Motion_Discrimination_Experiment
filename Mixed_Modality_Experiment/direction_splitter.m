function [Right_dataout, Left_dataout] = direction_splitter(dataout, modality)
% %DIRECTION_SPLITTER 

% Split the data out cell array into Left Only and Right Only trials
% Will be used for psychometric function calculations 

% dir_list = num2cell(dotInfo.random_dir_list);
% dir_list = dir_list';
% dataout(2:end,9) = dir_list;
if strcmp(modality, 'AUD')
    direction_list = dataout(2:end,9); 
    mat = cell2mat(direction_list); 
    R_test = (mat == 1) ;
    L_test = (mat == 0); 
    R_indeces = find(R_test == 1); 
    L_indeces = find(L_test == 1);
    Right_dataout = dataout(R_indeces+1,:); 
    Left_dataout = dataout(L_indeces+1,:); 
elseif strcmp(modality, 'VIS')
    direction_list = dataout(2:end,9); 
    mat = cell2mat(direction_list); 
    R_test = (mat == 0) ;
    L_test = (mat == 180); 
    R_indeces = find(R_test == 1); 
    L_indeces = find(L_test == 1);
    Right_dataout = dataout(R_indeces+1,:); 
    Left_dataout = dataout(L_indeces+1,:); 
end

end

