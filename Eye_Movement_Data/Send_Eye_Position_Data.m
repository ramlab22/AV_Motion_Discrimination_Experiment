function [data_matrix] = Send_Eye_Position_Data(TDT, start_time, data_matrix, section)
%SEND_EYE_POSITION_DATA Summary of this function goes here
%  Need to inou the x,y position and also a start_time = hat from the
%  begining of the experiment
x = TDT.read('x');
y = TDT.read('y');
time = hat - start_time; %High Accuracy Timer, microsecond
%{
the Section numbers correpond to : 
1 - Fixation 
2 - Stimulus 
3 - Targets
4 - ITI
%}

data_matrix(end+1, 1:4) = [time, x, y, section]; %Add a new row of data for every run of this function, section is a number that tells you which section of exp this was recorded in 

end

