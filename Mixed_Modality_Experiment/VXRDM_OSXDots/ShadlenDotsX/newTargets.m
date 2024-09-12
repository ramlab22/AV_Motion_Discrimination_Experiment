function targets = newTargets(screenInfo,targets,targetIndex,x_position,y_position,diameter,tcolor)
% NEWTARGETS sets up targets for erasing & displaying 
%
% targets = newTargets(screenInfo,targets,targetIndex,x_position,y_position,diameter,tcolor)
%
% All input arguments can be arrays where
%       screenInfo          required input, info about the screen obtained from 
%                           [screenInfo, targets] = setupScreen(38,50,8);
%       targets             required input, structure made by setNumTargets that
%                           pre-allocatges the matrices for the targets
%       target_index:       required input, indices of targets to be set, must 
%                           be the same size as x,y,diameter and color index
%		x_position:			x_position of targets to be shown or [], row
%		y_position:			y_position of targets to be shown or [], row
%		diameter:			diameter of targets to be shown or [], row
%		tcolor:             new values for color of targets to be shown or []
%
% Examples:
%
%   Make the target structure first before calling newTargets function by
%
%       targets = setNumTargets(6);
%   
%   To create 2 new targets, first call
%
%		targets = newTargets(screenInfo, targets, [1 2], [-5 5], [0 0], [4 4],...
%           [255 255 0; 255 255 0])
%
%   and then show these targets on screen with
%
%       showTargets([1 2])
%
%   If there are 3 targets and in order to change the colors of targets 2 and 3,
%   call
%
%       targets = newTargets(screenInfo, targets, [2 3], [], [], [], ...
%           [255 255 0; 0 255 255])
%
%   Show any combination of targets by
%
%       showTargets([1 3])
% 

%	5/29/01 ... created by jig
%   6/06 ... greatly change and adapted to OSX by MKMK
%   June 2014 revised code syntax and comments by Jian Wang

if isempty(x_position)
    x_position = targets.x(targetIndex,:)';
end

if isempty(y_position)
    y_position = targets.y(targetIndex,:)';
end

if isempty(diameter)
    diameter = targets.d(targetIndex,:)';
end

center = repmat(screenInfo.center',size(x_position));

% ppd is off by a factor of 10 so that we don't send any fractions to rex
ppd = screenInfo.ppd/10;
% change the xy coordinates to pixels (y is inverted - pos on bottom, neg. on top
tar_xy = [center(1,:) + x_position * ppd; center(2,:) - y_position * ppd];

% change the diameter to pixels, make it same size as tar_xy so we can add them
diam = [diameter; diameter] * ppd;

% change from center and diameter to the corners of a box that encloses the circle 
% for use with Screen('FillOval')
tarRects = [tar_xy-diam/2; tar_xy+diam/2]';

if isempty(tcolor)
    tarColor = targets.colors(targetIndex,:);
elseif size(tcolor,1) == 1
    tarColor = repmat(tcolor,size(targetIndex,2),1);
else
    tarColor = tcolor;
end

index = 1:length(targetIndex);
targets.x(targetIndex,:) = x_position;
targets.y(targetIndex,:) = y_position;
targets.d(targetIndex,:) = diameter;
targets.rects(targetIndex,:) = tarRects(index,:);
targets.colors(targetIndex,:) = tarColor(index,:);


