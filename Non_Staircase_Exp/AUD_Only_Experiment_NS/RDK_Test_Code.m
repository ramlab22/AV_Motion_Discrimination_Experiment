clear; 
close all; 
sca;
%% Run App to get Paramters for test
%In order to change any GUI paramters, go to Experiment_Parameters.mlapp
%for code on the actual app 

% CHANGE THIS TO GET PARAMETERS FOR RDK
  app = Experiment_Parameters; 
  while isvalid(app); pause(0.1); end
  
%Gets all of the paramters data from the GUI and puts into a matrix 
opts = delimitedTextImportOptions;
opts.EmptyLineRule = 'read';
data_cell = readmatrix('data_cell.txt',opts);
data = str2double(data_cell); 

for i = 1:length(data) %Gets all State Buttons to initialize as zeros 
   if isnan(data(i))
       data(i) = 0;
   end
end

%% Psychtoolbox 

PsychDefaultSetup(2);
screenNumber = 1;
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
[screenXpixels, screenYpixels] = Screen('WindowSize', screenNumber);
[xCenter, yCenter] = RectCenter([0 0 screenXpixels screenYpixels]);
[window, windowRect] = PsychImaging('OpenWindow',screenNumber,black);

Screen('Flip', window);
ifi = Screen('GetFlipInterval', window);
refresh_rate = 1/ifi; 
waitframes = 1;

%% Outputs all data into new structures for ease of use in later code

monWidth = 40; %Monitor Width in cm 
viewDist = 55; %Viewing Distance from monitor in cm 
[ExpInfo, vstruct, dotInfo] = CreateClassStructure(data, monWidth, viewDist, xCenter, yCenter);


%Frame counts for each of the steps of the experiment 
time_wait_frames = round(ExpInfo.time_wait./ifi); %Contains 2 wait times , fixation and target fixation wait times 
fix_time_frames = round((ExpInfo.fixation_time/1000)/ifi)+time_wait_frames(1); 
stim_time_frames = round((ExpInfo.stim_time/1000)/ ifi);
iti_time_frames = round((ExpInfo.iti/1000)/ifi); 
TO_time_frames = round((ExpInfo.fail_timeout/1000)/ifi); 
target_time_frames = round((ExpInfo.target_fixation_time/1000)/ ifi+time_wait_frames(2));


%% RDK Initilization Stuff

%Inititlize the coherence and direction for each trial
dotInfo.coh = dotInfo.cohSet(ceil(rand*length(dotInfo.cohSet)))*1000; 
dotInfo.dir = dotInfo.dirSet(ceil(rand*length(dotInfo.dirSet)));




%% Now we draw the RDK and the fixation point

%Draw the fixation point first because we only want to loop trought the RDK
%moving dot field, no need to redraw the fixation point every frame 

  

%% This function is the "FOR" loop that we are used to

[frames, rseed, start_time, end_time] = RDK_Draw(ExpInfo, dotInfo, window, xCenter, yCenter);



        sca; 
        clear; 
        close all; 