function [window, f, r, WindowStructure, AllCoordinates] = CreateWindowStruct(Display, vstruct, TrialInfo)

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