%% Experiment Script for 027 %%%%%%%%%%%%%%%%%%%%%%%%%%
% Psychtoolbox  Auditory Motion Stimulus presentation 
% written 04/21/22 - Jackson Mayfield 
clear;
close all; 
sca;
sampling_rate = 24414*2; %sampling rate of rx8 processor

%  Version info
Version = 'Experiment_027_v.3.0' ; % after code changes, change version
file_directory='C:\Jackson\Adriana Stuff\AV_Motion_Discrimination_Experiment\AUD_Only_Experiment';
data_file_directory = 'C:\Jackson\Adriana Stuff\AV_Behavioral_Data\';
figure_file_directory = 'C:\Jackson\Adriana Stuff\AV_Figures\'; 

%when running baron on fixation training set to 1
baron_fixation_training=0;
if baron_fixation_training==1
    target_reward='N/A';
end

addpath('C:\Jackson\Adriana Stuff\AV_Motion_Discrimination_Experiment\AUD_Only_Experiment\Auditory Stimulus');
addpath('C:\Jackson\Adriana Stuff\AV_Motion_Discrimination_Experiment\AUD_Only_Experiment\Eye_Movement_Data'); 

       

%% Run App to get Paramters for test
%In order to change any GUI paramters, go to Experiment_Parameters.mlapp
%for code on the actual app 

% CHANGE THIS TO GET PARAMETERS FOR RDK
%   app = Experiment_Parameters; 
%   while isvalid(app); pause(0.1); end
%   
%Gets all of the paramters data from the GUI and puts into a matrix 
opts = delimitedTextImportOptions;
opts.EmptyLineRule = 'read';
data_cell = readmatrix('data_cell.txt',opts);
data = str2double(data_cell); 

for i_main = 1:length(data) %Gets all State Buttons to initialize as zeros 
   if isnan(data(i_main))
       data(i_main) = 0;
   end
end


%% Output Settings
%Creates a directory for storage of block data from experiment 
% Initilize connection to TDT Hardware
TDT = TDTRP([file_directory '\Exp_Circuit.rcx'],'RX8'); 
output_filename = input('Please Input experiment filename as DATE_MONKEY_BLOCK#\nex = 042122_Bravo_2 : ','s');
if isempty(output_filename)
    return;
else
    save_name = output_filename;
end
check_go = 1;
file_name_check = [data_file_directory save_name '.mat'];
file_check = dir(file_name_check);
if ~isempty(file_check)
    button = questdlg('File name exists, do you want to continue?',...
        'Continue Operation','Yes','No','Help','No');
    if strcmp(button,'Yes')
        disp('Creating file')
        check_go = 1;
    elseif strcmp(button,'No')
        disp('Canceled file operation')
        check_go = 0;
    elseif strcmp(button,'Help')
        disp('Sorry, no help available')
        check_go = 0;
    end
end
if ~check_go
    return
end



%Make Sure that all values are acceptable, i.e. the wait times aren't longer
%than the actual presentation of each of the specific stimuli 
% if ExpInfo.time_wait(1) > (ExpInfo.fixation_time/1000)
%     disp('Wait time for fixation is Greater than total fixation time, please decrease wait time.')
%     ExpInfo.time_wait(1) = input('Input New Wait time in Seconds: '); 
% elseif ExpInfo.time_wait(2) > (ExpInfo.target_fixation_time/1000)
%     disp('Wait time for target fixation is Greater than total target fixation time, please decrease wait time.')
%     ExpInfo.time_wait(2) = input('Input New Wait time in Seconds: '); 
% end

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

%% Structure Initialization 

% Outputs all data into new structures for ease of use in later code

monWidth = 40; %Monitor Width in cm 
viewDist = 53; %Viewing Distance from monitor in cm 

%%%%%%%%%%%%%%%%%%%%%%% Main Structures for variable names %%%%%%%%%%%%%%
 
[ExpInfo, vstruct, audInfo] = CreateClassStructure_MCS(data, monWidth, viewDist, xCenter, yCenter);
    disp(ExpInfo)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time_wait_frames = round(ExpInfo.time_wait./ifi); %Contains 2 wait times , fixation and target fixation wait times 
fix_time_frames = round((ExpInfo.fixation_time/1000)/ifi)+time_wait_frames(1); 
fix_only_time_frames = round((ExpInfo.fixation_time/1000)/ifi); 

