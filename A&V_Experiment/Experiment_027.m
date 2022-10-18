%% Experiment Script for 027 %%%%%%%%%%%%%%%%%%%%%%%%%%
% Psychtoolbox RDK Visual Stimulus presentation 
% written 08/30/22 - Jackson Mayfield 
clear;
close all; 

sca;
%  Version info
Version = 'Experiment_027_v.2.1' ; % after code changes, change version
file_directory='C:\Jackson\Adriana Stuff\AV_Motion_Discrimination_Experiment\A&V_Experiment';
data_file_directory = 'C:\Jackson\Adriana Stuff\AV_Behavioral_Data\'; 

%when running baron on fixation training set to 1
% baron_fixation_training=0;
% if baron_fixation_training==1
%     target_reward='N/A';
% end

addpath('C:\Jackson\Adriana Stuff\AV_Motion_Discrimination_Experiment\A&V_Experiment\Auditory Stimulus');
addpath('C:\Jackson\Adriana Stuff\AV_Motion_Discrimination_Experiment\A&V_Experiment\Eye_Movement_Data'); 
       

%% Run App to get Paramters for test
%In order to change any GUI paramters, go to Experiment_Parameters.mlapp
%for code on the actual app 

% % CHANGE THIS TO GET PARAMETERS FOR RDK
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
 
[ExpInfo, vstruct, dotInfo, audInfo] = CreateClassStructure(data, monWidth, viewDist, xCenter, yCenter);
    disp(ExpInfo)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time_wait_frames = round(ExpInfo.time_wait./ifi); %Contains 2 wait times , fixation and target fixation wait times 
fix_time_frames = round((ExpInfo.fixation_time/1000)/ifi)+time_wait_frames(1); 
stim_time_frames = round((ExpInfo.stim_time/1000)/ ifi);
aud_time_frames = round(((audInfo.t_end-audInfo.t_start))/ ifi);
iti_time_frames = round((ExpInfo.iti/1000)/ifi); 
TO_time_frames = round((ExpInfo.fail_timeout/1000)/ifi); 
target_time_frames = round((ExpInfo.target_fixation_time/1000)/ ifi+time_wait_frames(2));


%% Fixation Position structure
[dot_coord] = position_coordinates(screenXpixels, screenYpixels, xCenter, yCenter);

%% Target  structure initialization

%target_distance_from_fixpoint_pix=200; %+- x distance between fixation point location and target location in pixels
%target_distance_from_fixpoint_pix=350; %+- x distance between fixation point location and target location in pixels
%target_distance_from_fixpoint_pix=300; %+- x distance between fixation point location and target location in pixels
target_distance_from_fixpoint_pix=270; %+- x distance between fixation point location and target location in pixels
target_y_coord_pix = targ_adjust_y(dotInfo.apXYD(:,2)); %Pixel Y coordinate adjustment for the targets with relation to the RDK aperature
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
block_counter = 1;
gate_off_time = .1;
total_blocks = 1; 
total_trials = ExpInfo.num_trials; 
dataout = cell(total_trials+1,8);
 
%% RDK Initilization Stuff




%% Main Code

pause(2);

