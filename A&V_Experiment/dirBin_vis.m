function [dirSet] = dirBin_vis(data)
%DIRBIN Summary of this function goes here
%   Detailed explanation goes here
dir_bin = data(21:24,1)'; 
    if dir_bin == [1 1 1 1]% For the GUI State buttons corresponding to direction of RDK Motion, 0 = Right
        dirSet = [90 180 270 0];
    elseif dir_bin == [1 1 1 0]
        dirSet = [90 180 270];
    elseif dir_bin == [1 1 0 1]
        dirSet = [90 180 0];
    elseif dir_bin == [1 1 0 0]
        dirSet = [90 180];
    elseif dir_bin == [1 0 1 1]
        dirSet = [90 270 0];
    elseif dir_bin == [1 0 1 0]
        dirSet = [90 270];
    elseif dir_bin == [1 0 0 1]
        dirSet = [90 0];
    elseif dir_bin == [1 0 0 0]
        dirSet = [90];
    elseif dir_bin == [0 1 1 1]
        dirSet = [180 270 0];
    elseif dir_bin == [0 1 1 0]
        dirSet = [180 270];
    elseif dir_bin == [0 1 0 1]
        dirSet = [180 0];
    elseif dir_bin == [0 1 0 0]
        dirSet = [180];
    elseif dir_bin == [0 0 1 1]
        dirSet = [270 0];
    elseif dir_bin == [0 0 1 0]
        dirSet = [270];
    elseif dir_bin == [0 0 0 1]
        dirSet = [0];
    elseif dir_bin == [0 0 0 0]
        dirSet = [];
    end
end

