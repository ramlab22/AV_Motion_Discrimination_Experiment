function  [ExpInfo, dstruct, dotInfo, audInfo, AVInfo]= CreateClassStructure_MCS_AV( monWidth, viewDist, xCenter, yCenter) %Puts all data input into structure for neatness
%% Jack Mayfield 4/22/22
%set individual modality parameters to get accurate totals later
dotInfo = struct;
AVInfo = struct; 
audInfo = struct; 

%dotInfo.cohSet = []; %Coh List to choose from
%dotInfo.coh_Freq_Set = []; %This is the descending list of frequencies for each Coh (100 down to 3.2 %)
dotInfo.cohSet = [100 70.7 50 35.4 25 17.7 12.5 8.9 6.3 4.5 3.2]./100; %Coh List to choose from
dotInfo.coh_Freq_Set = [50 100 100 200 200 200 200 100 100 50 50]; %This is the descending list of frequencies for each Coh (100 down to 3.2 %)

dotInfo.n_vis_trials=sum(dotInfo.coh_Freq_Set);

audInfo.cohSet = [100 70.7 50 35.4 25 17.7 12.5 8.9 6.3 4.5 3.2]./100; %Coh List to choose from
audInfo.coh_Freq_Set = dotInfo.coh_Freq_Set; %This is the descending list of frequencies for each Coh (100 down to 3.2 %)
audInfo.n_aud_trials=sum(audInfo.coh_Freq_Set);

%AVInfo.coh_Freq_Set = dotInfo.coh_Freq_Set; %This is the descending list of frequencies for each Coh (100 down to 3.2 %)
AVInfo.coh_Freq_Set =[0 0 0 0 0 0 0 0 0 0 0]; %This is the descending list of frequencies for each Coh (100 down to 3.2 %)
AVInfo.n_AV_trials=sum(AVInfo.coh_Freq_Set);

%% GUI Input Parameters 

ExpInfo.t_angle = 0.4; % Fixation Dot and Target Dots Visual Angle in Degrees
ExpInfo.rew_angle = 15;% Reward Window Visual Angle in Degrees
%num of total trials across all modalities for each block
ExpInfo.num_trials = dotInfo.n_vis_trials+audInfo.n_aud_trials+AVInfo.n_AV_trials;
ExpInfo.catch_trials = 0; %dont use catch trials for this because previously, they replaced reg trials with fixation only reward trials to make it easier during hard staircase, but dont really need that for MCS
ExpInfo.random_incorrect_opacity_list = catch_trial_randomizer(ExpInfo);%Gives list of 1 = regular trial, 0 = catch trial, see function 
ExpInfo.stim_time = 834; %Time of stimulus presentaiton (ms)
ExpInfo.iti = 1000;%Intertrial Interval (ms)
ExpInfo.fixation_time = 200;% ms; Time to fixate on fixation point before RDK Starts presenting == time of presenting fixation point 
ExpInfo.positions = [0;0;0;0;1;0;0;0;0]; % Binary List of ON(1)/OFF(0) for position 1-9
ExpInfo.possible_pos = find(ExpInfo.positions == 1); %Corresponding Number Position available for use
ExpInfo.fail_timeout = 4000; %Failure of trial timeout in (ms)
ExpInfo.rdk_angle = 15; %RDK stimulus visual angle
ExpInfo.target_fixation_time = 150;% ms; Time to fixate inside the target point window in order to get Reward
data(30:33,1) = [1 0 0 1]; %[LR DU UD RL] 1 - Include, 0 Exclude dir
data(21:24,1)=[0 1 0 1]; % [90 180 270 0]

%% This is the random position number generator

%It takes all possible positions given above and produces a list with the
%length of num_trials for use in the .rcx circuit
ExpInfo.random_list = zeros(1,ExpInfo.num_trials);
    for i = 1:ExpInfo.num_trials
      r_index = randi(length(ExpInfo.possible_pos));
      ExpInfo.random_list(i) = ExpInfo.possible_pos(r_index);
    end
%% create num_trials long randomized list of modalities      
[ExpInfo] = MCS_modalitylist(ExpInfo, audInfo, dotInfo, AVInfo);
    
%% Display Settings 

dstruct.res = [1280 1024];    % screen resolution x y
dstruct.size = [monWidth 30];        % screen size in cm W,H 
dstruct.dis = viewDist;             % viewing distance in cm

%% Other Parameters

ExpInfo.time_wait = [1, 1.5]; % Default waiting times (seconds) for each frame [fixation, targets] 042522-AS: changed from 4 vals to 2 bc dont have cue and delay time
ExpInfo.fixpoint_size_pix = angle2pixels(ExpInfo.t_angle); %Fixation Dot Stimulus Size pixels 
ExpInfo.targpoint_size_pix = ExpInfo.fixpoint_size_pix; %Target Dot Size, same as fixation point for now 
ExpInfo.rew_radius_volts = angle2volts(ExpInfo.rew_angle); %Reward window radius value in volts 
ExpInfo.target_rew_radius_volts = angle2volts(9);
ExpInfo.ppd = 30;%pi * xCenter / atan(monWidth/viewDist/2) / 360;

