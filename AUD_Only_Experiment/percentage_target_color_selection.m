function [right_target_color,left_target_color,correct_target] = percentage_target_color_selection(audInfo,trialcounter)


%picks luminance of targets based on which direcction of stimulus is occcuring at each trial
    if audInfo.dir == 1
        correct_target = 'right';
       
    elseif audInfo.dir == 0
        correct_target = 'left';
        
    end
right_target_color = [255; 255; 255; 1];
 left_target_color = [255; 255; 255; 1];

    
end

