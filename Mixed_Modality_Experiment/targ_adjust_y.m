function [pix] = targ_adjust_y(shadlen_y_coord)
%TARG_ADJUST Summary of this function goes here
%   Detailed explanation goes here
% For  y axis - every +1(positive y direction) of shadlen coordinates (center of screen
% is 0,0) to 150 = -3.4 pixels from the center, and every -1(negative y direction) = +3.4 pixels
% from 512 being the psychtoolbox center 

    pix = round((-512/150)*shadlen_y_coord + 512);


end