while (BreakState ~= 1) && (block_counter <= total_blocks) % each block
    trialcounter = 1;
    disp(['Trial #: ',num2str(trialcounter),'/',num2str(total_trials)])
    output_counter = output_counter + 1;
    dataout(output_counter,1:8) = {'Trial #' 'Position #' 'Fixation Correct' 'AV Reward' 'Catch Trial' 'Target Correct' 'Total Trial Time (sec)' 'Coherence Level'}; %Initialize Columns for data output cell
    start_block_time = hat; 
    
    while (trialcounter <= total_trials) && (BreakState ~= 1) % each trial
        output_counter = output_counter + 1;
        start_trial_time = hat; %Trial Start Time
        end_fixation_waitframes = 0; %variable to end fixation acquisition wait time once fixation is acquired
        end_target_waitframes = 0; %variable to end target acquisition wait time once fixation is acquired
                
        if audInfo.random_incorrect_opacity_list(trialcounter) == 0
            catchtrial = 'Yes';
            fix_point_color = [0 255 0]; %Green 
        elseif audInfo.random_incorrect_opacity_list(trialcounter) == 1
            catchtrial = 'No';
            fix_point_color = white; 
        end

        

        %Inititlize the coherence and direction for each trial
        dotInfo.coh = dotInfo.cohSet(trialcounter)*1000; %See CreateClassStructure.m 
        dotInfo.dir = dotInfo.random_dir_list(trialcounter); %See CreateClassStructure.m for randomization code
        
        %Initilize the auditory direction for each trial
        audInfo.coh = dotInfo.coh;
        audInfo.dir = audInfo.random_dir_list(trialcounter); %See CreateClassStructure.m for randomization code
        audInfo.mux = audInfo.random_mux_list(trialcounter);
        audInfo.congruent = audInfo.congruentList(trialcounter);
        
        if (audInfo.dir == 1 && audInfo.mux == 0)
            disp('Aud Left to Right')
        elseif audInfo.dir == 0 && audInfo.mux == 0
            disp('Aud Right to Left')
        end
        
        if audInfo.congruent == 1
            disp('A & V Congruent')
        elseif audInfo.congruent == 0
            disp('A & V Non-congruent')
        end
            
      
        [audInfo.CAM] = makeCAM(audInfo.coh, audInfo.dir, audInfo.set_dur, 0, 44100);
        [audInfo.adjustment_factor, CAM_1, CAM_2] = Signal_Creator(audInfo.CAM,audInfo.velocity); %Writes to CAM 1 and 2 for .rcx circuit to read
        [CAM_1_Cut, CAM_2_Cut, audInfo.window_duration] = aud_perecptive_field_location(CAM_1,CAM_2, audInfo.t_start, audInfo.t_end); 
                
                
        TDT.write('mux_sel',audInfo.mux); %The multiplexer values for each trial, set to all zeros for now to include only LR and RL
        TDT.write('window',audInfo.window_duration); %duration of the stimulus in ms
        %TDT.write('adjustment_factor',audInfo.adjustment_factor);%for velocity adjustment of AUD signal to the circuit
        TDT.write('CAM_1',CAM_1_Cut); %Signal 1 
        TDT.write('CAM_2',CAM_2_Cut); %Signal 2
        
        
        
        pos = ExpInfo.random_list(trialcounter);  %Gets random pos # from the list evaluated at specific trial #
        [h,k] = xypos(pos,dot_coord);%Outputs fixation center (h,k) in pixels for Psychtoolbox to draw dot
        [h_voltage, k_voltage] = pos_voltage(pos,dot_coord); %Outputs Fixation center in Volts for comparison to eyetracker values 
%         [adjust_right, adjust_left] = targ_adjust(pos);%Outputs the adjustments in pixels for dR and dL equations later on 
      
        %Turn on fixation point Initially
        Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
        Screen('DrawDots', window,[h k], ExpInfo.fixpoint_size_pix, white, [], 2);
        vbl = Screen('Flip',window);
        
        %% Now we present the fix interval with fixation point minus one frame
        % because we presented the fixation point once already when getting a
        % time stamp

        %This Includes the reward for fixating for required fixation time
        for frame = 1:fix_time_frames - waitframes
%             
%             if baron_fixation_training==1 
%                 if mod(frame,2) ~= 0
%                     x = TDT.read('x');
%                     y = TDT.read('y');
%                 end
%             else
%                 x = TDT.read('x');
%                 y = TDT.read('y');
%             end
            x = TDT.read('x');
            y = TDT.read('y');
            d = sqrt(((x-h_voltage).^2)+((y-k_voltage).^2));
            if frame < time_wait_frames(1) 
                Screen('DrawDots', window,[h k], ExpInfo.fixpoint_size_pix, white, [], 2);
                %Flip to the screen
                vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
              
                if (d <= ExpInfo.rew_radius_volts)
                    correct_counter = correct_counter + 1;
                    if frame>10
                        end_fixation_waitframes = 1;
                    end
                end
                if d >= ExpInfo.rew_radius_volts && end_fixation_waitframes==1 %AMS-050622
                    correct_counter = 0;
                    %Timeout for Failure to fixate on fixation
                    for frame_2 = 1:TO_time_frames
                        Screen('FillRect', window, black);
                        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
                        fix_timeout = 1; 
                    end
                    break
                end
            end
            if frame > time_wait_frames(1)
                Screen('DrawDots', window,[h k], ExpInfo.fixpoint_size_pix, white, [], 2);
                vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
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
                end
            end
        end
       
        %Successful Fixation on Single point 
        if correct_counter > fix_time_frames - waitframes - time_wait_frames(1)
            
            fix_timeout = 0; 
            correct_counter = 0;
            fix_reward = 'Yes';

        else
            fix_reward = 'No';
        end
        
        
         %% Now we draw the RDK and the fixation point and Play the Auditory Stim 

         av_timeout = 0;
         TDT.write('aud_off',0); %aud_off - TRUE = 1 , FALSE = 0, Begin with aud_off = 0

         if fix_timeout ~= 1
             %Play the AV Stim
             [av_timeout] = AV_Stimulus_Presentation(ExpInfo, dotInfo, window, xCenter, yCenter, h_voltage, k_voltage, TDT);
             if av_timeout ~= 1
                av_reward = 'Yes';
