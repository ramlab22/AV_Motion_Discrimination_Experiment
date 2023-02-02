function [adjustment_factor, CAM_1, CAM_2] = Signal_Creator(CAM,velocity)
    %SIGNAL_CREATOR Summary of this function goes here
    
    %Inputs:
    % CAM       -- the input signal from makeCAM function
    % db_value	-- the expected dB maximum for the signal to ramp from/to
    
    %Output:
    % adjustment_factor -- adjustment factor for the base signal, in order
    %                      to adjust dB level of the stimulus 
    
    %% Need to resample because the RX8 has a higher sample rate
    FS_old = 44100; %old FS
    FS_new = 24414*2; %sampling rate of RZ processor
    
    [p, q] = rat(FS_new/FS_old);
    
    arr1 = resample(CAM(:,1), p, q);
    arr2 = resample(CAM(:,2), p, q);
    CAM_1 = arr1; 
    CAM_2 = arr2; 
    %% New stuff for changing the auditory velocity based on the slope of the CAM signals 
    
    %Modification of slope
    standard_velo = 78/2.523 ; %This comes from the 78 degree field for AUD and the set 2.523 seconds for TOTAL stim time
    adjustment_factor = velocity/standard_velo; %Gives a factor to multpy signal by in order to get desired velocity from GUI 


    
    %%  This is for the signal adjustment factor, based on dB values from the
    % speaker calibration test. Excel file with equations is found in C:\Jackson\Adriana Stuff\Speaker Calibration Room 027.xlsx
 
%     %THIS equation ONLY WORKS UP TO 80 dB, y = 6.7129ln(x) + 84.125
% 
%         voltage = exp((dB_value-84.125)/(6.7129)); %Based on average logrithimic trendline fit equation
        
%     elseif dB_value > 80
%         voltage = -1*(((25*dB_value)+1411)/(176));
%     end
  


    %Given the required max voltage we can calculate the adjustment factor to send to the .rcx circuit,
%     %because the non adjusted max value = +-3 V (1.0 adjustment factor)
%     
%     adjustment_factor = voltage./3; 
    
%     %% Writes the CAM signals into f32 file for reading on the RX8
%     
%     
%     filename = 'C:\Jackson\Adriana Stuff\Auditory_Experiment_Jack_060722\Auditory Stimulus\CAM_1.f32';
%     filename2 = 'C:\Jackson\Adriana Stuff\Auditory_Experiment_Jack_060722\Auditory Stimulus\CAM_2.f32';
%     
%     fid = fopen(filename, 'wb');
%     fid2 = fopen(filename2, 'wb');
%     fwrite(fid, arr1, 'float32');
%     fwrite(fid2, arr2, 'float32');
%     fclose(fid);
%     fclose(fid2);
%     
%     %PLOT
%     fid = fopen(filename, 'r');
%     yy = fread(fid, inf, '*float32');
%     fclose(fid);
%     figure; plot(yy);
%     
%     fid = fopen(filename2, 'r');
%     yy2 = fread(fid, inf, '*float32');
%     fclose(fid);
%     figure(2); plot(yy2);

end

