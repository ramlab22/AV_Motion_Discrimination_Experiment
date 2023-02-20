function  [ExpInfo, dstruct, audInfo]= CreateClassStructure(data, monWidth, viewDist, xCenter, yCenter) %Puts all data input into structure for neatness
%% Jack Mayfield 4/22/22


%% GUI Input Parameters 

ExpInfo.t_angle = data(1,1); % Fixation Dot and Target Dots Visual Angle in Degrees
ExpInfo.rew_angle = data(2,1);% Reward Window Visual Angle in Degrees
ExpInfo.num_trials = data(3,1); % Number of total Trials for 1 block
%ExpInfo.catch_trials =0; %Number of Catch Trials for 1 block, given in percentage from GUI so translate into # of catch trials
ExpInfo.catch_trials = round((data(61,1)/100)*(ExpInfo.num_trials)); %Number of Catch Trials for 1 block, given in percentage from GUI so translate into # of catch trials

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

ExpInfo.time_wait = [1, 1.5]; % Default waiting times (seconds) for each frame [fixation, targets] 042522-AS: changed from 4 vals to 2 bc dont have cue and delay time
ExpInfo.fixpoint_size_pix = angle2pixels(ExpInfo.t_angle); %Fixation Dot Stimulus Size pixels 
ExpInfo.targpoint_size_pix = ExpInfo.fixpoint_size_pix; %Target Dot Size, same as fixation point for now 
ExpInfo.rew_radius_volts = angle2volts(ExpInfo.rew_angle); %Reward window radius value in volts 
ExpInfo.target_rew_radius_volts = angle2volts(9);
ExpInfo.ppd = 30;%pi * xCenter / atan(monWidth/viewDist/2) / 360;



%% Auditory Parameters 

audInfo.dirSet = dirBin(data); %[LR DU UD RL] 1 - Include, 0 - Exclude
audInfo.catchtrials = ExpInfo.catch_trials;
audInfo.random_incorrect_opacity_list = catch_trial_randomizer(ExpInfo,audInfo); 
audInfo.cohSet = (nonzeros(data(50:60,1)))'./100; %This is the descending list of Coherences 
audInfo.coherences = audInfo.cohSet; %This is for use in other functions for success calcs
audInfo.probs = data(43:46,1)'; %This is the input probablities for the staircase procedure protocol
audInfo.velocity = data(29,1); %deg/sec
audInfo.set_dur = 78/(audInfo.velocity) ;%Seconds, This is going to be set as long as the speakers dont move, the actual duration of the stimulus will be set by the t_start and t_end variables
audInfo.t_start = data(27,1); % In ms, , this will also determine "Location" of perceptive field 
audInfo.t_end = data(28,1);  % In ms, 

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
