%% Calibration Auditory Test Script
addpath('C:\Jackson\Adriana Stuff\AV_Motion_Discrimination_Experiment\AUD_Only_Experiment\Auditory Stimulus');

curWindow = 0; Fs = 48828; dur = 5;  cLvl = 0; direction = 0; silence = 0;
%silence = 0.03;

PsychPortAudio('Close')
%Screen('BlendFunction', curWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
InitializePsychSound;

% Get a list of available audio devices
devices = PsychPortAudio('GetDevices');

% Search for audio devices containing 'UMC' in their name
% 'UMC' is the name of our audio interface. 
selectedDeviceIndex = [];
audioName = 'UMC';
for i = 1:length(devices)
    deviceName = devices(i).DeviceName;
    if contains(deviceName, audioName)
        selectedDeviceIndex = devices(i).DeviceIndex;
        break;
    end
end

pahandle = PsychPortAudio('Open', selectedDeviceIndex, [], 0, Fs, 2);

% White noise testing
CAM = makeCAM(cLvl, direction, dur, silence, Fs);

for i = 1:2    
    wavedata = zeros(length(CAM), 2);

    wavedata(:, i) = CAM(:, 1);
    
    PsychPortAudio('FillBuffer', pahandle, wavedata');
    PsychPortAudio('Start', pahandle, 1);
    
    WaitSecs(2)
end

% Tone testing
correct_freq = 1046.5;
correct_sound = MakeBeep(correct_freq, (dur+silence), Fs);
corr_soundout = [correct_sound', correct_sound'];
corr_soundout = normalize(corr_soundout);

for i = 1:2
    wavedata = zeros(length(corr_soundout), 2);

    wavedata(:, i) = corr_soundout(:, 1);

    PsychPortAudio('FillBuffer', pahandle, wavedata')
    PsychPortAudio('Start', pahandle)

    WaitSecs(2)
end