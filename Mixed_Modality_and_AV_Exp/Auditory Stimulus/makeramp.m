function [CAM_r, rampt] = makeramp(dur,rampt,Fs,CAM)

t = dur;
rampsamples = round(rampt*Fs);
ramp_t = 1:rampsamples;

x = ones((round(Fs*t))-2*rampsamples,1);
rampd = cos(ramp_t./(rampsamples/pi))';
rampu = -rampd;

ramp = .5.*[rampu rampu;x x;rampd rampd]+.5;
while length(CAM) ~= length(ramp)
    ramp(end+1,:) = 0; 
end
CAM_r = CAM.*ramp;

