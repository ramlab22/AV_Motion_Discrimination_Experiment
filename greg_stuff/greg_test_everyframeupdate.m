%% RDK Every Frame Update  
%% ADAM J. TIESMAN (AJT) -- 6/28/23
% Changed RDK stimulus code to update dot positions every frame instead of
% 3 groups updated every 3 frames. Dot field brace indexing removed in this
% version, as it is unneeded for our code- we are only presenting one RDK
% field at a time.

% Stimulus variables
coherence = 1; %values from 0-1
aperture_diameter = 15; %degrees visual angle, given monWidth = 40cm and Viewing Distance from monitor = 53cm
velocity = 20; %degrees per second
motion_direction = 0; %0=right, 180=left, 90=up, 270=down
maxdotsperframe = 50; % by trial and error.  Depends on graphics card
stim_duration = 1; %in seconds  %GCD: shortened to reduce # frames
n_trials = 5;
iti = 1.2 ;%in seconds

% RDK Dot variables
load('variables_for_greg_testing.mat');
dotInfo.apXYD = [0 90 aperture_diameter*10];
dotInfo.speed = velocity*10;
dotInfo.dir = motion_direction;
dotInfo.maxDotsPerFrame = maxdotsperframe;
dotInfo.maxDotTime = stim_duration;
  %(dont ask me why we have 3 separate coherence variables in the structure,i have no idea just havent gotten around to fixing)
dotInfo.coherences = coherence;
dotInfo.cohSet = coherence; % Adam Tiesman - this is the list of all possible generated coherences in our staircase, in descending order
dotInfo.coh = coherence; % Adam Tiesman - this is the coherence for a given trial
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
    
    % AJT: Number of dots per video frame was 16.7, but since we are updating
    % every frame instead of every 3 frames, we can multiply this number by
    % 3, giving us 50
    ndots = min(dotInfo.maxDotsPerFrame,ceil(50 * apD .* apD * 0.01 / refresh_rate));
    
        
% Don't worry about pre-allocating, the number of dot fields should never be 
% large enough to cause memory problems.
% dxdy is an N x 2 matrix that gives jumpsize in units on 0..1
%   deg/sec * ap-unit/deg * sec/jump = ap-unit/jump

% AJT: dxdy gives us a unit amount for each jump for a given single dot (signal 
% dots will all be the same jumpsize). We need to change 3/refresh_rate to
% 1/refresh_rate to update dot positions every frame and maintain the same
% speed. If this wasn't changed while we made the dots one group instead of 3,
% dots would move 3 times as fast.
dxdy = repmat((dotInfo.speed/10) * (10/apD) * ...
    (1/refresh_rate) * [cos(pi*dotInfo.dir/180.0), ...
    -sin(pi*dotInfo.dir/180.0)], ndots,1);    
ss = rand(ndots*3, 2); % array of dot positions raw [x,y]

