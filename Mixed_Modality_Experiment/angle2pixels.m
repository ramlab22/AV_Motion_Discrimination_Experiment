function [diameter_pixels] = angle2pixels(angle)
%ANGLE_CONVERTER Changes the Input visual angles from .txt file into specific circle size in diameter 
% THIS ONLY ACCOUNTS FOR THE WIDTH OF THE MONITOR, the conversion methods uses the width of the screen  
% 
alpha = angle./2; 
alpha = deg2rad(alpha); 
diameter_in = 42.*tan(alpha); % 42 comes from 2*distance from eyes to screen in inches (21 in) 

diameter_pixels = round((diameter_in./16).*1280); %Conversion from inches to pixels 

end

