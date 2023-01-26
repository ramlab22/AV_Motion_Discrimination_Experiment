ADJUST = 4; 



for i = 1:24255
    if Cam_1(i,1) > 0
        Cam_1(i,1) = Cam_1(i,1) + ADJUST;

    elseif Cam_1(i,1) < 0
        Cam_1(i,1) = Cam_1(i,1) - ADJUST;

    end
end