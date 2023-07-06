coherence = 1; %values from 0-1
%coherence = 0.5; 
aperture_diameter = 15; %degrees visual angle, given monWidth = 40cm and Viewing Distance from monitor = 53cm
velocity = 20; %degrees per second
motion_direction = 45; %0=right, 180=left, 90=up, 270=down
maxdotsperframe = 50; % by trial and error.  Depends on graphics card
%maxdotsperframe = 400; 
%stim_duration = 0.834; %in seconds
stim_duration = 1; %in seconds  %GCD: shortened to reduce # frames
n_trials = 5;
iti = 1.2 ;%in seconds

load('variables_for_greg_testing.mat');
dotInfo.apXYD = [0 90 aperture_diameter*10];
dotInfo.speed = velocity*10;
dotInfo.dir = motion_direction;
dotInfo.maxDotsPerFrame = maxdotsperframe;
dotInfo.maxDotTime = stim_duration;
  %(dont ask me why we have 3 separate coherence variables in the structure,i have no idea just havent gotten around to fixing)
dotInfo.coherences = coherence;
dotInfo.cohSet = coherence;
dotInfo.coh = coherence;
iti_time_frames = round(iti/ifi); 

%ifi = Screen('GetFlipInterval', curWindow);
%refresh_rate = 1/ifi; 


    % Seed the random number generator
    rseed = sum(100*clock);
    rng(rseed,'v5uniform');
        

    coh = dotInfo.coh;
    apD = dotInfo.apXYD(:,3); % diameter of aperture
    center = repmat([xCenter yCenter],size(dotInfo.apXYD(:,1)));

    center = [center(:,1) + dotInfo.apXYD(:,1)/10*(ExpInfo.ppd) center(:,2) - ...
    dotInfo.apXYD(:,2)/10*ExpInfo.ppd]; % where you want the center of the aperture

    center(:,3) = dotInfo.apXYD(:,3)/2/10*ExpInfo.ppd; % add diameter
    d_ppd = floor(apD/10 * ExpInfo.ppd);	% size of aperture in pixels
    dotSize = dotInfo.dotSize; 
    
    ndots = min(dotInfo.maxDotsPerFrame,ceil(16.7 * apD .* apD * 0.01 / refresh_rate));
    
        
% Don't worry about pre-allocating, the number of dot fields should never be 
% large enough to cause memory problems.
for df = 1 : dotInfo.numDotField
    % dxdy is an N x 2 matrix that gives jumpsize in units on 0..1
    %   deg/sec * ap-unit/deg * sec/jump = ap-unit/jump
    dxdy{df} = repmat((dotInfo.speed(df)/10) * (10/apD(df)) * ...
        (3/refresh_rate) * [cos(pi*dotInfo.dir(df)/180.0), ...
        -sin(pi*dotInfo.dir(df)/180.0)], ndots(df),1);    
    ss{df} = rand(ndots(df)*3, 2); % array of dot positions raw [x,y]
    % Divide dots into three sets
    Ls{df} = cumsum(ones(ndots(df),3)) + repmat([0 ndots(df) ndots(df)*2], ... 
        ndots(df), 1);
    loopi(df) = 1; % loops through the three sets of dots
end

%figure;
%plot(ss{1}(:,1),ss{1}(:,2), 'k.');
%GCD: note, the dots look random here

% Loop length is determined by the field "dotInfo.maxDotTime". If none is given, 
% loop until "continue_show=0" is set by other means (eg. user response), 
% otherwise loop until dotInfo.maxDotTime. Always one video frame per loop.

if ~isfield(dotInfo,'maxDotTime') || (isempty(dotInfo.maxDotTime) && ndots>0)
    continue_show = -1;
elseif ndots > 0
    continue_show = round(dotInfo.maxDotTime*refresh_rate);
else
    continue_show = 0;
end

dontclear = 0; % 0 for clear drawing, 1 for incremental drawing (does not clear buffer after flip)

% The main loop
frames = 0;
figure;
figure('visible', 'off')
r = round(ExpInfo.fixpoint_size_pix/2); 


% How dots are presented: 1st group of dots are shown in the first frame, a 2nd 
% group are shown in the second frame, a 3rd group shown in the third frame.
% Then in the next (4th) frame, some percentage of the dots from the 1st frame 
% are replotted according to the speed/direction and coherence. Similarly, the 
% same is done for the 2nd group, etc.
  %Turn on fixation point Initially
%  Screen('FillOval',curWindow,fix_point_color,[(xCenter-r) (yCenter-r) (xCenter+r) (yCenter+r)]);

%        Screen('DrawingFinished',curWindow,dontclear);

while continue_show
            x = nan(1,1);
            y = nan(1,1);
       
            d = sqrt(((x-h_voltage).^2)+((y-k_voltage).^2));
            if d > ExpInfo.rew_radius_volts
                %Timeout for Failure to fixate on fixation
