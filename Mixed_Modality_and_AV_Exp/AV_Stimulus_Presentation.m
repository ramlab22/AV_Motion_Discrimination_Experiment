function [av_timeout] = AV_Stimulus_Presentation(ExpInfo, dotInfo, AVInfo, curWindow, xCenter, yCenter, h_voltage, k_voltage, TDT)
% dotInfo will be a struct with all of the information concerning the RDK stimulus
%look at CreateClassStructure.m function 


Screen('Flip', curWindow);
ifi = Screen('GetFlipInterval', curWindow);
refresh_rate = 1/ifi; 


    % Seed the random number generator
    rseed = sum(100*clock);
    rng(rseed,'v5uniform');
        

    coh = AVInfo.coh_dot;
    if AVInfo.dir == 1 %Rightward AV 
        dot_direction = 0; % Rightward Dot Direction
    elseif AVInfo.dir == 0 %Leftward AV
        dot_direction = 180; %Leftward Dot Direction;
    end

    apD = dotInfo.apXYD(:,3); % diameter of aperture
    center = repmat([xCenter yCenter],size(dotInfo.apXYD(:,1)));

    center = [center(:,1) + dotInfo.apXYD(:,1)/10*(ExpInfo.ppd) center(:,2) - ...
    dotInfo.apXYD(:,2)/10*ExpInfo.ppd]; % where you want the center of the aperture

    center(:,3) = dotInfo.apXYD(:,3)/2/10*ExpInfo.ppd; % add diameter
    d_ppd = floor(apD/10 * ExpInfo.ppd);	% size of aperture in pixels
    dotSize = dotInfo.dotSize; 
    % AJT: Number of dots per video frame was 16.7, but since we are updating
    % every frame instead of every 3 frames, we can multiply this number by
    % 3, giving us 50
    %ndots = min(dotInfo.maxDotsPerFrame,ceil(16.7 * apD .* apD * 0.01 / refresh_rate));
    ndots = min(dotInfo.maxDotsPerFrame,ceil(50 * apD .* apD * 0.01 / refresh_rate));
   
        
% Don't worry about pre-allocating, the number of dot fields should never be 
% large enough to cause memory problems.
for df = 1 : dotInfo.numDotField
    % dxdy is an N x 2 matrix that gives jumpsize in units on 0..1
    %   deg/sec * ap-unit/deg * sec/jump = ap-unit/jump
    
    % AJT: dxdy gives us a unit amount for each jump for a given single dot (signal 
    % dots will all be the same jumpsize). We need to change 3/refresh_rate to
    % 1/refresh_rate to update dot positions every frame and maintain the same
    % speed. If this wasn't changed while we made the dots one group instead of 3,
    % dots would move 3 times as fast.
%     dxdy{df} = repmat((dotInfo.speed(df)/10) * (10/apD(df)) * ...
%         (3/refresh_rate) * [cos(pi*dotInfo.dir(df)/180.0), ...
%         -sin(pi*dotInfo.dir(df)/180.0)], ndots(df),1);    
     dxdy{df} = repmat((dotInfo.speed(df)/10) * (10/apD(df)) * ...
         (1/refresh_rate) * [cos(pi*dot_direction(df)/180.0), ...
         -sin(pi*dot_direction(df)/180.0)], ndots(df),1);    

    ss{df} = rand(ndots(df)*3, 2); % array of dot positions raw [x,y]
