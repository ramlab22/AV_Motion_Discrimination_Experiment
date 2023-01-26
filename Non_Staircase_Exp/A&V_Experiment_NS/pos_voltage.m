function [h_current, k_current] = pos_voltage(pos,dot_coord)
%POS_VOLTAGE Summary of this function goes here
%   Detailed explanation goes here
    switch pos
        case 1
            h_current = pixels2volts_X(dot_coord.Xpos_1);
            k_current = pixels2volts_Y(dot_coord.Ypos_1);
        case 2 
            h_current = pixels2volts_X(dot_coord.Xpos_2);
            k_current = pixels2volts_Y(dot_coord.Ypos_2);
        case 3
            h_current = pixels2volts_X(dot_coord.Xpos_3);
            k_current = pixels2volts_Y(dot_coord.Ypos_3);
        case  4
            h_current = pixels2volts_X(dot_coord.Xpos_4);
            k_current = pixels2volts_Y(dot_coord.Ypos_4);
        case 5 
            h_current = pixels2volts_X(dot_coord.Xpos_5);
            k_current = pixels2volts_Y(dot_coord.Ypos_5);
        case 6
            h_current = pixels2volts_X(dot_coord.Xpos_6);
            k_current = pixels2volts_Y(dot_coord.Ypos_6);
        case 7
            h_current = pixels2volts_X(dot_coord.Xpos_7);
            k_current = pixels2volts_Y(dot_coord.Ypos_7);
        case 8 
            h_current = pixels2volts_X(dot_coord.Xpos_8);
            k_current = pixels2volts_Y(dot_coord.Ypos_8);
        case 9
            h_current = pixels2volts_X(dot_coord.Xpos_9);
            k_current = pixels2volts_Y(dot_coord.Ypos_9);
    end       
        
end

