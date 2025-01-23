function  [ExpInfo, dstruct, audInfo]= CreateClassStructure_MCS(data, monWidth, viewDist, xCenter, yCenter) %Puts all data input into structure for neatness
%% adriana schoenhaut 3/11/24. modified from jack mayfield. 

audInfo = struct; 

%% GUI Input Parameters 

ExpInfo.t_angle = 0.3; % Fixation Dot and Target Dots Visual Angle in Degrees
%ExpInfo.rew_angle =9.5;% Reward Window Visual Angle in Degrees
ExpInfo.rew_angle =10;% Reward Window Visual Angle in Degrees
%ExpInfo.rew_angle =11;% Reward Window Visual Angle in Degrees

%audInfo.cohSet = [0 0 0 0 0 0 0 0 0 0 0 0]./100; %Coh List to choose from
audInfo.cohSet = [100 70.7 50 35.4 25 17.7 12.5 8.9 6.3 4.5 3.2 0]./100; %Coh List to choose from
%audInfo.cohSet = [100 100 100 100 100 100 100 100 100 100 100 100]./100; %Coh List to choose from

%audInfo.coh_Freq_Set = [300 300 300 300 0 0 0 0 0 0 0 0]; %This is the descending list of frequencies for each Coh (100 down to 3.2 %)
%audInfo.coh_Freq_Set = [0 0 300 300 300 300 300 300 300 300 300 300]; %This is the descending list of frequencies for each Coh (100 down to 3.2 %)
%audInfo.coh_Freq_Set = [300 300 300 300 300 300 300 300 300 300 300 300]; %This is the descending list of frequencies for each Coh (100 down to 3.2 %)
audInfo.coh_Freq_Set = [300 300 300 300 300 300 300 300 150 150 100 100]; %This is the descending list of frequencies for each Coh (100 down to 3.2 %)
%audInfo.coh_Freq_Set = [100 100 300 300 300 300 300 300 300 300 300 200]; %This is the descending list of frequencies for each Coh (100 down to 3.2 %)
%audInfo.coh_Freq_Set = [150 150 300 300 300 300 300 300 300 300 300 150]; %This is the descending list of frequencies for each Coh (100 down to 3.2 %)


ExpInfo.num_trials = sum(audInfo.coh_Freq_Set); % Number of total Trials for 1 block
%audInfo.velocity = 76.74; %deg/sec
%audInfo.velocity = 93.5; %deg/sec
%audInfo.velocity = 59.95; %deg/sec
%audInfo.velocity = 43; 0%deg/sec
%audInfo.velocity = 26; %deg/sec
%audInfo.velocity = 9.59; %deg/sec

%audInfo.velocity = 59.95; %deg/sec
%audInfo.velocity = 20; %deg/sec
%audInfo.velocity = 16.9; %deg/sec
ExpInfo.stim_time = 834; %Time of stim presentaiton (ms)
%ExpInfo.stim_time = 1100; %Time of stim presentaiton (ms)
%ExpInfo.stim_time = 1300; %Time of stim presentaiton (ms)

audInfo.velocity = 59.95; %deg/sec
%audInfo.velocity = 36.61; %deg/sec
%audInfo.velocity = 165.4; %deg/sec
%audInfo.velocity = 212; %deg/sec
%audInfo.velocity = 40; %deg/sec

%ExpInfo.stim_time = 601; %Time of stim presentaiton (ms)
%ExpInfo.stim_time = 367; %Time of stim presentaiton (ms)
%ExpInfo.stim_time = 133; %Time of stim presentaiton (ms)
%ExpInfo.stim_time = 550; %Time of stim presentaiton (ms)

% audInfo.velocity = 250; %deg/sec
% ExpInfo.stim_time = 312; 
%ExpInfo.iti = 800;%Intertrial Interval (ms)
ExpInfo.iti = 1000;%Intertrial Interval (ms)

ExpInfo.fixation_time = 200;% Time to fixate on fixation point before RDK Starts presenting == time of presenting fixation point 
ExpInfo.positions = [0;0;0;0;1;0;0;0;0]; % Binary List of ON(1)/OFF(0) for position 1-9
ExpInfo.possible_pos = find(ExpInfo.positions == 1); %Corresponding Number Position available for use
ExpInfo.fail_timeout = 2500; %Failure of trial timeout in (ms)
ExpInfo.rdk_angle = 0; %RDK stimulus visual angle
ExpInfo.target_fixation_time = 150;% Time to fixate inside the target point window in order to get Reward (ms)

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

ExpInfo.time_wait = [1, 1.5]; % Default waiting times (seconds) for each frame [fixation, targets] 042522-AS: changed from 4 vals to 2 bc dont have cue and delay time
ExpInfo.fixpoint_size_pix = angle2pixels(ExpInfo.t_angle); %Fixation Dot Stimulus Size pixels 
ExpInfo.targpoint_size_pix = ExpInfo.fixpoint_size_pix; %Target Dot Size, same as fixation point for now 
ExpInfo.rew_radius_volts = angle2volts(ExpInfo.rew_angle); %Reward window radius value in volts 
ExpInfo.target_rew_radius_volts = angle2volts(9);
ExpInfo.ppd = 30;%pi * xCenter / atan(monWidth/viewDist/2) / 360;



%% Auditory Parameters 
data(30:33,1) = [1 0 0 1]; %[LR DU UD RL] 1 - Include, 0 Exclude dir
audInfo.dirSet = dirBin(data); %[LR DU UD RL] 1 - Include, 0 - Exclude
audInfo.coherences = audInfo.cohSet; %This is for use in other functions for success calcs
audInfo.random_coh_list = cohSet_maker_MCS(audInfo); %Random list of coherence Values for total trials
audInfo.random_dir_list = dir_randomizer_MCS(ExpInfo, audInfo); %Random directions, 50% R and L for each coherence

audInfo.set_dur = 78/(audInfo.velocity) ;%Seconds, This is going to be set as long as the speakers dont move, the actual duration of the stimulus will be set by the t_start and t_end variables
    stimtime_midpoint=(audInfo.set_dur*1000)/2;
    half_desired_duration=ExpInfo.stim_time/2;
    start_point=stimtime_midpoint-half_desired_duration;
    end_point=stimtime_midpoint+half_desired_duration;
audInfo.t_start = start_point; % In ms, , this will also determine "Location" of perceptive field 
audInfo.t_end = end_point;  % In ms, 
audInfo.muxSet = [0]; %Set to zero for now which only includes LR and RL directions
audInfo.random_mux_list = zeros(1,(ExpInfo.num_trials)); %Set to zeros for now which only includes LR and RL directions
audInfo.Incorrect_Opacity = 1;   
 
% This explains the inputs for each direction of auditory motion
% dir | mux
% 1       0  = L to R 
% 0       1  = D to U
% 1       1  = U to D
% 0       0  = R to L 




end
