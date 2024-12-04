function [av_timeout] = AV_Stimulus_Presentation(ExpInfo, dotInfo, AVInfo, curWindow, xCenter, yCenter, h_voltage, k_voltage, TDT,k_pix)
% dotInfo will be a struct with all of the information concerning the RDK stimulus
%look at CreateClassStructure.m function 
%xCenter=640;
%yCenter=347;
%yCenter=445;
%dotInfo.apXYD = [0 55 220];
%AVInfo.apXYD = [0 55 220];

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

    %center = [center(:,1) + dotInfo.apXYD(:,1)/10*(ExpInfo.ppd) center(:,2) -dotInfo.apXYD(:,2)/10*ExpInfo.ppd]; % where you want the center of the aperture
    center = [center(:,1) + dotInfo.apXYD(:,1)/10*(ExpInfo.ppd) center(:,2)]; % where you want the center of the aperture

    center(:,3) = dotInfo.apXYD(:,3)/2/10*ExpInfo.ppd; % add diameter
    d_ppd = floor(apD/10 * ExpInfo.ppd);	% size of aperture in pixels
    dotSize = dotInfo.dotSize; 
    
    %ndots = min(dotInfo.maxDotsPerFrame,ceil(16.7 * apD .* apD * 0.01 / refresh_rate));
    ndots = min(dotInfo.maxDotsPerFrame,ceil(50 * apD .* apD * 0.01 / refresh_rate));
   
        
% Don't worry about pre-allocating, the number of dot fields should never be 
% large enough to cause memory problems.
for df = 1 : dotInfo.numDotField
    % dxdy is an N x 2 matrix that gives jumpsize in units on 0..1
    %   deg/sec * ap-unit/deg * sec/jump = ap-unit/jump
    
   
     dxdy{df} = repmat((dotInfo.speed(df)/10) * (10/apD(df)) * ...
         (1/refresh_rate) * [cos(pi*dot_direction(df)/180.0), ...
         -sin(pi*dot_direction(df)/180.0)], ndots(df),1);    

    ss{df} = rand(ndots(df)*3, 2); % array of dot positions raw [x,y]
%     % Divide dots into three sets
%     Ls{df} = cumsum(ones(ndots(df),3)) + repmat([0 ndots(df) ndots(df)*2], ... 
%         ndots(df), 1);
%     loopi(df) = 1; % loops through the three sets of dots
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



  %Turn on fixation point Initially
        Screen('FillOval',curWindow,dotInfo.dotColor,[(xCenter-r) (k_pix-r) (xCenter+r) (k_pix+r)]);

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
      
        % Moved in the current loop. This is a matrix of random numbers - starting 
        % positions of dots not moving coherently.
        
          

        this_s{df} = ss{df}(Ls{df},:);
        
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
    
        Screen('FillOval',curWindow,dotInfo.dotColor,[(xCenter-r) (k_pix-r) (xCenter+r) (k_pix+r)]);
        Screen('DrawingFinished',curWindow,dontclear);
 

    
    frames = frames + 1;
    
    if frames == 1     
        start_time = GetSecs;       
    end
       
    for df = 1 : dotInfo.numDotField
        % Update the dot position array for the next loop
    
        ss{df} = this_s{df};
    end
    
    % Check for the end of loop
    continue_show = continue_show - 1;



end

% Present the last frame of dots
Screen('Flip',curWindow,0,dontclear);

    
end_time = GetSecs; 
end