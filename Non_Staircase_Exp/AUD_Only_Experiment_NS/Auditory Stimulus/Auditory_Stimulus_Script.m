
clear; 
TDT = TDTRP('C:\Jackson\Adriana Stuff\A&V_Experiment_Jack_062122\Auditory Stimulus\AudioStim.rcx','RX8'); 
pause(1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Input Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CAM =       2 column array of voltages to present to speakers               
% cLvl =      coherence level (between 0 and 1)                        %

% speed =     an abandoned way to slow or speed the motion stimuli.    %

% direction = from CAM 1 to CAM 2 == 1                                 %
%             from CAM 2 to CAM 1 == 0 
%             
% mux  =      0 = LR and RL , 1 = UD and DU -- Chooses Set of Directions

% dir | mux
% 1       0  = L to R 
% 0       1  = D to U
% 1       1  = U to D
% 0       0  = R to L 

% dur =       duration of stimuli in seconds. Can accept decimals,     %


% silence =   period of silence at the beggin of the sound in seconds

% Fs =        Sampling frequency   

% db_input	= the expected dB maximum for the signal to ramp from/to
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dB_input = zeros(1,5);%Number of trials to get a reading for each AF 
dB_input(:) = 62;

cLvl = 1; 
direction = ones(1,length(dB_input)); % 1 0 -- L to R 
mux = zeros(1,length(dB_input)); 
dur = 3; %Seconds
silence = 0; 
Fs = 44100; %This is resampled in Signal_Creator to match the sampling rate of the RX8
 


dB_Mic = zeros(length(direction),1);
af = zeros(length(direction),1); 

for i = 1:length(direction)
    
[CAM] = makeCAM(cLvl, direction(i), dur, silence, Fs);
[adjustment_factor, CAM_1, CAM_2] = Signal_Creator(CAM,dB_input(i)); %Writes to CAM_1 and CAM_2 for .rcx circuit to read
af(i) = adjustment_factor; 

TDT.write('mux_sel',mux(i)); 
TDT.write('dur',dur);
TDT.write('adjustment_factor',adjustment_factor);
TDT.write('CAM_1',CAM_1);
TDT.write('CAM_2',CAM_2);
close all; 


TDT.trg(1); %Triggers the Start of the Stimulus
disp('Start');
pause(dur);
disp('End'); 

dB_Mic(i) = TDT.read('dB_Mic');
disp(dB_Mic)
pause(0.2)
TDT.trg(2); %Resets the dB track max
end

TDT.halt()
db = mean(dB_Mic)
