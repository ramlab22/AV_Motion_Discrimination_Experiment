function showTargets(screenInfo, targets, targetIndex)
% SHOWTARGETS Displays the targets identified by targetIndex in the structure targets 
%
% showTargets(screenInfo, targets, targetIndex)
%
%	where
%   screenInfo  created by openExperiment, has screen number and other info,
%   targets     initially created by setNumTargets and then targets are set using 
%               newTargets,
%   targetIndex number of targets to be shown (if [] or no targetIndex given, 
%               erase everything)
%
%	Examples:
%	To show a single target (#1) at its current position & color
%
%		showTargets(screenInfo, targets, 1)
%
%   To change a target, first call newTargets and then showTargets
%
%       targets = newTargets(screenInfo,targets,[2 3],[],[],[],[255 255 0; 0 255 255])
%       showTargets(screenInfo, targets, [1 2 3])
%

%   created by MKMK July, 2006

% If no index provided, all targets will be erased
if nargin < 3
    targetIndex = [];
end

% Loop through each target to be shown & draw it
for i = targetIndex
    if ~any(targets.rects(i,:))        
        warning('index %d is not a valid target\n',i);
        return
    end
	Screen('FillOval', screenInfo.curWindow, targets.colors(i,:), targets.rects(i,:));
end

% Draw all the targets
Screen('DrawingFinished',screenInfo.curWindow, screenInfo.dontclear);
Screen('Flip', screenInfo.curWindow, 0, screenInfo.dontclear);
