function [radius_voltage] = angle2volts(angle)
%ANGLE2VOLTS Summary of this function goes here
%   Take the visual angle and converts it to 
%   a "radius voltage", this voltage corresponds to the 
%   distance from the center of your point of interest 

alpha = angle./2; 
alpha = deg2rad(alpha); 
diameter_in = 42.*tan(alpha);%if 21 in away from screen 

radius_voltage = (diameter_in./1.6)./2; %if 21 in away from screen 
end

