function [volts_y] = pixels2volts_Y(pix)
%PIXELS2VOLTS_Y - Converting Pixel position on screen to a corresponding "voltage position" for eye tracking system

% Current Eyetracking Computer voltage coordinates:
% x axis -- from -5 to +5 volts, Left to Right
% y axis -- from -5.5 to +5 volts, Bottom to Top
% (0,0) volts is the center of the screen

if pix >= 0 && pix < 512 %upper half of screen
volts_y = 5-(pix*.009765) ; 
else %Lower half of the screen 
volts_y = -1*((pix*.010742)-5.5);
end

