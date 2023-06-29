%script for greg

%% set parameters as desired

coherence = 1; %values from 0-1
%coherence = 0.5; 
aperture_diameter = 15; %degrees visual angle, given monWidth = 40cm and Viewing Distance from monitor = 53cm
velocity = 45; %degrees per second
motion_direction = 180; %0=right, 180=left
maxdotsperframe = 150;
%maxdotsperframe = 400;

stim_duration = 0.834; %in seconds
n_trials = 5;
iti = 1.2 ;%in seconds

% put parameters in the form the function wants
load('velocity50_RDK_Draw_input.mat');

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
%% Psychtoolbox 
PsychDefaultSetup(2);
screenNumber = 2;
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
[screenXpixels, screenYpixels] = Screen('WindowSize', screenNumber);
[xCenter, yCenter] = RectCenter([0 0 screenXpixels screenYpixels]);
%Screen('Preference', 'SkipSyncTests', 0);
[window, windowRect] = PsychImaging('OpenWindow',screenNumber,black);

Screen('Flip', window);
ifi = Screen('GetFlipInterval', window); 
waitframes = 1;
refresh_rate = 1/ifi;

for i_trials=1:n_trials
    [rdk_timeout, eye_data_matrix] = RDK_Draw(ExpInfo, dotInfo, window, xCenter, yCenter, h_voltage, k_voltage, TDT, start_block_time, eye_data_matrix, trialcounter, fix_point_color);
    for i_frame = 1:iti_time_frames
        Screen('FillRect', window, black);
	    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    end
end
% Screen('FillRect', window, white);
% vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
% dotInfo.maxDotsPerFrame = 100;
% Screen('FillRect', window, black);
% vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
% for i_trials=1:n_trials
%     [rdk_timeout, eye_data_matrix] = RDK_Draw(ExpInfo, dotInfo, window, xCenter, yCenter, h_voltage, k_voltage, TDT, start_block_time, eye_data_matrix, trialcounter, fix_point_color);
%     for i_frame = 1:iti_time_frames
%         Screen('FillRect', window, black);
% 	    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
%     end
% end
Priority(0);
Screen('CloseAll');