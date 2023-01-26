function [frames, rseed, start_time, end_time, response, response_time] = dotsXnomask(screenInfo, dotInfo, targets)
%
%
% created by RK 01/17/06
% adapted to OSX by MKMK 6/06
%
% arguments - minimum fields for dotInfo and screenInfo
%   most everything is in visual degrees * 10, since rex only likes integers 
%
%       dotInfo.numDotField     number of dot patches that will be shown on the screen
%		dotInfo.coh             vertical vectors, dots coherence (0...999) for each dot patch
%		dotInfo.speed           vertical vectors, dots speed (10th deg/sec) for each dot patch
%		dotInfo.dir             vertical vectors, dots direction (degrees) for each dot patch
%       dotInfo.dotSize         size of dots in visual degrees, same for all patches
%       dotInfo.dotColor        color of dots in rgb, same for all patches
%       dotInfo.maxDotsPerFrame determined by testing video card
%       dotInfo.apXYD           x, y coordinates, and diameter of aperture(s) in visual degrees          
%		dotInfo.maxDotTime      optional, can set maximum duration (sec). dot	presentation can be terminated by user response
%       dotInfo.trialtype       1 fixed duration, 2 reaction time
%       dotInfo.keys            a set of keyboard buttons that can terminate the presentation of dots
%       dotInfo.mouse           a set of mouse buttons that can terminate the presentation of dots
%
%       screenInfo.curWindow    window on which to plot dots
%       screenInfo.center       center of the screen in pixels
%       screenInfo.ppd          pixels per visual degree
%       screenInfo.monRefresh   monitor refresh value
%       screenInfo.dontclear    If set to 1, flip will not clear the framebuffer after Flip - this allows incremental 
%                               drawing of stimuli. Needs to be zero for dots to be erased.
%		screenInfo.rseed        random # seed, can be empty set[] 
%
%
% algorithm:
%		All calculations take place within a square aperture
% in which the dots are shown. The dots are constructed in 3 sets
% that are plotted in sequence.  For each set, the probability that
% a dot is replotted in motion -- as opposed to randomly replaced --
% is given by the dotInfo.coh value.  This routine generates a set of
% dots as an ndots_ by 2 matrix of locations, and sends this to DOTS for
% plotting is DrawMethod is set to MEX or to a Matlab loop in RUSH mode of
% psychtoolbox if DrawMethod is set to RUSH.  In plotting the next set of
% dots (e.g., set 2) it prepends the preceding set (e.g., set 1).
% Since DOTS writes in XOR mode, replotting the old set erases it to its
% previous value, whether that be background or fixation point, etc.
%
% created by MKMK July 2006, based on ShadlenDots by MNS, JIG and others

% structures are not altered in this function, so should not have memory
% problems from matlab creating new structures...
mfilename

if nargin < 3
    targets.x = [];
end
curWindow = screenInfo.curWindow;
dotColor = dotInfo.dotColor;
rseed = screenInfo.rseed;

waitpress = 0; % 1 means wait for a mouse press, 0 means wait for release

if isfield(dotInfo, 'keys')
    keys = dotInfo.keys;
else
    keys = [];
end
if isfield(dotInfo, 'mouse')
    mouse = dotInfo.mouse;
else
    mouse = [];
end

start_time = NaN;
end_time= NaN;
response = {NaN, NaN};
response_time = NaN;

% SEED THE RANDOM NUMBER GENERATOR ... if "[]" is given, reset
% the seed "randomly"... this is for VAR/NOVAR conditions
if ~isempty(rseed) && length(rseed) == 1
    rand('state', rseed);
elseif ~isempty(rseed) && length(rseed) == 2
    rand('state', rseed(1)*rseed(2));
else
    rseed = sum(100*clock);
    rand('state', rseed);
end