%                 if baron_fixation_training==1
%                      TDT.trg(1); %add in if fixation only
%                 end
             else
                av_reward = 'No';
                %Timeout for Failure to fixate on fixation
                for frame_3 = 1:TO_time_frames
                    Screen('FillRect', window, black);
                    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
                end
             end
         end


       
        %% Now Draw the descision targets
        % This Includes a end trial reward for saccade and fixation towards either one of the target
        % points, IN PROGRESS
        targ_timeout = 0;
        if fix_timeout ~= 1 && av_timeout ~= 1 
            %This picks the luminace of the targets based on correct direction response, also outputs correct target string variable, eg 'right'
            [right_target_color,left_target_color,correct_target] = target_color_selection(audInfo, dotInfo);
            
            for frame = 1:target_time_frames - waitframes
                
                x = TDT.read('x');
                y = TDT.read('y');
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
                    
                    if (isRightTargetFixation && strcmp('right',correct_target)) || (isLeftTargetFixation && strcmp('left',correct_target) || (isAnyTargetFixation && strcmp('both',correct_target))) %If hes looking at the correct target, left or right
                        correct_counter2 = correct_counter2 + 1;
                        end_target_waitframes = 1;
                    end
                    if ~isAnyTargetFixation && end_target_waitframes==1 && (frame>3)
                        correct_counter2 = 0;
                        %Timeout for Failure to fixate on fixation
                        for frame_2 = 1:TO_time_frames
                            Screen('FillRect', window, black);
                            vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
                            targ_timeout = 1;
                        end
                        break
                    end
                    
                    
                end
                if frame > time_wait_frames(2)
                    Screen('DrawDots', window, [(h + target_distance_from_fixpoint_pix) (target_y_coord_pix)], ExpInfo.targpoint_size_pix, right_target_color, [], 2);%Right target
                    Screen('DrawDots', window, [(h - target_distance_from_fixpoint_pix) (target_y_coord_pix)], ExpInfo.targpoint_size_pix, left_target_color, [], 2);%Left Target
                    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
                    if (isRightTargetFixation && strcmp('right',correct_target)) || (isLeftTargetFixation && strcmp('left',correct_target) || (isAnyTargetFixation && strcmp('both',correct_target)))
                        correct_counter2 = correct_counter2 + 1;
                    else
                        correct_counter2 = 0;
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
        end
        
        if fix_timeout == 1
            fix_timeout = 0; %Reset Timeout toggle for each new trial
            av_reward = 'N/A';%If timeout true no chance given for rdk reward so put N/A
            target_reward = 'N/A';%If timeout true no chance given for target reward so put N/A
            
        end
        if av_timeout == 1
            av_timeout = 0;
            av_reward = 'No';
            target_reward = 'N/A';%If timeout true no chance given for target reward so put N/A
        end
        if targ_timeout == 1
            targ_timeout = 0;
            target_reward = 'No'; %If targ timeout is true that means monkey did not fixate on one of the targets, targ_reward is a NO
        end
        
       
        %% Now Draw the ITI screen
        for frame = 1:iti_time_frames
            
            % Draw the 2 target points
            Screen('FillRect', window, black);
            vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

        end


        %% End of trial Stuff , timing and output 
        
        end_trial_time = GetSecs;
        trial_time = end_trial_time-start_trial_time;
        
        dataout(output_counter,1:8) = {trialcounter pos fix_reward av_reward catchtrial target_reward trial_time audInfo.coh}; 
        trialcounter = trialcounter + 1;
        
        if trialcounter <= total_trials
            disp(['Trial #: ',num2str(trialcounter),'/',num2str(total_trials)])
        end
    end
%% End of Block 
total_trials = ExpInfo.num_trials;  
num_regular_trials = total_trials - audInfo.catchtrials;  
num_catch_trials = audInfo.catchtrials; 

[Fixation_Success_Rate, AV_Success_Rate, Target_Success_Rate_Regular, Target_Success_Rate_Catch] = SR_CALC(dataout,total_trials,num_regular_trials,num_catch_trials)
    
    %Break down of each success rate based on coherence level 
    %Count how many rew and N/A per coherence 
     
    prob = coherence_probability(dataout,audInfo)
    prob_zero = prob(1,:); 
    
    [Right_dataout, Left_dataout] = direction_splitter(dataout, audInfo);
    prob_Right = directional_probability(Right_dataout, audInfo); 
    prob_Left = directional_probability(Left_dataout, audInfo); 
    
    [x, y] = psychometric_plotter(prob_Right,prob_Left, prob_zero);
    %Eye_Tracker_Plotter(eye_data_matrix);
    
     times = cell2mat(dataout(2:end,7)); %Extract the trial times 
     Total_Block_Time = sum(times);
   
    block_counter = block_counter + 1;
    
end
%%
% Save all block info and add to a .mat file for later analysis  
save([file_directory '\Behavioral_Data\' save_name],'dataout','Fixation_Success_Rate','AV_Success_Rate','Target_Success_Rate','ExpInfo','Total_Block_Time');
disp('Experiment Data Exported to Behavioral Data Folder')
sca; 
close all;
TDT.halt(); 
