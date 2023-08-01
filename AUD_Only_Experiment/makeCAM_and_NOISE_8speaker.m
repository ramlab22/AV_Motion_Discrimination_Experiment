function [CAM, speaker2_6_noise, speaker3_7_noise, speaker4_8_noise] = makeCAM_and_NOISE_8speaker(cLvl, direction, dur, silence, Fs, dB_noise_reduction,n_speakers)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CAM =       array of voltages to present to speakers                 %
% cLvl =      coherence level (between 0 and 1)                        %
% speed =     an abandoned way to slow or speed the motion stimuli.    %
% direction = explanatory. 1 = leftward motion.                        %
% dur =       duration of stimuli in seconds. Can accept decimals,     %
%             but for uneven durations, you may need to round the Fs*t %
%             operation when generating duration in samples   
% silence =   period of silence at the beggin of the sound in seconds
% Fs =        Sampling frequency                                       %
% speaker2_6_noise = uncorrelated and correlated noise to be played
%               out of diagonal upper right and diagonal lower left    %
%               speakers
% speaker3_7_noise = uncorrelated and correlated noise to be played    %
%               out of upper and lower speakers
% speaker4_8_noise = uncorrelated and correlated noise to be played    %
%               out of diagonal upper left and diagonal lower right
%               speakers                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%n_speakers = 8;
dB_speaker_reduction = 10*log10(n_speakers);
n_speaker_reduction_scalar = 10^(-(dB_speaker_reduction)/20);

n_noise_reduction_scalar = 10^(-(dB_noise_reduction)/20);

% Calculate duration in samples. Rounding is unnessesary if you have an
% even duration (one that doesn't produce a decimal when multiplying by Fs)
samples = round(dur.*Fs);
silent = zeros((silence.*Fs),2);

% Generate the 4 noise signals
N1 = (rand(samples,1)-.5)*n_speaker_reduction_scalar;
N2 = (rand(samples,1)-.5)*n_speaker_reduction_scalar;
N3 = (rand(samples,1)-.5)*n_speaker_reduction_scalar;
N4 = rand(samples,1)-.5;
N5 = (rand(samples,1)-.5)*n_speaker_reduction_scalar;
N6 = (rand(samples,1)-.5)*n_speaker_reduction_scalar;
N7 = (rand(samples,1)-.5)*n_speaker_reduction_scalar;
N8 = (rand(samples,1)-.5)*n_speaker_reduction_scalar;
N9 = (rand(samples,1)-.5)*n_speaker_reduction_scalar;

% Generate noise signals of 0, 100, and 50% correlation
leftright_n0 = [N1 N2];
updown_n0 = [N3 N5];
diag45_225_n0 = [N6 N7]; 
diag135_315_n0 = [N8 N9];

% Unused array of all noises together
%Y = [n0 n50 n100];

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
% Noise for each speaker
if cLvl <.5
    speaker2_6_noise = leftright_n0;
    speaker1_5_noise = diag45_225_n0;
    speaker4_8_noise = updown_n0;
    speaker3_7_noise = diag135_315_n0;
    motion = motion.*cLvl.*2;
    CAM = speaker2_6_noise + motion;
else
    speaker2_6_noise = leftright_n0.*(1-cLvl).*2;
    speaker1_5_noise = diag45_225_n0.*(1-cLvl).*2;
    speaker4_8_noise = updown_n0.*(1-cLvl).*2;
    speaker3_7_noise = diag135_315_n0.*(1-cLvl).*2;
    CAM = speaker2_6_noise + motion;
end

% Applies an onset and offset ramped "gate"
CAM = makeramp(dur,Fs,CAM);
speaker2_6_noise = makeramp(dur,Fs,speaker2_6_noise);
speaker3_7_noise = makeramp(dur,Fs,speaker3_7_noise);
speaker4_8_noise = makeramp(dur,Fs,speaker4_8_noise);

% Scales the signal (and noise speakers) between -1 and 1
CAM = normalize(CAM);
CAM = cat(1, silent, CAM);
speaker2_6_noise = normalize(speaker2_6_noise);
speaker2_6_noise = cat(1, silent, speaker2_6_noise);
speaker3_7_noise = normalize(speaker3_7_noise);
speaker3_7_noise = cat(1, silent, speaker3_7_noise);
speaker4_8_noise = normalize(speaker4_8_noise);
speaker4_8_noise = cat(1, silent, speaker4_8_noise);