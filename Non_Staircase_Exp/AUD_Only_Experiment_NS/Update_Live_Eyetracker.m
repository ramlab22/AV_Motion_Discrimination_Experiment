function Update_Live_Eyetracker(eye_X, eye_Y, h_current, k_current, radius, hLine, visability)
if isempty(visability)
    visability = 'on';
end

[xp, yp] = circle(radius); %makes the points for the fixation window


%set center of target/fixation window based on input h,k

set(hLine(1),'XData',h_current,'YData',k_current,'Visible',visability); %stimulus position
set(hLine(2), 'XData', eye_X, 'YData', eye_Y);                          % eye position
set(hLine(3),'XData',xp+h_current,'YData',yp+k_current,'Visible',visability); %fixation window
end
