function [start_point,end_point] = get_aud_start_end_times(velocity_degrees_per_second,desired_duration_ms);
%calculates the starttime and endtime of the aud stim within the larger
%total aud stimulus based on the velocity of aud stim desired in deg/s
total_stimtime=78/velocity_degrees_per_second*1000;
stimtime_midpoint=total_stimtime/2;
half_desired_duration=desired_duration_ms/2;
start_point=stimtime_midpoint-half_desired_duration;
end_point=stimtime_midpoint+half_desired_duration;