% USEFUL LOCAL VARS
% variables that are sent to rex have been multiplied by a factor of 10 to
% make sure they are integers. Now we have to convert them back so that
% they are correct for plotting.
coh   	= dotInfo.coh/1000;	%  % dotInfo.coh is specified on 0... (because
% of rex needing integers), but we want 0..1
apD = dotInfo.apXYD(:,3); % diameter of aperture
% dotInfo.apXYD(:,1:2)
% screenInfo.center;
% disp('dotInfo.apXYD')
% dotInfo.apXYD(:,1:2)/10*screenInfo.ppd
size(screenInfo.center);
center = repmat(screenInfo.center,size(dotInfo.apXYD(:,1)));
size(dotInfo.apXYD(:,1:2));
% change the xy coordinates to pixels (y is inverted - pos on bottom, neg.
% on top
center = [center(:,1) + dotInfo.apXYD(:,1)/10*screenInfo.ppd center(:,2) - dotInfo.apXYD(:,2)/10*screenInfo.ppd]; % where you want the center of the aperture
d_ppd 	= floor(apD/10 * screenInfo.ppd);	% size of aperture in pixels
dotSize = dotInfo.dotSize; % probably better to leave this in pixels, but not sure
%dotSize = screenInfo.ppd*dotInfo.dotSize/10;
% ndots is the number of dots shown per video frame
% we will place dots in a square the size of the aperture
% - Size of aperture = Apd*Apd/100  sq deg
% - Number of dots per video frame = 16.7 dots per sq.deg/sec,
%        Round up, do not exceed the number of dots that can be
%		 plotted in a video frame (dotInfo.maxDotsPerFrame)
% maxDotsPerFrame was originally in setupScreen as a field in screenInfo,
% but makes more sense in createDotInfo as a field in dotInfo
ndots 	= min(dotInfo.maxDotsPerFrame, ceil(16.7 * apD .* apD * 0.01 / screenInfo.monRefresh));

% don't worry about pre-allocating, the number of dot fields should never
% be large enough to cause memory problems
for df = 1 : dotInfo.numDotField,
    % dxdy is an N x 2 matrix that gives jumpsize in units on 0..1
    %    	 deg/sec     * Ap-unit/deg  * sec/jump   =   unit/jump
    dxdy{df} 	= repmat((dotInfo.speed(df)/10) * (10/apD(df)) * (3/screenInfo.monRefresh) ...
        * [cos(pi*dotInfo.dir(df)/180.0) -sin(pi*dotInfo.dir(df)/180.0)], ndots(df),1);
    % ARRAYS, INDICES for loop
    ss{df}		= rand(ndots(df)*3, 2); % array of dot positions raw
    xs{df} 		= zeros(ndots(df)*3, 2); % array of dot positions within aperture
    % divide dots into three sets...
    Ls{df}      = cumsum(ones(ndots(df),3))+repmat([0 ndots(df) ndots(df)*2], ndots(df), 1);
    loopi(df)   = 1; 	% loops through the three sets of dots
end;
%disp('after one loop')
% loop length is determined by the field "dotInfo.maxDotTime"
% if none given, loop until "continue_show=0" is set by other means (eg
% user response), otherwise loop until dotInfo.maxDotTime
% always one video frame per loop

if ~isfield(dotInfo,'maxDotTime') || (isempty(dotInfo.maxDotTime) && ndots>0),
    continue_show = -1;
elseif ndots > 0,
    continue_show = round(dotInfo.maxDotTime*screenInfo.monRefresh);
else
    continue_show = 0;
end;
%disp('priority')

priorityLevel = MaxPriority(curWindow,'KbCheck');
dontclear = screenInfo.dontclear;

% THE MAIN LOOP
frames = 0;
Priority(priorityLevel);
index = 0;

% make sure the fixation still on
for i = 1:length(targets.x)
    Screen('FillOval', screenInfo.curWindow, targets.colors(i,:), targets.rects(i,:));
end
%Screen('FillOval', screenInfo.curWindow, dotInfo.fixColor, dotInfo.fixRect);
Screen('DrawingFinished',curWindow,dontclear);

while continue_show
    for df = 1 : dotInfo.numDotField,
        % get ss & xs from the big matrices
        % xs and ss are matrices that have stuff for dots from the last 2 positions + current
        % Ls picks out the previous set (1:5, 6:10, or 11:15)
        Lthis{df}  = Ls{df}(:,loopi(df));  % Lthis picks out the loop from 3 times ago, which is what is then
        % moved in the current loop
        this_x{df} = xs{df}(Lthis{df},:);  % this_x is just the matrix in pixel coordinates instead of degrees
        this_s{df} = ss{df}(Lthis{df},:); % this is a matrix of random #s - starting positions
        % 1 group of dots are shown in the first frame, a second group are
        % shown in the second frame, a third group shown in the third
        % frame, then in the next frame, some percentage of the dots from
        % the first frame are replotted according to the speed/direction
        % and coherence, the next frame the same is done for the second
        % group, etc.
        % update the loop pointer
        loopi(df) = loopi(df)+1;
        if loopi(df) == 4,
            loopi(df) = 1;
        end
        % compute new locations
        L = rand(ndots(df),1) < coh(df);
        this_s{df}(L,:) = this_s{df}(L,:) + dxdy{df}(L,:);	% offset the selected dots
        if sum(~L) > 0
            this_s{df}(~L,:) = rand(sum(~L),2);	    % get new random locations for the rest
        end
        % wrap around - check to see if any positions are greater than one or less than zero
        % which is out of the aperture, and then replace with a dot along one
        % of the edges opposite from direction of motion.
        L = sum((this_s{df} > 1 | this_s{df} < 0)')' ~= 0;
        if sum(L) > 0
            xdir = sin(pi*dotInfo.dir(df)/180.0);
            ydir = cos(pi*dotInfo.dir(df)/180.0);
            % flip a weighted coin to see which edge to put the replaced dots
            if rand < abs(xdir)/(abs(xdir) + abs(ydir))
                this_s{df}(L,:) = [rand(sum(L),1) (xdir > 0)*ones(sum(L),1)];
            else
                this_s{df}(L,:) = [(ydir < 0)*ones(sum(L),1) rand(sum(L),1)];
            end
        end
        this_x{df} = floor(d_ppd(df) * this_s{df});	% pix/ApUnit
        
        % this assumes that zero is at the top left, but we want it to be
        % in the center, so shift the dots up and left, which just means
        % adding half of the aperture size to both the x and y direction.
        %shift = repamt(d_ppd/2,
        dot_show{df} = (this_x{df} - d_ppd(df)/2)';
    end;
    % after all computations, flip
    Screen('Flip', curWindow,0,dontclear);

    % now do drawing commands
    for df = 1:dotInfo.numDotField
        Screen('DrawDots', curWindow, dot_show{df}, dotSize, dotColor, center(df,:));
    end;
    for i = 1:length(targets.x)
        Screen('FillOval', screenInfo.curWindow, targets.colors(i,:), targets.rects(i,:));
    end
    % tell ptb to get ready while doing computations for next dots
    % presentation
    Screen('DrawingFinished',curWindow,dontclear);

    frames = frames + 1;

    if frames == 1,     start_time = GetSecs;       end;
    for df = 1 : dotInfo.numDotField,
        % update the arrays so xor works next time...
        xs{df}(Lthis{df}, :) = this_x{df};
        ss{df}(Lthis{df}, :) = this_s{df};
    end;
    % check for end of loop
    continue_show = continue_show - 1;

    %user may terminate the dots by pressing certain keyboard keys defined
    %by "keys"
    if ~isempty(keys),
        [keyIsDown,secs,keyCode] = KbCheck;
        if keyIsDown,
            %FlushEvents('keyDown');
            if any(keyCode(keys)),
                continue_show = 0
                response{1} = find(keyCode(keys))
                response_time = secs;
            end;
        end;
    end;

    %user may terminate the dots by releasing the mouse button defined by
    %"mouse", this is an error for fixed duration
    if ~isempty(mouse),
        [x,y,buttons] = GetMouse(curWindow);
        %if any(buttons(mouse)),
        % have to figure out how to deal with this. If doing the touch
        % task, then mouse is pressed, and waiting for release, but if not
        % doing touch task, then waiting for mouse to be pressed.
     
        if buttons == waitpress
            %if any(buttons)
            continue_show = 0;
            if dotInfo.trialtype == 1
                % if ending because of a mouse release, and since
                % 1 is fixed duration, response{2} = 0 is error, 1 is ending
                % watching period for reaction time
                response{2} = 0;
            else
                response{2} = 1;
            end
            %response{2} = find(buttons);
            %response{2} = find(buttons(mouse));
            response_time = GetSecs;
        end;
    end
end
% erase last dots, but leave up fixation and targets
Screen('Flip', curWindow,0,dontclear);
for i = 1:length(targets.x)
    Screen('FillOval', screenInfo.curWindow, targets.colors(i,:), targets.rects(i,:));
end
Screen('DrawingFinished',curWindow,dontclear);
Screen('Flip', curWindow,0,dontclear);

end_time = GetSecs;
Priority(0);
