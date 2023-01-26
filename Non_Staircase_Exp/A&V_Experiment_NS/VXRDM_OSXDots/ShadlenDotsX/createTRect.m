function tarRects = createTRect(target_array, screenInfo)
% CREATETRECT creates the display rect for the list of targets
%
% tarRects = createTRect(target_array, screenInfo)
%
%	Argument target_array is (n,3) array where the columns are [x_position,
%   y_position,diameter].
%

% 1/17/06  RK modified it for Windows operating system
% July 2006 MKMK modified it for OSX
% do no error checking -- assume it's been done already

xy = target_array(:,1:2);
diameter = target_array(:,3);

center = repmat(screenInfo.center, size(xy(:,1)));

% ppd is off by a factor of 10 so that we don't send any fractions to rex
ppd = screenInfo.ppd/10;

% change the xy coordinates to pixels (y is inverted - pos on bottom, neg.
% on top
tar_xy = [center(:,1)+xy(:,1)*ppd center(:,2)-xy(:,2)*ppd];

% change the diameter to pixels, make it same size as tar_xy so we can add
% them
diam = repmat(diameter, size(tar_xy(1,:))) * ppd;

% now need to change from center and diameter to the corners of a box that
% would enclose the circle for use with Screen('FillOval')
tarRects = [tar_xy-diam/2 tar_xy+diam/2];
