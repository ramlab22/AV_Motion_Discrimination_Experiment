function [volts_x] = pixels2volts_X(pix)
%PIXELS2VOLTS_X Summary of this function goes here
%   Detailed explanation goes here
volts_x = (pix*(.0078125))-5; 
end

