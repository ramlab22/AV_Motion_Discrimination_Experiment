% Demo1
%
% Sample script for demonstrating how to show targets & dots
%

% Copyright 2014 Shadlen Lab
addpath('Z:\Jackson\Adriana Stuff\VXRDM_OSXDots\ShadlenDotsX');
 
try
    clear;
    
    % Initialize the screen. This will create a screen in monitor 1. In order to
    % create in monitor 0, replace 1 with 0 in the following line of code.
    screenInfo = openExperiment(38,50,2);        
    
    targets = setNumTargets(6); % initialize targets        
    dotInfo = createDotInfo; % initialize dots   

    targets = newTargets(screenInfo,targets,[1,2,3],[0,-50,-200],[0,-50,130],...
        [5,10,10],[0,255,255; 0,255,0; 255,0,0]);
    showTargets(screenInfo,targets,[1,2,3]);
    pause(0.5);
    
    targets = newTargets(screenInfo,targets,[4,5,6],[0,0,10],[50,-50,-50],...
        [10,10,10],[255,255,0; 0,0,255; 255,0,255]);    
    showTargets(screenInfo,targets,[1,2,3,4,5,6]);
    pause(0.5);
    
    disp('change color');
    targets = newTargets(screenInfo,targets,[1,3,5],[],[],[],...
        [255,255,0; 0,0,255; 255,0,255]);
    showTargets(screenInfo,targets,[1,2,3,4,5,6]);
    pause(0.5);
    
    disp('change diameter');
    targets = newTargets(screenInfo,targets,[2,4,6],[],[],[20,20,20],[]);    
    showTargets(screenInfo,targets,[1,2,3,4,5,6]);
    pause(0.5);
    
    disp('change position');
    targets = newTargets(screenInfo,targets,[2,4,6],[],[0,-15,15],[],[]);    
    showTargets(screenInfo,targets,[1,2,3,4,5,6]);
    pause(0.5);
    
    showTargets(screenInfo,targets,[1,2,5]);
    pause(0.5);      
    
    targets.show = [1,2,5];
    [frames,rseed,start_time,end_time,response,response_time] = ...
        dotsX(screenInfo,dotInfo,targets);
    
    showTargets(screenInfo,targets,[1,2,3]);
    pause(1);
    
    closeExperiment; % clear the screen and exit

catch
    disp('caught error');
    lasterr
    closeExperiment;
end