stim_time_frames = round((ExpInfo.stim_time/1000)/ ifi);
aud_time_frames = round(((audInfo.t_end - audInfo.t_start)/1000)/ ifi);
iti_time_frames = round((ExpInfo.iti/1000)/ifi); 
TO_time_frames = round((ExpInfo.fail_timeout/1000)/ifi); 
target_time_frames = round((ExpInfo.target_fixation_time/1000)/ ifi+time_wait_frames(2));
target_only_time_frames = round((ExpInfo.target_fixation_time/1000)/ ifi);


%% Fixation Position structure
[dot_coord] = position_coordinates(screenXpixels, screenYpixels, xCenter, yCenter);

%% Target  structure initialization

%target_distance_from_fixpoint_pix=200; %+- x distance between fixation point location and target location in pixels
%target_distance_from_fixpoint_pix=350; %+- x distance between fixation point location and target location in pixels
%target_distance_from_fixpoint_pix=300; %+- x distance between fixation point location and target location in pixels
target_distance_from_fixpoint_pix=270; %+- x distance between fixation point location and target location in pixels
target_y_coord_pix = targ_adjust_y(90); %Pixel Y coordinate adjustment for the targets with relation to the RDK aperature
target_y_coord_volts = pixels2volts_Y(target_y_coord_pix);%yCenter+target_y_coord_pix); %Added to yCenter to account for shadlen dots functions using a 0,0 center coordinate

volts_per_pixel=0.0078125; %10 volts/1280 pixels= X volts/1 pixel , This is for the X direction ONLY
target_distance_from_fixpoint_volts=target_distance_from_fixpoint_pix*volts_per_pixel;

%% Initialize eye display figure
% [Figdata, hFig, hAxes, hLine] = InitEyeDisplay;
eye_data_matrix = []; %This is for saving eye position data for entire block


%% Initialize Block info

BreakState = 0;
output_counter = 0;
correct_counter = 0;
aud_correct_counter = 0;
correct_counter2 = 0;
incorrect_counter2=0;
block_counter = 1;
gate_off_time = .1;
total_blocks = 1; 
total_trials = ExpInfo.num_trials; 
dataout = cell(total_trials+1,11);
rng('default');
 




%% Main Code

pause(2);
while (BreakState ~= 1) && (block_counter <= total_blocks) % each block
    trialcounter = 1;
     coh_counter = 1;
    disp(['Trial #: ',num2str(trialcounter),'/',num2str(total_trials)])
    output_counter = output_counter + 1;
    dataout(output_counter,1:11) = {'Trial #' 'Position #' 'Fixation Correct' 'Auditory Reward' 'Catch Trial' 'Target Correct' 'Total Trial Time (sec)' 'Coherence Level' 'Direction of Motion' 'Incorrect Target Fixation' 'Stimulus Modality'}; %Initialize Columns for data output cell
    start_block_time = hat; 
    
    while (trialcounter <= total_trials) && (BreakState ~= 1) % each trial
        output_counter = output_counter + 1;
        start_trial_time = hat; %Trial Start Time
        end_fixation_waitframes = 0; %variable to end fixation acquisition wait time once fixation is acquired
        end_target_waitframes = 0; %variable to end target acquisition wait time once fixation is acquired
         
        %Initilize the auditory coherence and direction for each trial
        audInfo.dir = audInfo.random_dir_list(trialcounter); %randomly choose 0 or 1 for dir
        audInfo.mux = 0; %Set to zero for now, we only need L and R trials 
        audInfo.coh = audInfo.random_coh_list(trialcounter);% Random Coherence for each trial

        % No catch trials for now
        catchtrial = 'No';
        fix_point_color = white;


        if audInfo.dir == 1 && audInfo.mux == 0
            disp('Left to Right')
            disp(audInfo.coh)
        elseif audInfo.dir == 0 && audInfo.mux == 0
            disp('Right to Left')
            disp(audInfo.coh)
        end
        
       % [audInfo.CAM] = makeCAM(audInfo.coh, audInfo.dir, audInfo.set_dur, 0, 44100);
        [audInfo.CAM] = makeCAM(audInfo.coh, audInfo.dir, audInfo.set_dur, 0, 48828);
        
      %  [audInfo.adjustment_factor, CAM_1, CAM_2] = Signal_Creator(audInfo.CAM,audInfo.velocity); %Writes to CAM 1 and 2 for .rcx circuit to read
       CAM_1=audInfo.CAM(:,1);
       CAM_2=audInfo.CAM(:,2);
        [CAM_1_Cut_Ramped, CAM_2_Cut_Ramped, audInfo.window_duration, audInfo.ramp_dur] = aud_receptive_field_location(CAM_1,CAM_2, audInfo.t_start, audInfo.t_end); 
       
        
        TDT.write('mux_sel',audInfo.mux); %The multiplexer values for each trial, set to all zeros for now to include only LR and RL
        TDT.write('window',audInfo.window_duration); %duration of the stimulus in ms
        TDT.write('ramp_dur',audInfo.ramp_dur);
        TDT.write('CAM_1',CAM_1_Cut_Ramped); %Signal 1 
        TDT.write('CAM_2',CAM_2_Cut_Ramped); %Signal 2
        
        
        
        pos = ExpInfo.random_list(trialcounter);  %Gets random pos # from the list evaluated at specific trial #
        [h,i_trial] = xypos(pos,dot_coord);%Outputs fixation center (h,k) in pixels for Psychtoolbox to draw dot
        [h_voltage, k_voltage] = pos_voltage(pos,dot_coord); %Outputs Fixation center in Volts for comparison to eyetracker values 
