function [right_target_color,left_target_color,correct_target] = percentage_target_color_selection(dotInfo, audInfo, AVInfo, ExpInfo, trialcounter)

 
%picks luminance of targets based on which direcction of stimulus is occcuring at each trial
    if strcmp(ExpInfo.modality, 'AUD')
        if audInfo.dir == 1
            correct_target = 'right';

        elseif audInfo.dir == 0
            correct_target = 'left';

        end
    elseif strcmp(ExpInfo.modality, 'VIS')
        if dotInfo.dir == 0
            correct_target = 'right';

        elseif dotInfo.dir == 180
            correct_target = 'left';

        end
    elseif strcmp(ExpInfo.modality, 'AV')
        if AVInfo.dir == 1
            correct_target = 'right';

        elseif AVInfo.dir == 0
            correct_target = 'left';

        end
    end
    
    if strcmp(correct_target,'right')
        
        right_target_color = [255; 255; 255; 1];
        left_target_color = [255; 255; 255;ExpInfo.random_incorrect_opacity_list(trialcounter)];%incorrect target ; RGBA value, a = alpha which is the opacity of the dot value 0-1.0
        
    elseif strcmp(correct_target,'left')
        right_target_color = [255; 255; 255;ExpInfo.random_incorrect_opacity_list(trialcounter)]; %incorrect target
        left_target_color = [255; 255; 255; 1];
    end
    
end

