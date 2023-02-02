

file_directory='C:\Jackson\Adriana Stuff\AV_Motion_Discrimination_Experiment\Auditory Stimulus';  
TDT = TDTRP([file_directory '\speaker_calibration.rcx'],'RX8'); 

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

[audInfo] = CreateClassStructure(data, 1, 1, 1, 1);

audInfo.coh = 1;
audInfo.dir = 1;
audInfo.mux = 0;
aud_off = 1;
TDT.write('aud_off',aud_off);

[audInfo.CAM] = makeCAM(audInfo.coh, audInfo.dir, audInfo.set_dur, 0, 44100);
[audInfo.adjustment_factor, CAM_1, CAM_2] = Signal_Creator(audInfo.CAM,audInfo.velocity); %Writes to CAM 1 and 2 for .rcx circuit to read
[CAM_1_Cut_Ramped, CAM_2_Cut_Ramped, audInfo.window_duration, audInfo.ramp_dur] = aud_receptive_field_location(CAM_1,CAM_2, audInfo.t_start, audInfo.t_end); 
       
        
TDT.write('mux_sel',audInfo.mux); %The multiplexer values for each trial, set to all zeros for now to include only LR and RL
TDT.write('window',audInfo.window_duration); %duration of the stimulus in ms
TDT.write('ramp_dur',audInfo.ramp_dur);
TDT.write('CAM_1',CAM_1_Cut_Ramped); %Signal 1 
TDT.write('CAM_2',CAM_2_Cut_Ramped); %Signal 2

pause(1)
TDT.trg(2); %Start stimulus
pause(2)
TDT.read('MAX_DB')

TDT.halt();
        