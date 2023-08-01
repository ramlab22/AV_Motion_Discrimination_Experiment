clear;
close all; 
sca;
sampling_rate = 24414*2; %sampling rate of rx8 processor
dB_noise_reduction=0;
n_speakers=8;
file_directory='C:\Jackson\Adriana Stuff\AV_Motion_Discrimination_Experiment\AUD_Only_Experiment';

addpath('C:\Jackson\Adriana Stuff\AV_Motion_Discrimination_Experiment\AUD_Only_Experiment\Auditory Stimulus');
%Gets all of the paramters data from the GUI and puts into a matrix 
opts = delimitedTextImportOptions;
opts.EmptyLineRule = 'read';
data_cell = readmatrix('data_cell.txt',opts);
data = str2double(data_cell); 
audInfo.coh=0;
for i_main = 1:length(data) %Gets all State Buttons to initialize as zeros 
   if isnan(data(i_main))
       data(i_main) = 0;
   end
end
TDT = TDTRP([file_directory '\NoiseCalibration_SLA4.rcx'],'RX8'); 
%TDT = TDTRP([file_directory '\Auditory Stimulus\speaker_calibration.rcx'],'RX8'); 

audInfo.velocity = data(29,1); %deg/sec
audInfo.set_dur = 78/(audInfo.velocity) ;%Seconds, This is going to be set as long as the speakers dont move, the actual duration of the stimulus will be set by the t_start and t_end variables
audInfo.t_start = 1; % In ms, , this will also determine "Location" of perceptive field 
audInfo.t_end = 1000*audInfo.set_dur;  % In ms, 
dur = audInfo.set_dur;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
audInfo.dir=1;

rng('default');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CAM =       array of voltages to present to speakers                 %
% cLvl =      coherence level (between 0 and 1)                        %
% speed =     an abandoned way to slow or speed the motion stimuli.    %
% direction = from CAM 1 to CAM 2 == 1                                 %
%             from CAM 2 to CAM 1 == 0 
%             keep inout as 1 for now 
% dur =       duration of stimuli in seconds. Can accept decimals,     %
%             but for uneven durations, you may need to round the Fs*t %
%             operation when generating duration in samples   
% silence =   period of silence at the beggin of the sound in seconds
% Fs =        Sampling frequency                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate duration in samples. Rounding is unnessesary if you have an
% even duration (one that doesn't produce a decimal when multiplying by Fs)
samples = round(dur.*sampling_rate);


% Generate the 4 noise signals
N1 =(rand(samples,1)-.5);
N2 = (rand(samples,1)-.5);

% Generate noise signals of 0, 100, and 50% correlation
n0 = [N1 N2];



% Titrates the SNR
if audInfo.coh <.5
    noise = n0;
else
    noise = n0.*(1-audInfo.coh).*2;
end

% Applies an onset and offset ramped "gate"
% Scales the signal between -1 and 1
%noise = normalize(noise);
audInfo.ramp_dur=0.005;
%[noise] = makeCAM_noN3(audInfo.coh, audInfo.dir, dur, 0, sampling_rate,dB_noise_reduction)
[NOISE_3_Cut_Ramped, NOISE_4_Cut_Ramped, audInfo.window_duration] = aud_receptive_field_location(noise(:,1),noise(:,2), audInfo.t_start, audInfo.t_end, sampling_rate, audInfo.ramp_dur);


%TDT.write('mux_sel',audInfo.mux); %The multiplexer values for each trial, set to all zeros for now to include only LR and RL
TDT.write('window',audInfo.window_duration); %duration of the stimulus in ms
TDT.write('ramp_dur',audInfo.ramp_dur);
TDT.write('NOISE_3',NOISE_3_Cut_Ramped); %noise 3 bottom left (speaker 1 channel 9 B1)

TDT.write('aud_off',0); %aud_off - TRUE = 1 , FALSE = 0, Begin with aud_off = 0
TDT.trg(2); %Triggers the Start of the Stimulus
pause(0.01);
readnoise1=TDT.read('NoiseAMP')
pause(0.01)
readnoise2=TDT.read('NoiseAMP')
