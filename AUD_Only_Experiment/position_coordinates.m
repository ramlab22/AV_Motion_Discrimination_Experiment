function [dot_coord] = position_coordinates(screenXpixels, screenYpixels, xCenter, yCenter)
%POSITION_COORDINATES Summary of this function goes here
%  coordinates for each fixation center position on the screen given your screens resolution in screenXpixels , screenYpixels
% Stimulus Positioning 
%Original was 150 
        %TopLeft Dot
        dot_coord.Xpos_1 = 300;
        dot_coord.Ypos_1 = 150;
        %Top Center
        dot_coord.Xpos_2 = screenXpixels./2;
        dot_coord.Ypos_2 = 150;
        %Top Right
        dot_coord.Xpos_3 = screenXpixels-300;
        dot_coord.Ypos_3 = 150;

        %Middle Left 
        dot_coord.Xpos_4 = 300;
        dot_coord.Ypos_4 = screenYpixels./2;
        %Middle Dot 
        dot_coord.Xpos_5 = xCenter;
        dot_coord.Ypos_5 = yCenter;
        %Middle Right
        dot_coord.Xpos_6 = screenXpixels-300;
        dot_coord.Ypos_6 = screenYpixels./2;

        %Bottom Left
        dot_coord.Xpos_7 = 300;
        dot_coord.Ypos_7 = screenYpixels-150;
        %Bottom Center
        dot_coord.Xpos_8 = screenXpixels./2;
        dot_coord.Ypos_8 = screenYpixels-150;
        %Bottom Right
        dot_coord.Xpos_9 = screenXpixels-300;
        dot_coord.Ypos_9 = screenYpixels-150;
end

