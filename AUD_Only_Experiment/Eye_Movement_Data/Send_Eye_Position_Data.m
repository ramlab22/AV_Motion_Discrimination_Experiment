function [data_matrix] = Send_Eye_Position_Data(TDT, block_start_time, data_matrix, section, trial)
%SEND_EYE_POSITION_DATA Summary of this function goes here
%  Need to inou the x,y position and also a start_time = hat from the
%  begining of the experiment, 
% The section is the section of the trial:
% 1 - fixation  
% 2 - stimulus
% 3 - Targets 
% 4 - ITI 

x = TDT.read('x');
y = TDT.read('y');
time = hat - block_start_time; %High Accuracy Timer, microsecond

data_matrix(end+1, 1:5) = [trial, time, x, y, section]; %Add a new row for every run of this function

end

