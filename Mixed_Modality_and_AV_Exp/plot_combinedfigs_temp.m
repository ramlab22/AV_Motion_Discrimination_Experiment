folderPath='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/Ba_audonly_26velocity/'
modality='aud_only';
[xData_matrix, yData_matrix, x_matrix, p_matrix, fileNames] = extractdata_for_comboplot(folderPath,modality);
plot_combodata(xData_matrix, yData_matrix, x_matrix, p_matrix, fileNames)