function [X,Y] = xypos(pos,dot_coord)
%XYPOS Summary of this function goes here
%   Detailed explanation goes here

        switch pos 
            case 1
             X = dot_coord.Xpos_1;
             Y = dot_coord.Ypos_1;
            case 2
             X = dot_coord.Xpos_2;
             Y = dot_coord.Ypos_2;
            case 3
             X = dot_coord.Xpos_3;
             Y = dot_coord.Ypos_3;
            case 4
             X = dot_coord.Xpos_4;
             Y = dot_coord.Ypos_4;
            case 5
             X = dot_coord.Xpos_5;
             Y = dot_coord.Ypos_5;
            case 6
             X = dot_coord.Xpos_6;
             Y = dot_coord.Ypos_6;
            case 7
             X = dot_coord.Xpos_7;
             Y = dot_coord.Ypos_7;
            case 8
             X = dot_coord.Xpos_8;
             Y = dot_coord.Ypos_8;
            case 9
             X = dot_coord.Xpos_9;
             Y = dot_coord.Ypos_9;
        end
end

