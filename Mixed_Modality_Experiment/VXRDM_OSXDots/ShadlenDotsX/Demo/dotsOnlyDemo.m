% dotsOnlyDemo
%
% Simple script for testing dots (dotsX)
%

try
    clear;
    
    % Initialize the screen
    % touchscreen is 34, laptop is 32, viewsonic is 38
    screenInfo = openExperiment(34,50, 1);
        
    % Initialize dots
    % Check createMinDotInfo to change parameters
    dotInfo = createDotInfo(1);

    [frames, rseed, start_time, end_time, response, response_time] = ...
        dotsX(screenInfo, dotInfo);    
    pause(0.5)

    % Clear the screen and exit
    closeExperiment;
    
catch
    disp('caught error');
    lasterr;
    closeExperiment;
    
end