%         [adjust_right, adjust_left] = targ_adjust(pos);%Outputs the adjustments in pixels for dR and dL equations later on 
      
        %Turn on fixation point Initially
        Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
        Screen('DrawDots', window,[h i_trial], ExpInfo.fixpoint_size_pix, fix_point_color, [], 2);
        vbl = Screen('Flip',window);
        
        %% Now we present the fix interval with fixation point minus one frame
        % because we presented the fixation point once already when getting a
        % time stamp

        %This Includes the reward for fixating for required fixation time
        for frame = 1:fix_time_frames - waitframes
            if baron_fixation_training==1 
                if mod(frame,2) ~= 0
                    x = TDT.read('x');
                    y = TDT.read('y');
                end
            else
                x = TDT.read('x');
                y = TDT.read('y');
            end
            x = TDT.read('x');
            y = TDT.read('y');
            [eye_data_matrix] = Send_Eye_Position_Data(TDT, start_block_time, eye_data_matrix, 1, trialcounter); %Collect eye position data with timestamp
            
            d = sqrt(((x-h_voltage).^2)+((y-k_voltage).^2));
            if frame < time_wait_frames(1) 
                Screen('DrawDots', window,[h i_trial], ExpInfo.fixpoint_size_pix, fix_point_color, [], 2);
                %Flip to the screen
                vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
              
                if (d <= ExpInfo.rew_radius_volts)
                    correct_counter = correct_counter + 1;
                    if frame>10 %give monkey a buffer in case they were already looking where the fixpoint was 
                        end_fixation_waitframes = 1;
                    end
                end%if looking at fix point
                if d >= ExpInfo.rew_radius_volts && end_fixation_waitframes==1 %AMS-050622
                    correct_counter = 0;
                    %Timeout for Failure to fixate on fixation
                    for frame_2 = 1:TO_time_frames
                        Screen('FillRect', window, black);
                        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
                        fix_timeout = 1; 
                    end %give timeout
                    break
                end
                if correct_counter > fix_only_time_frames
                    break
                end %if fixate for necessary amoutn of time during waiting period
            end %if frame < fixation waiting period
            if frame > time_wait_frames(1)
                Screen('DrawDots', window,[h i_trial], ExpInfo.fixpoint_size_pix, fix_point_color, [], 2);
                vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
                if correct_counter > fix_only_time_frames %break out of loop if already fixated for required amount of time
                    break %added 10/31/22-AMS
                end %if fixated for necessary amoutn of time
                if d <= ExpInfo.rew_radius_volts
                    correct_counter = correct_counter + 1;
                else
                    correct_counter = 0;
                    %Timeout for Failure to fixate on fixation
                    for frame_2 = 1:TO_time_frames
                        Screen('FillRect', window, black);
                        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
                        fix_timeout = 1; 
                    end
                    break
                end %if looking within fix window
            end %if past the fixation waiting period
        end %for fixation time frames
       
        %Successful Fixation on Single point 
        if correct_counter > fix_time_frames - waitframes - time_wait_frames(1)
            
            fix_timeout = 0; 
            correct_counter = 0;
            fix_reward = 'Yes';

        else
            fix_timeout = 1;
            fix_reward = 'No';
        end %if they fixated for sufficient amount of time at any point
        
        
         %% Now we play the aud stim and the fixation point


        %% Present the Auditory Stimulus while keeping the fixation point up
        aud_timeout = 0;
        TDT.write('aud_off',0); %aud_off - TRUE = 1 , FALSE = 0, Begin with aud_off = 0
        
        if fix_timeout ~= 1

            TDT.trg(2); %Triggers the Start of the Stimulus
            
            for frame = 1:aud_time_frames - waitframes
                
                x = TDT.read('x');
                y = TDT.read('y');
                [eye_data_matrix] = Send_Eye_Position_Data(TDT, start_block_time, eye_data_matrix, 2, trialcounter); %Collect eye position data with timestamp
                
                d = sqrt(((x-h_voltage).^2)+((y-k_voltage).^2));

                Screen('DrawDots', window,[h i_trial], ExpInfo.fixpoint_size_pix, fix_point_color, [], 2);
                %Flip to the screen
                vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

                if (d <= ExpInfo.rew_radius_volts)
                    aud_correct_counter = aud_correct_counter + 1;
                    if frame>10
                        end_fixation_waitframes = 1;        
                    end
                end

                if d >= ExpInfo.rew_radius_volts && end_fixation_waitframes==1 %AMS-050622
                    aud_correct_counter = 0;
                    %Timeout for Failure to fixate on fixation, during
                    %auditory stim period
                    for frame_2 = 1:TO_time_frames
                        Screen('FillRect', window, black);
                        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
                        aud_timeout = 1;
                        TDT.write('aud_off',1); %Turn off Audio
                    end
                    break
                end
            end
            
            %Successful Fixation on Single point
            if aud_correct_counter > fix_time_frames - waitframes - time_wait_frames(1)
                
                aud_timeout = 0;
                aud_correct_counter = 0;
                aud_reward = 'Yes';
                if baron_fixation_training==1
                    TDT.trg(1); %add in if fixation only
                    incorrect_target_fixation='N/A';
                    
                end
            else
                aud_reward = 'No';
            end
            
        end %if trial is visual 

        %% Now Draw the descision targets
        % This Includes a end trial reward for saccade and fixation towards either one of the target
        % points, IN PROGRESS
        targ_timeout = 0;
        if fix_timeout ~= 1 && aud_timeout ~= 1 && baron_fixation_training ~= 1
            %This picks the luminace of the targets based on correct direction response, also outputs correct target string variable, eg 'right'
            [right_target_color,left_target_color,correct_target] = percentage_target_color_selection(audInfo,trialcounter);
            
            for frame = 1:target_time_frames - waitframes
                
                x = TDT.read('x');
                y = TDT.read('y');
                [eye_data_matrix] = Send_Eye_Position_Data(TDT, start_block_time, eye_data_matrix, 3, trialcounter); %Collect eye position data with timestamp
                %Update_Live_Eyetracker(x, y, h_voltage, k_voltage, ExpInfo.rew_radius_volts, hLine, 'on');
                
                % Change the blend function to draw antialiased target points
                Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA', [1 1 1 1]);
                % Draw the 2 target points, k-... because shadlendots
                % function's coordinates are backwards from ours, super
                % convienient and not at all confusing
                Screen('DrawDots', window, [(h + target_distance_from_fixpoint_pix) (target_y_coord_pix)], ExpInfo.targpoint_size_pix, right_target_color, [], 2);%Right target
                Screen('DrawDots', window, [(h - target_distance_from_fixpoint_pix) (target_y_coord_pix)], ExpInfo.targpoint_size_pix, left_target_color, [], 2);%Left Target
                % Flip to the screen
                vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
                
                dR = sqrt(((x-(h_voltage + target_distance_from_fixpoint_volts)).^2)+((y-(k_voltage+target_y_coord_volts)).^2));%Right Target Distance
                dL = sqrt(((x-(h_voltage - target_distance_from_fixpoint_volts)).^2)+((y-(k_voltage+target_y_coord_volts)).^2));%Left Target Distance
                isRightTargetFixation = (dR <= ExpInfo.target_rew_radius_volts);
                isLeftTargetFixation = (dL <= ExpInfo.target_rew_radius_volts);
                isAnyTargetFixation = (isRightTargetFixation || isLeftTargetFixation);
                
                if frame < time_wait_frames(2)
                    Screen('DrawDots', window, [(h + target_distance_from_fixpoint_pix) (target_y_coord_pix)], ExpInfo.targpoint_size_pix, right_target_color, [], 2);%Right target
                    Screen('DrawDots', window, [(h - target_distance_from_fixpoint_pix) (target_y_coord_pix)], ExpInfo.targpoint_size_pix, left_target_color, [], 2);%Left Target
                    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
                    
                    if (isRightTargetFixation && strcmp('right',correct_target)) || (isLeftTargetFixation && strcmp('left',correct_target)) %If hes looking at the correct target, left or right
                        correct_counter2 = correct_counter2 + 1;
                        end_target_waitframes = 1;
                    end
                    if ~isAnyTargetFixation && end_target_waitframes==1 
                        correct_counter2 = 0;
                        %Timeout for Failure to fixate on fixation
                        for frame_2 = 1:TO_time_frames
                            Screen('FillRect', window, black);
                            vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
                            targ_timeout = 1;
                        end
                        break
                    end
                    if correct_counter2 > target_only_time_frames
                        break
                    end
                    if (isLeftTargetFixation && strcmp('right',correct_target)) || (isRightTargetFixation && strcmp('left',correct_target)) && end_target_waitframes == 0
                        incorrect_counter2 = incorrect_counter2 + 1;
                    end
                    if incorrect_counter2 > target_only_time_frames
                        
                       