%                Screen('FillRect', curWindow, [0 0 0]);
%                Screen('Flip', curWindow);
                rdk_timeout = 1;
                break
            else
                rdk_timeout = 0; 
            end

    for df = 1 : dotInfo.numDotField
        % ss is the matrix with 3 sets of dot positions, dots from the last 2 
        %   positions and current dot positions
        % Ls picks out the set (e.g., with 5 dots on the screen at a time, 1:5, 
        %   6:10, or 11:15)
        
        % Lthis has the dot positions from 3 frames ago, which is what is then
        Lthis{df}  = Ls{df}(:,loopi(df));
        
        % Moved in the current loop. This is a matrix of random numbers - starting 
        % positions of dots not moving coherently.
        this_s{df} = ss{df}(Lthis{df},:);

        %hold on; plot(this_s{1}(:,1),this_s{1}(:,2), 'r.');
        %GCD: note, the red dots still look random here

        % Update the loop pointer
        loopi(df) = loopi(df)+1;
        
        if loopi(df) == 4
            loopi(df) = 1;
        end
        
        % Compute new locations, how many dots move coherently
        L = rand(ndots(df),1) < coh(df);
        % Offset the selected dots
        this_s{df}(L,:) = bsxfun(@plus,this_s{df}(L,:),dxdy{df}(L,:));
    %    this_s{df}(L,:) = this_s{df}(L,:) + dxdy{df}(L,:);
    
        %hold on; plot(this_s{1}(:,1),this_s{1}(:,2), 'g.');
        %GCD: note, the green dots look shifted appropriately relative to
        %the red ones
    
        if sum(~L) > 0
            this_s{df}(~L,:) = rand(sum(~L),2);	% get new random locations for the rest
        end
        
        % Check to see if any positions are greater than 1 or less than 0 which 
        % is out of the square aperture, and replace with a dot along one of the
        % edges opposite from the direction of motion.
        N = sum((this_s{df} > 1 | this_s{df} < 0)')' ~= 0;
        
        % This code for dot wrapping does not work.  It creates vertical stripes of dots
        % and also did not work for oblique directions, Greg DeAngelis, 6/23/23 
%         if sum(N) > 0
%             xdir = sin(pi*dotInfo.dir(df)/180.0);
%             ydir = cos(pi*dotInfo.dir(df)/180.0);
%             % Flip a weighted coin to see which edge to put the replaced dots
%             if rand < abs(xdir)/(abs(xdir) + abs(ydir))
%                 this_s{df}(find(N==1),:) = [rand(sum(N),1),(xdir > 0)*ones(sum(N),1)];
%             else
%                 this_s{df}(find(N==1),:) = [(ydir < 0)*ones(sum(N),1),rand(sum(N),1)];
%             end
%         end

        % NEW code for dot wrapping, Greg DeAngelis, 6/23/23 
        if sum(N) > 0
             dots_outside = this_s{df}(find(N==1),:);
             dots_outside(dots_outside(:,1) > 1,1) = dots_outside(dots_outside(:,1) > 1,1) - 1; %if horizontal location >1, subtract 1
             dots_outside(dots_outside(:,1) < 0,1) = dots_outside(dots_outside(:,1) < 0,1) + 1; %if horizontal location <0, add 1
             dots_outside(dots_outside(:,2) > 1,2) = dots_outside(dots_outside(:,2) > 1,2) - 1; %if vertical location >1, subtract 1
             dots_outside(dots_outside(:,2) < 0,2) = dots_outside(dots_outside(:,2) < 0,2) + 1; %if vertical location <0, add 1
             this_s{df}(find(N==1),:) = dots_outside;
         end
        
        %hold on; plot(this_s{1}(:,1),this_s{1}(:,2), 'b.');
        %GCD: note, still think it looks OK here
        
        % Convert for plot
        this_x{df} = floor(d_ppd(df) * this_s{df});	% pix/ApUnit

        %figure; plot(this_x{1}(:,1),this_x{1}(:,2), 'b.');
        %GCD: note, don't see a problem here yet
        
        % It assumes that 0 is at the top left, but we want it to be in the 
        % center, so shift the dots up and left, which means adding half of the 
        % aperture size to both the x and y directions.
        dot_show{df} = (this_x{df} - d_ppd(df)/2)';
    end
    
    % After all computations, flip to draws dots from the previous loop. For the
    % first time, this doesn't draw anything.
%    Screen('Flip', curWindow,0,dontclear);

  
    
    % Now do the actual drawing commands, although nothing is drawn until next        
    for df = 1:dotInfo.numDotField
        % NaN out-of-circle dots                
        xyDis = dot_show{df};
        outCircle = sqrt(xyDis(1,:).^2 + xyDis(2,:).^2) + dotInfo.dotSize/2 > center(df,3);        
        dots2Display = dot_show{df};
        dots2Display(:,outCircle) = NaN;
        
%        Screen('DrawDots',curWindow,dots2Display,dotSize,dotInfo.dotColor,center(df,1:2));
    end
    
%        Screen('FillOval',curWindow,fix_point_color,[(xCenter-r) (yCenter-r) (xCenter+r) (yCenter+r)]);
 %       Screen('DrawingFinished',curWindow,dontclear);
 

    
    frames = frames + 1;
    
    if frames == 1     
        start_time = GetSecs;       
    end
       
    for df = 1 : dotInfo.numDotField
        % Update the dot position array for the next loop
        ss{df}(Lthis{df}, :) = this_s{df};
    end

    %figure;
    plot(ss{1}(:,1),ss{1}(:,2), 'm.');
    xlim([0, 1]);
    M(:,frames) = getframe;
    %GCD: note, the dots look random here

    % Check for the end of loop
    continue_show = continue_show - 1;

end

% Present the last frame of dots
%Screen('Flip',curWindow,0,dontclear);

figure;
movie(M,3,60);
    
end_time = GetSecs; 
