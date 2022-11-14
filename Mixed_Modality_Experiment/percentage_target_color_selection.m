function [right_target_color,left_target_color,correct_target] = percentage_target_color_selection(trialInfo,trialcounter)


%picks luminance of targets based on which direcction of stimulus is occcuring at each trial
    if strcmp(trialInfo.modality, 'AUD')
        if trialInfo.dir == 1
            correct_target = 'right';

        elseif trialInfo.dir == 0
            correct_target = 'left';

        end
    elseif strcmp(trialInfo.modality, 'VIS')
        if trialInfo.dir == 0
            correct_target = 'right';

        elseif trialInfo.dir == 180
            correct_target = 'left';

        end
    end
    
    if strcmp(correct_target,'right')
        
        right_target_color = [255; 255; 255; 1];
        left_target_color = [255; 255; 255;trialInfo.random_incorrect_opacity_list(trialcounter)];%incorrect target ; RGBA value, a = alpha which is the opacity of the dot value 0-1.0
        
    elseif strcmp(correct_target,'left')
        right_target_color = [255; 255; 255;trialInfo.random_incorrect_opacity_list(trialcounter)]; %incorrect target
        left_target_color = [255; 255; 255; 1];
    end
    
end

