function [CAM_1_Cut_Ramped, CAM_2_Cut_Ramped, window_duration, ramp_dur] = aud_receptive_field_location(CAM_1, CAM_2, t_start, t_end)
%AUD_PERECPTIVE_FIELD_LOCATION Summary of this function goes here

%Clips the CAM signals so that they will be presented only at certain times
%of the stimulus, giveing them a simulated perceptive field window. This
%resembles the RDK window angle 

%  Inputs:
%{
    CAM_1 & CAM_2 = the left and right signals to manipulated 
    These must be within the given duration time ,t_start > 0  &  t_end < total duration 
    t_start = time at which you want to start clip the signal
    t_end = time at which you want to end clipping the signal
    velocity = velocity of aud stim within the window given by t_start and t_end

%}

% Outputs:
%{
    CAM_1_Cut = Cut and slope modified signal from t_start to t_end
    CAM_2_Cut = Cut and slope modified signal from t_start to t_end
    window = duration to the window from t_start to t_end
%}
window_duration = t_end - t_start; %In ms  
%Convert to samples 
samp_start = t_start * 48.828; %Sample rate of RZ processor is 48828 Hz but times are ms 
samp_end = t_end * 48.828; 

%Now cut signal at sample locations 
if samp_start == 0 %Eliminates index error if you want to start from time = 0  
    samp_start = 1; 
end
samp_start = round(samp_start);
samp_end = round(samp_end);

CAM_1_Cut = CAM_1(samp_start:samp_end, 1); 
CAM_2_Cut = CAM_2(samp_start:samp_end, 1); 

%Set ramps on these so speaker doesn't click 
CAM_Cut = [CAM_1_Cut CAM_2_Cut]; 
[CAM_Cut_Ramped, ramp_dur] = makeramp((t_end - t_start)/1000,48828,CAM_Cut);

CAM_1_Cut_Ramped = CAM_Cut_Ramped(:,1);
CAM_2_Cut_Ramped = CAM_Cut_Ramped(:,2);

end