%                         for frame_2 = 1:TO_time_frames %added 10/13/22-AMS
%                             Screen('FillRect', window, black);
%                             vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
%                             targ_timeout = 1;
%                         end
                        break
                    end
                    
                end
                if frame > time_wait_frames(2)
                    if correct_counter2 > target_only_time_frames
                        break %added 10/31/22-AMS
                    end
                    if (isRightTargetFixation && strcmp('right',correct_target)) || (isLeftTargetFixation && strcmp('left',correct_target))
                        correct_counter2 = correct_counter2 + 1;
                    elseif (isLeftTargetFixation && strcmp('right',correct_target)) || (isRightTargetFixation && strcmp('left',correct_target)) && end_target_waitframes == 0
                        incorrect_counter2 = incorrect_counter2 + 1;    
                    else
                        correct_counter2 = 0;
                        incorrect_counter2 =0 ;
                        %Timeout for Failure to fixate on target
                        for frame_2 = 1:TO_time_frames
                            Screen('FillRect', window, black);
                            vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
                            targ_timeout = 1;
                        end
                        break
                    end
                    
                
                end
            end
            if correct_counter2 > target_time_frames - waitframes - time_wait_frames(2)
                %Send Reward Pulse if he has fixated long
                %enough to earn it and we are at the end of the last
                %frame
                targ_timeout = 0;
                TDT.trg(1);
                correct_counter2 = 0;
                target_reward = 'Yes';
            else
                target_reward = 'No';
             
            end
            
            if incorrect_counter2 > target_time_frames - waitframes - time_wait_frames(2)
                incorrect_target_fixation = 'Yes';
                incorrect_counter2 =0 ;
            else
                incorrect_target_fixation = 'No';
            end
        end
        
        if fix_timeout == 1
            fix_timeout = 0; %Reset Timeout toggle for each new trial
            aud_reward = 'N/A';%If timeout true no chance given for rdk reward so put N/A
            target_reward = 'N/A';%If timeout true no chance given for target reward so put N/A
            incorrect_target_fixation='N/A';
        end
        if aud_timeout == 1
            aud_timeout = 0;
            aud_reward = 'No';
            target_reward = 'N/A';%If timeout true no chance given for target reward so put N/A
            incorrect_target_fixation='N/A';
        end
        if targ_timeout == 1
            targ_timeout = 0;
            target_reward = 'No'; %If targ timeout is true that means monkey did not fixate on one of the targets, targ_reward is a NO
            incorrect_target_fixation='N/A';
        end
        
       
        %% Now Draw the ITI screen
        for frame = 1:iti_time_frames
            [eye_data_matrix] = Send_Eye_Position_Data(TDT, start_block_time, eye_data_matrix, 4, trialcounter); %Collect eye position data with timestamp
            
            % Draw the 2 target points
            Screen('FillRect', window, black);
            vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

        end


        %% End of trial Stuff , timing and output
            %set trial status for staircase procedure to decide
            %probabilities on subsequent trial
        if strcmp(target_reward,'Yes')
            trial_status = 'Correct';        
        elseif strcmp(target_reward,'No') 
            trial_status = 'Incorrect';
        else %if subject abandons trial early
            if trialcounter==1
                trial_status='Incorrect';
            else %use whatever the trial_status from the previous trial was to repeat those probabilities
                trial_status = trial_status;
            end
        end
  
        stim_modality = 'AUD';
        end_trial_time = hat;
        trial_time = end_trial_time-start_trial_time;
        
        dataout(output_counter,1:11) = {trialcounter pos fix_reward aud_reward catchtrial target_reward trial_time audInfo.coh audInfo.dir incorrect_target_fixation stim_modality}; 
        trialcounter = trialcounter + 1;
        
        if trialcounter <= total_trials
            disp(['Trial #: ',num2str(trialcounter),'/',num2str(total_trials)])
        end %if not on last trial
    end %while still going through all the trials