%     % Divide dots into three sets
%     Ls{df} = cumsum(ones(ndots(df),3)) + repmat([0 ndots(df) ndots(df)*2], ... 
%         ndots(df), 1);
%     loopi(df) = 1; % loops through the three sets of dots
% AJT: Divide dots into three sets before, now just make a column of all
% dots. Originally, the dots were divided into three groups in order to not
% skip frames. Code was optimized for older machines that couldn't plot
% dots fast enough. Now that dots are one group, there will be smoother
% motion, and hence better motion perception (i.e. signal dot X travels
% from point a, to b, c, then d in 3 frames instead of signal dot X just 
% moving from point a to d in 3 frames. 
    Ls{df} = cumsum(ones(ndots(df),1));

end

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
r = round(ExpInfo.fixpoint_size_pix/2); 


% How dots are presented: 1st group of dots are shown in the first frame, a 2nd 
% group are shown in the second frame, a 3rd group shown in the third frame.
% Then in the next (4th) frame, some percentage of the dots from the 1st frame 
% are replotted according to the speed/direction and coherence. Similarly, the 
% same is done for the 2nd group, etc.
  %Turn on fixation point Initially
        Screen('FillOval',curWindow,dotInfo.dotColor,[(xCenter-r) (yCenter-r) (xCenter+r) (yCenter+r)]);

        Screen('DrawingFinished',curWindow,dontclear);
        
TDT.trg(2); %Triggers the Start of the Auditory Stimulus

while continue_show
            x = TDT.read('x');
            y = TDT.read('y');
            d = sqrt(((x-h_voltage).^2)+((y-k_voltage).^2));
            if d > ExpInfo.rew_radius_volts
                %Timeout for Failure to fixate on fixation
                Screen('FillRect', curWindow, [0 0 0]);
                Screen('Flip', curWindow);
                av_timeout = 1;
                TDT.write('aud_off',1); %Turn off Audio 
                break
            else
                av_timeout = 0; 
            end

    for df = 1 : dotInfo.numDotField
        % ss is the matrix with 3 sets of dot positions, dots from the last 2 
        %   positions and current dot positions
        % Ls picks out the set (e.g., with 5 dots on the screen at a time, 1:5, 
        %   6:10, or 11:15)
        
        % Lthis has the dot positions from 3 frames ago, which is what is then
      %  Lthis{df}  = Ls{df}(:,loopi(df));
        
        % Moved in the current loop. This is a matrix of random numbers - starting 
        % positions of dots not moving coherently.
        
            % AJT: In previous version, loopi variable used to track which group of
    % dots out of the three were updated for a given frame. All code that
    % pertained to loopi was deleted in this version. Lthis variable was
    % also used to keep track of the specific dots in group 1, 2, or 3. All
    % Lthis variables used in previous versions were replaced with Ls,
    % which is the ndots by 1 matrix that has all dots in one group, as we
    % do NOT need to update only a third of the dots, so Lthis is unneeded.

        this_s{df} = ss{df}(Ls{df},:);
        
%         % Update the loop pointer
%         loopi(df) = loopi(df)+1;
%         
%         if loopi(df) == 4
%             loopi(df) = 1;
%         end
%         
        % Compute new locations, how many dots move coherently
        L = rand(ndots(df),1) < coh(df);
        % Offset the selected dots
        this_s{df}(L,:) = bsxfun(@plus,this_s{df}(L,:),dxdy{df}(L,:));
    %    this_s{df}(L,:) = this_s{df}(L,:) + dxdy{df}(L,:);
        if sum(~L) > 0
            this_s{df}(~L,:) = rand(sum(~L),2);	% get new random locations for the rest
        end
        
        % Check to see if any positions are greater than 1 or less than 0 which 
        % is out of the square aperture, and replace with a dot along one of the
        % edges opposite from the direction of motion.
        N = sum((this_s{df} > 1 | this_s{df} < 0)')' ~= 0;
        
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
  
        
        % Convert for plot
        this_x{df} = floor(d_ppd(df) * this_s{df});	% pix/ApUnit
        
        % It assumes that 0 is at the top left, but we want it to be in the
        % center, so shift the dots up and left, which means adding half of the
        % aperture size to both the x and y directions.
        dot_show{df} = (this_x{df} - d_ppd(df)/2)';
    end
    
    % After all computations, flip to draws dots from the previous loop. For the
    % first time, this doesn't draw anything.
    Screen('Flip', curWindow,0,dontclear);

  
    
    % Now do the actual drawing commands, although nothing is drawn until next        
    for df = 1:dotInfo.numDotField
        % NaN out-of-circle dots                
        xyDis = dot_show{df};
        outCircle = sqrt(xyDis(1,:).^2 + xyDis(2,:).^2) + dotInfo.dotSize/2 > center(df,3);        
        dots2Display = dot_show{df};
        dots2Display(:,outCircle) = NaN;
        
        Screen('DrawDots',curWindow,dots2Display,dotSize,dotInfo.dotColor,center(df,1:2));
    end
    
        Screen('FillOval',curWindow,dotInfo.dotColor,[(xCenter-r) (yCenter-r) (xCenter+r) (yCenter+r)]);
        Screen('DrawingFinished',curWindow,dontclear);
 

    
    frames = frames + 1;
    
    if frames == 1     
        start_time = GetSecs;       
    end
       
    for df = 1 : dotInfo.numDotField
        % Update the dot position array for the next loop
        % AJT: Updating ALL dot position array for the next frame, since they
        % are replotted every frame
        ss{df} = this_s{df};
    end
    
    % Check for the end of loop
    continue_show = continue_show - 1;



end

% Present the last frame of dots
Screen('Flip',curWindow,0,dontclear);

    
end_time = GetSecs; 
end