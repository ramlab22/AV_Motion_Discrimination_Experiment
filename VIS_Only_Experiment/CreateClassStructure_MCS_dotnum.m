function  [ExpInfo, dstruct, dotInfo]= CreateClassStructure_MCS_dotnum(data, monWidth, viewDist, xCenter, yCenter) %Puts all data input into structure for neatness
%% adriana schoenhaut 10/6/23
%% parameter setting for method of constant stim version of vis experiment, but with a single constant coherence and instead varying dot number
dotInfo = struct;

dotInfo.dotnum_Freq_Set = [130 130 130 130 130 130 130 130 130]; %This is the descending list of frequencies for each Coh (100 down to 3.2 %)
dotInfo.dotnumSet = [400 350 300 250 200 150 100 50 40]; %dotnum List to choose from
ExpInfo.num_trials = sum(dotInfo.dotnum_Freq_Set); % Number of Trials for 1 block

%% GUI Input Parameters 

ExpInfo.t_angle = 0.4; % Fixation Dot and Target Dots Visual Angle in Degrees
ExpInfo.rew_angle = 14.5;% Reward Window Visual Angle in Degrees
ExpInfo.stim_time = 500; %Time of stimulus(RDK) presentaiton (ms)
ExpInfo.iti = 1000;%Intertrial Interval (ms)
ExpInfo.fixation_time = 200;% Time to fixate on fixation point before RDK Starts presenting == time of presenting fixation point 
ExpInfo.positions =[0;0;0;0;1;0;0;0;0]; % Binary List of ON(1)/OFF(0) for position 1-9
ExpInfo.possible_pos = find(ExpInfo.positions == 1); %Corresponding Number Position available for use
ExpInfo.fail_timeout = 4000; %Failure of trial timeout in (ms)
ExpInfo.rdk_angle = 17; %RDK stimulus visual angle
ExpInfo.target_fixation_time = 150;% Time to fixate inside the target point window in order to get Reward

%% This is the random position number generator

%It takes all possible positions given above and produces a list with the
%length of num_trials for use in the .rcx circuit
ExpInfo.random_list = zeros(1,ExpInfo.num_trials);
    for i = 1:ExpInfo.num_trials
      r_index = randi(length(ExpInfo.possible_pos));
      ExpInfo.random_list(i) = ExpInfo.possible_pos(r_index);
    end
    
%% Display Settings 

dstruct.res = [1280 1024];    % screen resolution x y
dstruct.siz = [monWidth 30];        % screen size in cm W,H 
dstruct.dis = viewDist;             % viewing distance in cm

%% Other Parameters

ExpInfo.time_wait = [1, 1.5]; % Default waiting times (seconds) for each frame [fixation, targets] 042522-AS: changed from 4 vals to 2 bc dont have cue and delay time
ExpInfo.fixpoint_size_pix = angle2pixels(ExpInfo.t_angle); %Fixation Dot Stimulus Size pixels 
ExpInfo.targpoint_size_pix = ExpInfo.fixpoint_size_pix; %Target Dot Size, same as fixation point for now 
ExpInfo.rew_radius_volts = angle2volts(ExpInfo.rew_angle); %Reward window radius value in volts 
ExpInfo.target_rew_radius_volts = angle2volts(9);
ExpInfo.ppd = 30;%pi * xCenter / atan(monWidth/viewDist/2) / 360;

%% RDK Parameters

dotInfo.catchtrials = 0; % # catch trials
data(21:24,1) = [0 1 0 1]; % [90 180 270 0]
dotInfo.dirSet = dirBin(data); %See function dirBin.m
dotInfo.random_incorrect_opacity_list = catch_trial_randomizer(ExpInfo,dotInfo);%Gives list of 1 = regular trial, 0 = catch trial, see function 
dotInfo.rdk_size_pix = angle2pixels(ExpInfo.rdk_angle); %RDK window size in pixels
%dotInfo.coh_Freq_Set = [200]; %This is the descending list of frequencies for each Coh (100 down to 3.2 %)
%dotInfo.cohSet = [17]./100; %Coh List to choose from
dotInfo.coherences = 12.5/100; 
%dotInfo.random_coh_list = cohSet_maker_MCS(dotInfo); %Random list of coherence Values for total trials
%dotInfo.random_dir_list = dir_randomizer_MCS(ExpInfo, dotInfo); %Random directions, 50% R and L for each coherence
%dotInfo.probs = data(43:46,1)'; %This is the input probablities for the staircase procedure protocol
dotInfo.apXYD = [0 90 (ExpInfo.rdk_angle*10)]; % Location x,y pixels (0,0 is center of screen) and diameter of the aperature, currently in visual degrees - MULTPLIED by 10 because of Shadlen dots code, needed to be an integer

dotInfo.speed =400; %Degrees per second*10
dotInfo.dotSize = 4; %RDK Field Dots
dotInfo.numDotField = 1; %Do not change 
dotInfo.dotColor = [255 255 255]; %Dot field Color
dotInfo.maxDotTime = ExpInfo.stim_time/1000; %Puts this in seconds from ms 
dotInfo.Incorrect_Opacity = 1; %OPacity for the incorrect target if there is only 1 direction of motion, this for training purposes - eventually will be the same opacity as correct 
%dotInfo.maxDotsPerFrame = 200; %Maximum number of dots per frame of the RDK aperture drawing, DO NOT CHANGE - Graphics Card Specific
dotInfo.random_dotnum_list = dotnumSet_maker_MCS(dotInfo); %Random list of coherence Values for total trials
dotInfo.random_dir_list = dir_randomizer_MCS_dotnum(ExpInfo, dotInfo); %Random directions, 50% R and L for each dotnum

%dotInfo.maxDotsPerFrame = 400; %Maximum number of dots per frame of the RDK aperture drawing, DO NOT CHANGE - Graphics Card Specific


    
    
 
end
