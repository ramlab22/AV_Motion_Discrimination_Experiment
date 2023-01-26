function [volts_y] = pixels2volts_Y(pix)
%PIXELS2VOLTS_Y Summary of this function goes here
%   Detailed explanation goes here
if pix >= 0 && pix < 512 %upper half of screen
volts_y = 5-(pix*.009765) ; 
else %Lower half of the screen 
volts_y = -1*((pix*.010742)-5.5);
end

