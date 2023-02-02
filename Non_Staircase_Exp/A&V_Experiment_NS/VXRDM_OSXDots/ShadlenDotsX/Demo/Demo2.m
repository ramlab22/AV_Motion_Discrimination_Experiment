% Demo2
%
% Demonstrates how to use makeDotTargets to set targets in a place a certain 
% distance from either the fixation or the aperture and in the direction of the 
% possible motions. This was created mostly to test moving the dots in relation 
% to the targets/fixation.
%

try
    clear;
    
    % Initialize the screen
    % touchscreen is 34, laptop is 32, viewsonic is 38
    screenInfo = openExperiment(34,50,2);
    
    % Initialize dots
    % 1 means using keyboard, not touchscreen
    dotInfo = createDotInfo(1);
                    
    % Creates targets according to dots directions - this capability has now been
    % incorporated into makeDotTargets. 1 to set manually, 2 to use fixation as 
    % center point, 3 to use aperture as center. Here use fixation as center.        
    dotInfo.auto(1)
    
    if dotInfo.auto(1) == 1
        xpos = dotInfo.tarXY(:,1);
        ypos = dotInfo.tarXY(:,2);
    else
        if dotInfo.auto(1) == 2
            xpos = [dotInfo.fixXY(:,1); dotInfo.tarXY(:,1)];
            ypos = [dotInfo.fixXY(:,2); dotInfo.tarXY(:,2)];
        elseif dotInfo.auto(1) == 3
            xpos = [dotInfo.apXYD(:,1); dotInfo.tarXY(:,1)];
            ypos = [dotInfo.apXYD(:,2); dotInfo.tarXY(:,2)];
        end
        [xpos, ypos] = targetPosits(xpos, ypos, dotInfo.dirSet);
    end
    
    % Add fixation to targets
    xpos = [dotInfo.fixXY(:,1); xpos]';
    ypos = [dotInfo.fixXY(:,2); ypos]';
    diam = [dotInfo.fixDiam dotInfo.tarDiam];
    tarColors = repmat(dotInfo.tarColor,size(dotInfo.tarDiam,2),1);
    colors = [dotInfo.fixColor; tarColors];
    
    % Initialize targets
    targets = setNumTargets(length(xpos));              
    targets = newTargets(screenInfo, targets, 1:length(xpos), xpos, ypos, diam,...
        colors);                
    showTargets(screenInfo, targets, 1:length(xpos));            
                   
    % Show the fixation                
    [frames, rseed, start_time, end_time, response, response_time] = ...
        dotsX(screenInfo, dotInfo, targets);        
    pause(0.5)

    % Clear the screen and exit
    closeExperiment;
    
catch
    disp('caught error');
    lasterr
    closeExperiment;
    
end


