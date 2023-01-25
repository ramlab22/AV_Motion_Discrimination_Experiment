%
% drawDotsTest
%
% Example of showing how dots look without mask, using DrawDots (not using
% CLUT). This code is completely independent of other dots code and only need 
% psychtoolbox to run it.
%

% MKMK July 2006

% Beware (not converted for REX, in decimal format if should be)

clear;

try
    AssertOpenGL;
    duration = 5; % how long to show the dots in seconds

    curScreen = 1;
    dontclear = 0;

    [curWindow, screenRect] = Screen('OpenWindow', curScreen, [0,0,0],[],32, 2);
    
    % Enable alpha blending with proper blend-function. We need it for drawing 
    % of smoothed points.
    Screen('BlendFunction', curWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    center = [screenRect(3), screenRect(4)]/2; 
    
    Screen('Flip',curWindow,0,dontclear);    

    spf =Screen('GetFlipInterval', curWindow); % seconds per frame
    monRefresh = 1/spf; % frames per second

    mon_horizontal_cm  	= 38;
    view_dist_cm 		= 50;
    
    % MAKE SURE APD IS USED CORRECTLY EVERYWHERE!!!!
    % diameter/length of side of aperture
    apD = 50;
    
    % Everything is initially in coordinates of visual degrees, convert to pixels
    % (pix/screen) * (screen/rad) * rad/deg
    ppd = pi * screenRect(3) / atan(mon_horizontal_cm/view_dist_cm/2)  / 360;

    d_ppd = floor(apD/10 * ppd);
    
    % Dot stuff    
    coh = 0.512;
    speed = 5;
    direction = 0;    
    dotSize = 2;

    maxDotsPerFrame = 150; % By trial and error and depends on graphics card

    % ndots is the number of dots shown per video frame. Dots are placed in a 
    % square of the size of the aperture.    
    %   Size of aperture = Apd*Apd/100  sq deg
    %   Number of dots per video frame = 16.7 dots per sq.deg/sec,
    % When rounding up, do not exceed the number of dots that can be plotted in 
    % a video frame.
    ndots = min(maxDotsPerFrame, ceil(16.7 * apD .* apD * 0.01 / monRefresh));
    
    % dxdy is an N x 2 matrix that gives jumpsize in units on 0..1
    %   deg/sec * Ap-unit/deg * sec/jump = unit/jump
    dxdy = repmat(speed * 10/apD * (3/monRefresh) ...
        * [cos(pi*direction/180.0) -sin(pi*direction/180.0)], ndots,1);

    % ARRAYS, INDICES for loop
    ss = rand(ndots*3, 2); % array of dot positions raw [xposition, yposition]    

    % Divide dots into three sets
    Ls = cumsum(ones(ndots,3)) + repmat([0 ndots ndots*2], ndots, 1);
    loopi = 1; % Loops through the three sets of dots

    % Show for how many frames
    continue_show = round(duration*monRefresh);    
    
    priorityLevel = MaxPriority(curWindow,'KbCheck');
    Priority(priorityLevel);
    
    % THE MAIN LOOP
    frames = 0;

    while continue_show
        % Get ss & xs from the big matrices. xs and ss are matrices that have 
        % stuff for dots from the last 2 positions + current.
        % Ls picks out the previous set (1:5, 6:10, or 11:15)
        Lthis  = Ls(:,loopi); % Lthis picks out the loop from 3 times ago, which 
                              % is what is then moved in the current loop
        this_s = ss(Lthis,:);  % this is a matrix of random #s - starting positions
        
        % 1 group of dots are shown in the first frame, a second group are shown 
        % in the second frame, a third group shown in the third frame. Then in 
        % the next frame, some percentage of the dots from the first frame are 
        % replotted according to the speed/direction and coherence, the next 
        % frame the same is done for the second group, etc.
        
        % Update the loop pointer
        loopi = loopi+1;
        
        if loopi == 4
            loopi = 1;
        end
        
        % Compute new locations
        % L are the dots that will be moved
        L = rand(ndots,1) < coh;                
        this_s(L,:) = this_s(L,:) + dxdy(L,:);	% Offset the selected dots
                
        if sum(~L) > 0  % if not 100% coherence
            this_s(~L,:) = rand(sum(~L),2);	% get new random locations for the rest                        
        end

        % Wrap around - check to see if any positions are greater than one or 
        % less than zero which is out of the aperture, and then replace with a 
        % dot along one of the edges opposite from direction of motion.
        
        N = sum((this_s > 1 | this_s < 0)')' ~= 0;
        if sum(N) > 0
            xdir = sin(pi*direction/180.0);
            ydir = cos(pi*direction/180.0);
            % Flip a weighted coin to see which edge to put the replaced dots
            if rand < abs(xdir)/(abs(xdir) + abs(ydir))              
                this_s(find(N==1),:) = [rand(sum(N),1) (xdir > 0)*ones(sum(N),1)];
            else
                this_s(find(N==1),:) = [(ydir < 0)*ones(sum(N),1) rand(sum(N),1)];
            end
        end
        
        % Convert to stuff we can actually plot
        this_x(:,1:2) = floor(d_ppd(1) * this_s); % pix/ApUnit

        % This assumes that zero is at the top left, but we want it to be in the 
        % center, so shift the dots up and left, which just means adding half of 
        % the aperture size to both the x and y direction.
        dot_show = (this_x(:,1:2) - d_ppd/2)';

        % After all computations, flip
        Screen('Flip', curWindow,0,dontclear);
        % Now do next drawing commands
        
        Screen('DrawDots', curWindow, dot_show, dotSize, [255 255 255], center);
        Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], center, 1);

        % Presentation
        Screen('DrawingFinished',curWindow,dontclear);
        
        frames = frames + 1;

        if frames == 1
            start_time = GetSecs;       
        end

        % Update the arrays so xor works next time
        xs(Lthis, :) = this_x;
        ss(Lthis, :) = this_s;

        % Check for end of loop
        continue_show = continue_show - 1;

    end
    
    % Present last dots
    Screen('Flip', curWindow,0,dontclear);

    % Erase last dots
    Screen('DrawingFinished',curWindow,dontclear);
    Screen('Flip', curWindow,0,dontclear);

    Screen('CloseAll'); % Close display windows
    Priority(0); % Shutdown realtime mode.    
    ShowCursor; % Show cursor again, if it has been disabled.
    
catch
    disp('caught')
    Screen('CloseAll'); % Close display windows
    Priority(0); % Shutdown realtime mode.
    StartUpdateProcess;
    ShowCursor; % Show cursor again, if it has been disabled.
end

