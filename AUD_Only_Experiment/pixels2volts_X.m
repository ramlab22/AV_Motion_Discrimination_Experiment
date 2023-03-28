function [volts_x] = pixels2volts_X(pix)
%PIXELS2VOLTS_X Converting Pixel position on screen to a corresponding "voltage position" for eye tracking system

% Current Eyetracking Computer voltage coordinates:
% x axis -- from -5 to +5 volts, Left to Right
% y axis -- from -5.5 to +5 volts, Bottom to Top
% (0,0) volts is the center of the screen

volts_x = (pix*(.0078125))-5; 
end

