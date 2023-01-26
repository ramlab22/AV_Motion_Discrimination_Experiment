function [dirSet] = dirBin_aud(data)
%DIRBIN Summary of this function goes here
%   Detailed explanation goes here
dir_bin = data(30:33,1)'; %[LR DU UD RL] 1 - Include, 0 Exclude dir
    if dir_bin == [1 1 1 1]% For the GUI State buttons corresponding to direction of RDK Motion, 0 = Right
        dirSet = [1 0 1 0];
    elseif dir_bin == [1 1 1 0]
        dirSet = [1 0 1];
    elseif dir_bin == [1 1 0 1]
        dirSet = [1 0 0];
    elseif dir_bin == [1 1 0 0]
        dirSet = [1 0];
    elseif dir_bin == [1 0 1 1]
        dirSet = [1 1 0];
    elseif dir_bin == [1 0 1 0]
        dirSet = [1 1];
    elseif dir_bin == [1 0 0 1]
        dirSet = [1 0];
    elseif dir_bin == [1 0 0 0]
        dirSet = [1];
    elseif dir_bin == [0 1 1 1]
        dirSet = [0 1 0];
    elseif dir_bin == [0 1 1 0]
        dirSet = [0 1];
    elseif dir_bin == [0 1 0 1]
        dirSet = [0 0];
    elseif dir_bin == [0 1 0 0]
        dirSet = [0];
    elseif dir_bin == [0 0 1 1]
        dirSet = [1 0];
    elseif dir_bin == [0 0 1 0]
        dirSet = [1];
    elseif dir_bin == [0 0 0 1]
        dirSet = [0];
    elseif dir_bin == [0 0 0 0]
        dirSet = [];
    end
end

