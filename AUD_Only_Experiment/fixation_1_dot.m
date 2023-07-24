function [] = fixation_1_dot(position,size)
% Clear the workspace and the screen
sca;

Screen('Preference', 'SkipSyncTests', 1);
% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Get the screen numbers. This gives us a number for each of the screens
% attached to our computer. For help see: Screen Screens?
screens = Screen('Screens');

% Draw we select the maximum of these numbers. So in a situation where we
% have two screens attached to our monitor we will draw to the external
% screen. When only one screen is attached to the monitor we will draw to
% this. For help see: help max
screenNumber = 2;
 
% Define black and white (white will be 1 and black 0). This is because
% luminace values are (in general) defined between 0 and 1.
% For help see: help WhiteIndex and help BlackInd  ex
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Open an on screen window and color it black.
% For help see: Screen OpenWindow?
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);

% Get the size of the on screen window in pixels.
% For help see: Screen WindowSize?
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window in pixels
% For help see: help RectCenter
[xCenter, yCenter] = RectCenter(windowRect);

% Enable alpha blending for anti-aliasing
% For help see: Screen BlendFunction?
% Also see: Chapter 6 of the OpenGL programming guide
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% Set the color of our dot to either white or green. Color is defined by red green
% and blue components (RGB). So we have three numbers which
% define our RGB values. The maximum number for each is 1 and the minimum
% 0. So, "full red" is [1 0 0]. "Full green" [0 1 0] and "full blue" [0 0
% 1]. Play around with these numbers and see the result.

%white = [1 1 1];
white = [0 1 0];


% Determine a X and Y position for our dots. NOTE also, that if the
% dot is drawn at the edge of the screen some of it might not be visible.
    if position == 5
        %Middle Dot 
        dotXpos = xCenter;
        dotYpos = yCenter;
    elseif position == 6
        %Middle Right
        dotXpos = screenXpixels-20;
        dotYpos = screenYpixels./2;
    elseif position == 4 
        %Middle Left 
        dotXpos = 20;
        dotYpos = screenYpixels./2;
    elseif position == 1
        %TopLeft Dot
        dotXpos = 20;
        dotYpos = 20;
    elseif position == 2
        %Top Center
        dotXpos = screenXpixels./2;
        dotYpos = 20;
    elseif position == 3
        %Top Right
        dotXpos = screenXpixels-20;
        dotYpos = 20;
    elseif position == 9
        %Bottom Right
        dotXpos = screenXpixels-20;
        dotYpos = screenYpixels-20;
    elseif position == 7
        %Bottom Left
        dotXpos = 20;
        dotYpos = screenYpixels-20;
    elseif position == 8
        %Bottom Center
        dotXpos = screenXpixels./2;
        dotYpos = screenYpixels-20;

    end
% Dot size in pixels
dotSizePix = size;


Screen('DrawDots', window, [dotXpos dotYpos], dotSizePix, white, [], 2);

while true
  
    %%%%%% Get Status of the switchborad gui button pres, Initialize array
    %%%%%% for the status of each button 
    switchboard_status = zeros(1,2);
    x = input('Toggle Dot On Press - (1) Off press - (2)\nQuit press - (3)\n:');
    %%%%%% = 1 turns the dot to green 
    switchboard_status(x) = 1;
   
    if switchboard_status(1) == 1
        Screen('DrawDots', window, [dotXpos dotYpos], dotSizePix, white, [], 2);
    elseif switchboard_status(2) == 1
        Screen('DrawDots', window, [dotXpos dotYpos], dotSizePix, black, [], 2);
    end
    
    
    
        % Flip to the screen
    Screen('Flip', window);
    %Quit Program
    if x == 3
        break
    end
end
sca;
end