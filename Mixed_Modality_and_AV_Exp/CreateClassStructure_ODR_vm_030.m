function  [ClassStructure, p, alpha, AllList]= CreateClassStructure_ODR_vm_030(d, nsample, thetahat, kappa, w) %,Nclass,StartAngle,angleStep)
% clear
if nargin < 4
    w=[0.5 0.5];
end
if nargin < 3
    kappa = [1.4 1.4];
end
if nargin < 2
    thetahat = [0 pi];
end
if nargin < 1 || isempty(nsample)
    nsample= 90;
end

nClass =0;
alpha = linspace(0, 2*pi, nsample+1)';% how many degree per class
alpha = alpha(1:end-1);
[p, alpha] = circ_vmpdf_030(alpha, thetahat, kappa,w);
maxTrial = max(500,length(alpha)*5);
AllP =round(p/sum(p)*length(alpha)*round(maxTrial/length(alpha)));
AllList=[];
for StartAngle = alpha'
    angle = StartAngle;
    nClass = nClass +1;
    ClassStructure(nClass).frame(1).stim.end = [d*cos(angle) d*sin(angle)];
    ClassStructure(nClass).frame(1).stim.feature =6;
    ClassStructure(nClass).frame(2).stim.end = [d*cos(angle) d*sin(angle)];
    ClassStructure(nClass).frame(2).stim.feature =6;
    ClassStructure(nClass).Notes =[num2str(angle*180/pi) ];    
    AllList =[AllList ones(1,AllP(nClass))*nClass];
end
% save(['C:\Matlab2009a\work\Data_Analysis\APM_Data\Scripts\ODRdist\classODR8stim'],'ClassStructure');
% clear ClassStructure;