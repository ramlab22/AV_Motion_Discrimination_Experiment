% function [CAM] = makeCAM(cLvl,speed, direction, dur, Fs)
function [CAM] = makeCAM(cLvl, direction, dur, silence, Fs)

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
samples = round(dur.*Fs);
silent = zeros((silence.*Fs),2);

% Generate the 4 noise signals
N1 = rand(samples,1)-.5;
N2 = rand(samples,1)-.5;
N3 = rand(samples,1)-.5;
N4 = rand(samples,1)-.5;

% Generate noise signals of 0, 100, and 50% correlation
n0 = [N1 N2];
n100 = [N3 N3];
n50 = (n100 + n0)./2;
% Unused array of all noises together
Y = [n0 n50 n100]; 

% Generate ramp for increasing and decreasing N4 amplitute in speaker
rampu = (1/samples:1/samples:1)';
rampd = (1:-1/samples:1/samples)';
% Convolve the ramps with N4
nup = N4 .* rampu;
ndown = N4 .* rampd;

% Generate the leftward and rightward motion signal
left = [nup ndown];
right = [ndown nup];

% Apply the proper motion
if direction == 1
    motion = right;
else
    motion = left;
end

% Titrates the SNR
if cLvl <.5
    noise = n50;
    motion = motion.*cLvl.*2;
    CAM = noise + motion;
else
    noise = n50.*(1-cLvl).*2;
    CAM = noise + motion;
end

% Applies an onset and offset ramped "gate"
CAM = makeramp(dur,Fs,CAM);
% Scales the signal between -1 and 1
CAM = normalize(CAM);
CAM = cat(1, silent, CAM);


    
    