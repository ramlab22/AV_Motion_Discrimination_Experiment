function [right_target_color,left_target_color,correct_target] = target_color_selection(audInfo)

%picks luminance of targets based on which direcction of stimulus is occcuring at each trial
    if audInfo.dir == 1
        correct_target = 'right';
       
    elseif audInfo.dir == 0
        correct_target = 'left';
        
    end
    
    if strcmp(correct_target,'right')
        
        right_target_color = [255; 255; 255; 1];
        left_target_color = [255; 255; 255;audInfo.Incorrect_Opacity];%incorrect target ; RGBA value, a = alpha which is the opacity of the dot value 0-1.0
        
    elseif strcmp(correct_target,'left')
        right_target_color = [255; 255; 255;audInfo.Incorrect_Opacity]; %incorrect target
        left_target_color = [255; 255; 255; 1];
    end
    
end