%% End of Block 

if trialcounter < ExpInfo.num_trials
    total_trials = trialcounter;
else
    total_trials = ExpInfo.num_trials;
end

num_regular_trials = total_trials - audInfo.catchtrials;  
num_catch_trials = audInfo.catchtrials; 

[Fixation_Success_Rate, AUD_Success_Rate, Target_Success_Rate_Regular, Target_Success_Rate_Catch] = SR_CALC(dataout,total_trials,num_regular_trials,num_catch_trials)
    
    %Break down of each success rate based on coherence level 
    %Count how many rew and N/A per coherence 
     audInfo.cohFreq = cohFreq_finder(dataout, audInfo);
     
     prob = coherence_probability(dataout,audInfo)
%    prob_zero = prob(1,:); 
    
    [Right_dataout, Left_dataout] = direction_splitter(dataout);
    
    audInfo.cohFreq_right = cohFreq_finder(Right_dataout, audInfo);
    audInfo.cohFreq_left = cohFreq_finder(Left_dataout, audInfo);
    
    
    prob_Right = directional_probability(Right_dataout, audInfo); 
    prob_Left = directional_probability(Left_dataout, audInfo); 
    
    [x, y, fig_both, coeff_p_values,CIs_of_LR_fit,mu,std_gaussian] = psychometric_plotter(prob_Right,prob_Left, audInfo,save_name);
    Eye_Tracker_Plotter(eye_data_matrix);
    
    %%Make Rightward only graph
    prob_right_only = coherence_probability_1_direction(Right_dataout, audInfo);
    [R_coh, R_pc, R_fig] = psychometric_plotter_1_direction(prob_right_only, 'RIGHT ONLY', audInfo, save_name);
    
    %%Make Leftward only graph
    prob_left_only = coherence_probability_1_direction(Left_dataout, audInfo);
    [L_coh, L_pc, L_fig] = psychometric_plotter_1_direction(prob_left_only, 'LEFT ONLY', audInfo, save_name);


    %Save all figures to Figure Directory
    saveas(fig_both, [figure_file_directory save_name '_AUD_MCS_Psyc_Func_LR.png'])
    saveas(R_fig, [figure_file_directory save_name '_AUD_MCS_Psyc_Func_R.png'])
    saveas(L_fig, [figure_file_directory save_name '_AUD_MCS_Psyc_Func_L.png'])
    
    
    times = cell2mat(dataout(2:end,7)); %Extract the trial times 
    Total_Block_Time = sum(times);
   
    block_counter = block_counter + 1;
    
end
mu
std_gaussian
slope_at_50_percent = 1 / (std_gaussian * sqrt(2 * pi))

%%
[n_trials_with_response,n_trials_with_reward,proportion_response_reversals_after_correct_response,proportion_response_reversals_after_incorrect_response] = response_reversal_proportions2(dataout);
% Save all block info and add to a .mat file for later analysis  
%save([data_file_directory save_name],'save_name','dataout','Fixation_Success_Rate','AUD_Success_Rate','Target_Success_Rate_Regular','Target_Success_Rate_Catch','ExpInfo','audInfo','Total_Block_Time','eye_data_matrix', "coeff_p_values",'CIs_of_LR_fit','n_trials_with_response','n_trials_with_reward','proportion_response_reversals_after_correct_response','proportion_response_reversals_after_incorrect_response','threshold', 'prob');
save([data_file_directory save_name]);

disp('Experiment Data Exported to Behavioral Data Folder')
sca; 

TDT.halt(); 