% AJT: Divide dots into three sets before, now just make a column of all
% dots. Originally, the dots were divided into three groups in order to not
% skip frames. Code was optimized for older machines that couldn't plot
% dots fast enough. Now that dots are one group, there will be smoother
% motion, and hence better motion perception (i.e. signal dot X travels
% from point a, to b, c, then d in 3 frames instead of signal dot X just 
% moving from point a to d in 3 frames. 
Ls = cumsum(ones(ndots,1));

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
% AJT: Now, this code does not do the above operation- instead ALL dots are
% plotted every frame
  %Turn on fixation point Initially
%  Screen('FillOval',curWindow,fix_point_color,[(xCenter-r) (yCenter-r) (xCenter+r) (yCenter+r)]);

%        Screen('DrawingFinished',curWindow,dontclear);

while continue_show
            x = nan(1,1);
            y = nan(1,1);
       
            d = sqrt(((x-h_voltage).^2)+((y-k_voltage).^2));
%             if d > ExpInfo.rew_radius_volts
%                 %Timeout for Failure to fixate on fixation
% %                Screen('FillRect', curWindow, [0 0 0]);
% %                Screen('Flip', curWindow);
%                 rdk_timeout = 1;
%                 break
%             else
%                 rdk_timeout = 0; 
%             end

    % ss is the matrix with 3 sets of dot positions, dots from the last 2 
    %   positions and current dot positions
    % Ls picks out the set (e.g., with 5 dots on the screen at a time, 1:5, 
    %   6:10, or 11:15)
    
    % Moved in the current loop. This is a matrix of random numbers - starting 
    % positions of dots not moving coherently.
    
    % AJT: In previous version, loopi variable used to track which group of
    % dots out of the three were updated for a given frame. All code that
    % pertained to loopi was deleted in this version. Lthis variable was
    % also used to keep track of the specific dots in group 1, 2, or 3. All
    % Lthis variables used in previous versions were replaced with Ls,
    % which is the ndots by 1 matrix that has all dots in one group, as we
    % do NOT need to update only a third of the dots, so Lthis is unneeded.
    this_s = ss(Ls,:);

    %hold on; plot(this_s{1}(:,1),this_s{1}(:,2), 'r.');
    %GCD: note, the red dots still look random here

    
    % Compute new locations, how many dots move coherently
    L = rand(ndots,1) < coh;
    % Offset the selected dots
    this_s(L,:) = bsxfun(@plus,this_s(L,:),dxdy(L,:));
%    this_s{df}(L,:) = this_s{df}(L,:) + dxdy{df}(L,:);

    %hold on; plot(this_s{1}(:,1),this_s{1}(:,2), 'g.');
    %GCD: note, the green dots look shifted appropriately relative to
    %the red ones

    if sum(~L) > 0
        this_s(~L,:) = rand(sum(~L),2);	% get new random locations for the rest
    end
    
    % Check to see if any positions are greater than 1 or less than 0 which 
    % is out of the square aperture, and replace with a dot along one of the
    % edges opposite from the direction of motion.
    N = sum((this_s > 1 | this_s < 0)')' ~= 0;
    
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
         dots_outside = this_s(find(N==1),:);
         dots_outside(dots_outside(:,1) > 1,1) = dots_outside(dots_outside(:,1) > 1,1) - 1; %if horizontal location >1, subtract 1
         dots_outside(dots_outside(:,1) < 0,1) = dots_outside(dots_outside(:,1) < 0,1) + 1; %if horizontal location <0, add 1
         dots_outside(dots_outside(:,2) > 1,2) = dots_outside(dots_outside(:,2) > 1,2) - 1; %if vertical location >1, subtract 1
         dots_outside(dots_outside(:,2) < 0,2) = dots_outside(dots_outside(:,2) < 0,2) + 1; %if vertical location <0, add 1
         this_s(find(N==1),:) = dots_outside;
     end
    
    %hold on; plot(this_s{1}(:,1),this_s{1}(:,2), 'b.');
    %GCD: note, still think it looks OK here
    
    % Convert for plot
    this_x = floor(d_ppd * this_s);	% pix/ApUnit

    %figure; plot(this_x{1}(:,1),this_x{1}(:,2), 'b.');
    %GCD: note, don't see a problem here yet
    
    % It assumes that 0 is at the top left, but we want it to be in the 
    % center, so shift the dots up and left, which means adding half of the 
    % aperture size to both the x and y directions.
    dot_show = (this_x - d_ppd/2)';
    
    % After all computations, flip to draws dots from the previous loop. For the
    % first time, this doesn't draw anything.
%    Screen('Flip', curWindow,0,dontclear);

  
    
    % Now do the actual drawing commands, although nothing is drawn until
    % next
    % NaN out-of-circle dots                
    xyDis = dot_show;
    outCircle = sqrt(xyDis(1,:).^2 + xyDis(2,:).^2) + dotInfo.dotSize/2 > center(1,3);        
    dots2Display = dot_show;
    dots2Display(:,outCircle) = NaN;
        
%        Screen('DrawDots',curWindow,dots2Display,dotSize,dotInfo.dotColor,center(df,1:2));
    
%        Screen('FillOval',curWindow,fix_point_color,[(xCenter-r) (yCenter-r) (xCenter+r) (yCenter+r)]);
 %       Screen('DrawingFinished',curWindow,dontclear);
 

    
    frames = frames + 1;
    
    if frames == 1     
        start_time = GetSecs;       
    end
       
    % Update the dot position array for the next loop
    % AJT: Updating ALL dot position array for the next frame, since they
    % are replotted every frame
    ss = this_s;
    
    %figure;
    % AJT: It appears as though a group of dots are moving and a group of
    % dots are stationary. Is this code somewhere plotting the initial
    % positions of the dots and leaving them on the figure? Need to look
    % into this to see if it is an issue with the every frame update I just
    % made... 
    % AJT: UPDATE!!! Changing ss(Ls, :) = this_s to ss = this_ss seems to
    % have solved this issue
    plot(ss(:,1),ss(:,2), 'm.');
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
