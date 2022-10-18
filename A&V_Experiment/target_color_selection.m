function [right_target_color,left_target_color,correct_target] = target_color_selection(audInfo, dotInfo)

%picks luminance of targets based on which direcction of stimulus is occcuring at each trial
    if audInfo.dir == 1 && dotInfo.dir == 0 %L to R Aud and Right RDK  
        correct_target = 'right';
       
    elseif audInfo.dir == 0 && dotInfo.dir == 180 %R to L Aud and Left RDK
        correct_target = 'left';
        
    elseif (audInfo.dir == 1 && dotInfo.dir == 180) || (audInfo.dir == 0 && dotInfo.dir == 0) %Opposite directions of motion for Aud and Visual
        correct_target = 'both'; 
    end
    
    if strcmp(correct_target,'right')
        right_target_color = [255; 255; 255; 1];
        left_target_color = [255; 255; 255;audInfo.Incorrect_Opacity];%incorrect target ; RGBA value, a = alpha which is the opacity of the dot value 0-1.0
        
    elseif strcmp(correct_target,'left')
        right_target_color = [255; 255; 255;audInfo.Incorrect_Opacity]; %incorrect target
        left_target_color = [255; 255; 255; 1];
        
    elseif strcmp(correct_target,'both')
        right_target_color = [255; 255; 255; 1];
        left_target_color = [255; 255; 255; 1];
    end
    
end

