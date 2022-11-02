function  [ExpInfo, dstruct, dotInfo]= CreateClassStructure(data, monWidth, viewDist, xCenter, yCenter) %Puts all data input into structure for neatness
%% Jack Mayfield 4/22/22

%% GUI Input Parameters 

ExpInfo.t_angle = data(1,1); % Fixation Dot and Target Dots Visual Angle in Degrees
ExpInfo.rew_angle = data(2,1);% Reward Window Visual Angle in Degrees
ExpInfo.num_trials = data(3,1); % Number of Trials for 1 block
ExpInfo.stim_time = data(4,1); %Time of stimulus(RDK) presentaiton (ms)
ExpInfo.iti = data(5,1);%Intertrial Interval (ms)
ExpInfo.fixation_time = data(6,1);% Time to fixate on fixation point before RDK Starts presenting == time of presenting fixation point 
ExpInfo.positions = data(7:15,:); % Binary List of ON(1)/OFF(0) for position 1-9
ExpInfo.possible_pos = find(ExpInfo.positions == 1); %Corresponding Number Position available for use
ExpInfo.fail_timeout = data(16,1); %Failure of trial timeout in (ms)
ExpInfo.rdk_angle = data(17,1); %RDK stimulus visual angle
ExpInfo.target_fixation_time = data(18,1);% Time to fixate inside the target point window in order to get Reward

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
dstruct.siz = [40 30];        % screen size in cm W,H 
dstruct.dis = 55;             % viewing distance in cm

%% Other Parameters
%ExpInfo.time_wait = [0.5, 0.2]; % Default waiting times (seconds) for each frame [fixation, targets] 042522-AS: changed from 4 vals to 2 bc dont have cue and delay time
%ExpInfo.time_wait = [0.5, 0.24];
%ExpInfo.time_wait = [0.5, 1]; % Default waiting times (seconds) for each frame [fixation, targets] 042522-AS: changed from 4 vals to 2 bc dont have cue and delay time
%ExpInfo.time_wait = [0.5, 1.5]; % Default waiting times (seconds) for each frame [fixation, targets] 042522-AS: changed from 4 vals to 2 bc dont have cue and delay time
ExpInfo.time_wait = [1, 1.5]; % Default waiting times (seconds) for each frame [fixation, targets] 042522-AS: changed from 4 vals to 2 bc dont have cue and delay time

%ExpInfo.time_wait = [0.7, 3]; % Default waiting times (seconds) for each frame [fixation, targets] 042522-AS: changed from 4 vals to 2 bc dont have cue and delay time
ExpInfo.fixpoint_size_pix = angle2pixels(ExpInfo.t_angle); %Fixation Dot Stimulus Size pixels 
ExpInfo.targpoint_size_pix = ExpInfo.fixpoint_size_pix; %Target Dot Size, same as fixation point for now 
ExpInfo.rew_radius_volts = angle2volts(ExpInfo.rew_angle); %Reward window radius value in volts 
%ExpInfo.target_rew_radius_volts = angle2volts(10);
ExpInfo.target_rew_radius_volts = angle2volts(9.5);

ExpInfo.ppd = 30;%pi * xCenter / atan(monWidth/viewDist/2) / 360;

%% RDK Parameters
dotInfo = struct;
dotInfo.catchtrials = 0; % # catch trials
dotInfo.dirSet = dirBin(data); %See function dirBin.m
dotInfo.random_incorrect_opacity_list = catch_trial_randomizer(ExpInfo,dotInfo);%Gives list of 1 = regular trial, 0 = catch trial, see function 
dotInfo.rdk_size_pix = angle2pixels(ExpInfo.rdk_angle); %RDK window size in pixels
%dotInfo.coherences = [0.0, 0.05, 0.10, 0.15, 0.2, 0.25, 0.35, 0.40, 0.50, 0.60, 0.80, 1.00]; %Possible coherencecs to choose from 
%dotInfo.coherences = [0.0, 0.05, 0.10, 0.15, 0.2, 0.25, 0.30, 0.35, 0.40, 0.45, 0.50, 0.55]; %Possible coherencecs to choose from 
%dotInfo.coherences = [0, 0.1, 0.125892541179417, 0.158489319246111, 0.199526231496888, 0.251188643150958, 0.316227766016838, 0.398107170553497, 0.501187233627272, 0.630957344480193, 0.794328234724282, 1];%Possible coherencecs to choose from 
%dotInfo.coherences = [0.0, 0.05, 0.10, 0.15, 0.2, 0.25, 0.35, 0.40, 0.70, 0.80, 0.90, 1.00]; %Possible coherencecs to choose from 
%dotInfo.coherences = [0,0.03,0.05,0.07, 0.1,0.139,0.193, 0.268,0.373,0.518,0.720,1];
%dotInfo.coherences =[0,0.031,0.044,0.063, 0.89,0.125,0.177, 0.25,0.354,0.5,0.707,1];
%dotInfo.coherences =[0,0.03,0.04,0.06, 0.89,0.13,0.18, 0.25,0.35,0.5,0.71,1.0];

%dotInfo.cohFreq = data(35:46,1)'; % Each Corresponds to the number of trials in that coherence 
dotInfo.cohSet = (nonzeros(data(34:42,1)))'./100; %This is the descending list of Coherences 
%dotInfo.random_dir_list = randomizer(ExpInfo,dotInfo);
dotInfo.coherences = dotInfo.cohSet; 
dotInfo.probs = data(43:46,1)'; %This is the input probablities for the staircase procedure protocol

dotInfo.apXYD = [0 90 (ExpInfo.rdk_angle*10)]; % Location x,y pixels (0,0 is center of screen) and diameter of the aperature, currently in visual degrees - MULTPLIED by 10 because of Shadlen dots code, needed to be an integer
dotInfo.speed = data(20,1); %Degrees per second?
%dotInfo.dotSize = 3; %RDK Field Dots
dotInfo.dotSize = 4; %RDK Field Dots

%dotInfo.dotSize = 5; %RDK Field Dots
%dotInfo.dotSize = 6; %RDK Field Dots

%dotInfo.dotSize = 9; %RDK Field Dots
%dotInfo.dotSize = 8; %RDK Field Dots
dotInfo.numDotField = 1; %Do not change 
dotInfo.dotColor = [255 255 255]; %Dot field Color
dotInfo.maxDotTime = ExpInfo.stim_time/1000; %Puts this in seconds from ms 
dotInfo.Incorrect_Opacity = 1; %OPacity for the incorrect target if there is only 1 direction of motion, this for training purposes - eventually will be the same opacity as correct 
dotInfo.maxDotsPerFrame = 400; %Maximum number of dots per frame of the RDK aperture drawing, DO NOT CHANGE - Graphics Card Specific
%dotInfo.maxDotsPerFrame = 200; %Maximum number of dots per frame of the RDK aperture drawing, DO NOT CHANGE - Graphics Card Specific


    
    
 
end
