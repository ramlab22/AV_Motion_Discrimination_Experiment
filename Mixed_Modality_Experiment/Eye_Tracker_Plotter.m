function [] = Eye_Tracker_Plotter(eye_data_matrix)

figure(2)
clf


subplot(2,1,1)

plot(eye_data_matrix(:,2),eye_data_matrix(:,3))
title('X position')
xlabel('Time (sec)')
ylabel('Voltage/Position')

subplot(2,1,2)

plot(eye_data_matrix(:,2),eye_data_matrix(:,4))
title('Y position')
xlabel('Time (sec)')
ylabel('Voltage/Position')
end

