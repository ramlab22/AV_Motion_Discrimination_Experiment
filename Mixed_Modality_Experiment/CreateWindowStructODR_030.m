function [window, f, r, WindowStructure, AllCoordinates] = CreateWindowStructODR_030(Display, vstruct, ClassStructure)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Streamlining variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stimsize = Display.Stimsize;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create ClassStructures that have stim coordinates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
resolusion = vstruct.res;    % screen resolution
screen_size = vstruct.siz;        % screen size in cm
screen_dis = vstruct.dis;
for m = 1:length(ClassStructure)
    for n = 1:numel(ClassStructure(m).frame)
        XY = ClassStructure(m).frame(n).stim(1).end .* vstruct.pixdeg;
        %   Converts Mathematic Cartesian cordinate system (R-hand) to
        %   PTB-3 and ISCAN cordinate system (L-hand)
        XY(2) = XY(2)*-1;
        
        tCenter = XY + [Display.centerX Display.centerY];
        ClassStructures(m).frame(n).stim(1).tCenter = tCenter;
        ClassStructures(m).frame(n).stim(1).wRect   = [tCenter(1) - stimsize(1), tCenter(2) - stimsize(2), ...
            tCenter(1) + stimsize(1), tCenter(2) + stimsize(2)];
        AllCoordinates.cRect(m,:,n) = ClassStructures(m).frame(n).stim(1).wRect;
        AllCoordinates.cCenter(m,:,n) = tCenter;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create Window and Offscreen Windows
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AllCoordinates.fCenter = [Display.centerX Display.centerY];
AllCoordinates.fRect = [Display.fX1 Display.fY1 Display.fX2 Display.fY2];
[window] = Screen(2,'OpenWindow',BlackIndex(0),[],32);
%   fix window
f = Screen(window,'OpenOffscreenWindow',BlackIndex(0),[],32);
Screen(f,'FillRect',WhiteIndex(0),AllCoordinates.fRect);
%   sync window
r = Screen(window,'OpenOffscreenWindow',BlackIndex(0),[],32);
% Screen(r,'FillRect',WhiteIndex(0),[0 0 60 50]);
%
%   Frame windows
for m  = 1:length(ClassStructures)
    for n = 1:length(ClassStructures(m).frame)
        WindowStructure(m).frame(n).end = Screen(window,'OpenOffscreenwindow', BlackIndex(0), [],32);
        for o = 1:numel(ClassStructures(m).frame(n).stim)
            Screen(WindowStructure(m).frame(n).end,'FillRect',Display.Lum(n)*WhiteIndex(0),ClassStructures(m).frame(n).stim(o).wRect);
        end
        if n ~= numel(ClassStructures(m).frame) % not the last frame (target), fixation always ON
            Screen(WindowStructure(m).frame(n).end,'FillRect',WhiteIndex(0),AllCoordinates.fRect);
        end
        if n == 1 % the Cue frame, photodiode also ON
            Screen(WindowStructure(m).frame(n).end,'FillRect',WhiteIndex(0),[0 0 60 50]);
        end
    end
end
end