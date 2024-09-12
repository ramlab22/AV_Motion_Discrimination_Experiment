%         WaitSecs(wait_fix); %This is how long the monkey has to get to the fixation point
%        
%         fixation_state = 1; 
%         fixation_start = GetSecs; 
%         fixation_end = 0; 
%         while (fixation_state == 1) && ((fixation_end - fixation_start) <= (ExpInfo.fixation_time/1000)) 
            x = TDT.read('x'); 
            y = TDT.read('y'); 
            
            Update_Live_Eyetracker(x, y, h_voltage, k_voltage, ExpInfo.rew_radius_volts, hLine, 'on');
            
            d = sqrt(((x-h_voltage).^2)+((y-k_voltage).^2));
            if d <= ExpInfo.rew_radius_volts
                  %Reward After Fixation Time, and begin drawing the RDK Stimulus  
              fixation_state = 1;    
            elseif d > ExpInfo.rew_radius_volts
              fixation_state = 0; 
            end
            
            if (fixation_end - fixation_start ==  ExpInfo.fixation_time) && fixation_state == 1 
                TDT.trg(1); %Sends Reward pulse
                reward = 'Y';
                fixation_state = 0; %Ends loop 
            end
            fixation_end = GetSecs; 
        end
        