TDT = TDTRP('C:\Jackson\Adriana Stuff\Auditory_Experiment_Jack_060722\Exp_Circuit.rcx','RX8');
 addpath('C:\Jackson\Adriana Stuff\Auditory_Experiment_Jack_060722\Auditory Stimulus')
%%
delete 'C:\Jackson\Adriana Stuff\Auditory_Experiment_Jack_060722\Auditory Stimulus\CAM_1.f32'; % gets rid of the previous CAM
delete 'C:\Jackson\Adriana Stuff\Auditory_Experiment_Jack_060722\Auditory Stimulus\CAM_2.f32';

cLvl = 1; 
direction = 1; 
dur = 5 ; 
silence = 0; 
Fs = 44100; 
dB_value = 75; 



[CAM] = makeCAM(cLvl, direction, dur, silence, Fs);
[adjustment_factor] = Signal_Creator(CAM,dB_value);


%%
TDT.write('mux_sel',0);
TDT.write('dur',dur);
TDT.write('adjustment_factor',adjustment_factor);%Writes variables to the circuit

TDT.trg(2); 

TDT.halt()


