function [radius_voltage] = angle2volts(angle)
%ANGLE2VOLTS Summary of this function goes here
%   Detailed explanation goes here
alpha = angle./2; 
alpha = deg2rad(alpha); 
diameter_in = 42.*tan(alpha);%if 21 in away from screen 

radius_voltage = (diameter_in./1.6)./2; %if 21 in away from screen 
end