%% RDK Parameters

dotInfo.dir = NaN; %Initilize for main loop purposes 
dotInfo.catchtrials = 0; % # catch trials
dotInfo.dirSet = dirBin_vis(data); %See function dirBin.m
dotInfo.rdk_size_pix = angle2pixels(ExpInfo.rdk_angle); %RDK window size in pixels
dotInfo.coherences = dotInfo.cohSet; 
dotInfo.random_coh_list = cohSet_maker_MCS(dotInfo); %Random list of coherence Values for total trials
dotInfo.random_dir_list = dir_randomizer_MCS_unisensory(dotInfo); %Random directions, 50% R and L for each coherence
dotInfo.apXYD = [0 90 (ExpInfo.rdk_angle*10)]; % Location x,y pixels (0,0 is center of screen) and diameter of the aperature, currently in visual degrees - MULTPLIED by 10 because of Shadlen dots code, needed to be an integer
dotInfo.speed = 400; %Degrees per second * 10
dotInfo.dotSize = 4; %RDK Field Dots
%dotInfo.dotSize = 3; %RDK Field Dots

dotInfo.numDotField = 1; %Do not change 
dotInfo.dotColor = [255 255 255]; %Dot field Color
dotInfo.maxDotTime = ExpInfo.stim_time/1000; %Puts this in seconds from ms 
dotInfo.Incorrect_Opacity = 1; %OPacity for the incorrect target if there is only 1 direction of motion, this for training purposes - eventually will be the same opacity as correct 
%dotInfo.maxDotsPerFrame = 400; %Maximum number of dots per frame of the RDK aperture drawing, DO NOT CHANGE - Graphics Card Specific
dotInfo.maxDotsPerFrame = 200; %Maximum number of dots per frame of the RDK aperture drawing, DO NOT CHANGE - Graphics Card Specific


%% Auditory Parameters 
audInfo.dir = NaN; %Initilize for main loop purposes 

audInfo.dirSet = dirBin(data); %[LR DU UD RL] 1 - Include, 0 - Exclude
audInfo.catchtrials = 0;
audInfo.coherences = audInfo.cohSet; %This is for use in other functions for success calcs
audInfo.random_coh_list = cohSet_maker_MCS(audInfo); %Random list of coherence Values for total trials
audInfo.random_dir_list = dir_randomizer_MCS_unisensory(audInfo); %Random directions, 50% R and L for each coherence
audInfo.velocity =40; %deg/sec
audInfo.set_dur = 78/(audInfo.velocity) ;%Seconds, This is going to be set as long as the speakers dont move, the actual duration of the stimulus will be set by the t_start and t_end variables
    stimtime_midpoint=(audInfo.set_dur*1000)/2;
    half_desired_duration=ExpInfo.stim_time/2;
    start_point=stimtime_midpoint-half_desired_duration;
    end_point=stimtime_midpoint+half_desired_duration;
audInfo.t_start = start_point; % In ms, , this will also determine "Location" of perceptive field 
audInfo.t_end = end_point;  % In ms, 
%audInfo.muxSet = [0]; %Set to zero for now which only includes LR and RL directions
%audInfo.random_mux_list = zeros(1,(ExpInfo.num_trials)); %Set to zeros for now which only includes LR and RL directions
audInfo.Incorrect_Opacity = 1;   

%% AV Parameters 
% AV Right = 1 , AV Left = 0
AVInfo.dir = NaN; %Initilize for main loop purposes 

if AVInfo.n_AV_trials ~=0
    AVInfo.coherences_dot = AVInfo.cohSet_dot;
    AVInfo.coherences_aud = AVInfo.cohSet_aud;
    AVInfo.dirSet = dirBin(data);
    AVInfo.cohSet_dot = dotInfo.cohSet;
    AVInfo.cohSet_aud = audInfo.cohSet;
    [AVInfo.aud_random_coh_list,AVInfo.dot_random_coh_list] = cohSet_maker_MCS_AV(AVInfo); %Random list of coherence Values for total trials
    AVInfo.random_dir_list = dir_randomizer_MCS_AV(AVInfo); %Random directions, 50% R and L for each coherence

else
   AVInfo.coherences_dot=[]; 
   AVInfo.coherences_aud=[];
   AVInfo.dirSet = [];
   AVInfo.cohSet_dot = [];
   AVInfo.cohSet_aud = [];
   AVInfo.aud_random_coh_list = [];
   AVInfo.dot_random_coh_list =[];
   AVInfo.random_dir_list = [];
end


%% trial info
% trialInfo.catchtrials = 0;
% trialInfo.random_incorrect_opacity_list = catch_trial_randomizer(ExpInfo,trialInfo);  

% This explains the inputs for each direction of auditory motion
% dir | mux
% 1       0  = L to R 
% 0       1  = D to U
% 1       1  = U to D
% 0       0  = R to L 


end
