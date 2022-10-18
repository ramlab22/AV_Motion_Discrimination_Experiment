function targets = setNumTargets(numTargets)
% SETNUMTARGETS creates the targets structure
%
% targets = setNumTargets(numTargets)
%
% By default, the number of targets is 8 and the target structure fields are 
% rects, colors, x, y, d
%

% Copyright MKMK July, 2006

if nargin < 1 || isempty(numTargets)
	numTargets = 8;
end

targets.rects = zeros(numTargets, 4);
targets.colors = zeros(numTargets, 3);
targets.x = zeros(numTargets, 1);
targets.y = zeros(numTargets, 1);
targets.d = zeros(numTargets, 1);
