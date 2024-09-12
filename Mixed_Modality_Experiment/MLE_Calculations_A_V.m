function [Results_MLE] = MLE_Calculations_A_V(AUD_mdl, VIS_mdl,AUD_yData,VIS_yData, AUD_xData,VIS_xData,all_sizes_AUD,all_sizes_VIS)
% get residuals of all models
AUD_fittedValues = feval(AUD_mdl, AUD_xData);
AUD_residuals = AUD_yData - AUD_fittedValues;
VIS_fittedValues = feval(VIS_mdl, VIS_xData);
VIS_residuals = VIS_yData - VIS_fittedValues;
%AV_fittedValues = feval(AV_mdl, AV_xData);
%AV_residuals = AV_yData - AV_fittedValues;

%get measured AUD and VIS parameters
Results_MLE.AUD_R2 = 1-sum(AUD_residuals.^2)/sum((AUD_yData-mean(AUD_yData)).^2); % R2 = 1 – SSresid / SStotal
Results_MLE.AUD_Mu = AUD_mdl.Coefficients{1, 1};
Results_MLE.AUD_SD = AUD_mdl.Coefficients{2, 1};
Results_MLE.AUD_Variance = Results_MLE.AUD_SD^2;

Results_MLE.VIS_R2 = 1-sum(VIS_residuals.^2)/sum((VIS_yData-mean(VIS_yData)).^2); % R2 = 1 – SSresid / SStotal
Results_MLE.VIS_Mu = VIS_mdl.Coefficients{1, 1};
Results_MLE.VIS_SD = VIS_mdl.Coefficients{2, 1};
Results_MLE.VIS_Variance = Results_MLE.VIS_SD^2;

% %get measured AV function parameters
% Results_MLE.AV_R2 = 1-sum(AV_residuals.^2)/sum((AV_yData-mean(AV_yData)).^2); % R2 = 1 – SSresid / SStotal
% Results_MLE.AV_Mu = AV_mdl.Coefficients{1, 1};
% Results_MLE.AV_SD = AV_mdl.Coefficients{2, 1};
% Results_MLE.AV_Variance = Results_MLE.AV_SD^2;

%Get MLE results
Results_MLE.AUD_Westimate= (1/Results_MLE.AUD_Variance)/((1/Results_MLE.AUD_Variance)+(1/Results_MLE.VIS_Variance));
Results_MLE.VIS_Westimate= (1/Results_MLE.VIS_Variance)/((1/Results_MLE.VIS_Variance)+(1/Results_MLE.AUD_Variance));
Results_MLE.AV_EstimatedVariance=(Results_MLE.AUD_Variance*Results_MLE.VIS_Variance)/(Results_MLE.AUD_Variance+Results_MLE.VIS_Variance);

Results_MLE.AV_EstimatedSD=sqrt(Results_MLE.AV_EstimatedVariance);
Results_MLE.AUD_xData=AUD_xData;
Results_MLE.AUD_yData=AUD_yData;
Results_MLE.AUD_sizes=all_sizes_AUD;

Results_MLE.VIS_xData=VIS_xData;
Results_MLE.VIS_yData=VIS_yData;
Results_MLE.VIS_sizes=all_sizes_VIS;

