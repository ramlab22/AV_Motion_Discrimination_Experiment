function dotInfo = createMinDotInfo(inputtype)
% CREATEMINDOTINFO creates the default dotInfo structure
%
% dotInfo = createDotInfo(inputtype)
%
% where inputtype 1 is for using keyboard and 2 for using touchscreen/mouse.
% dotInfo only includes fields necessary to run dots themselves, to run one of 
% the paradigms see also createDotInfo. This will save the structure in the file 
% dotInfoMatrix or return it.
%
% Warning: be careful when using this createMinDotInfo code, dots may be
% displayed not in the intent way.

% Copyright June 2006 MKMK

if nargin < 1
    %inputtype = 1; % use keyboard
    inputtype = 2; % use touchscreen
end

% For each set of dots, all the information of "apertureXYD, speed, coh, dir,
% maxDotTime" must be provided.
dotInfo.numDotField = 2;
dotInfo.apXYD = [-50 0 50; 50 0 50]; 
%dotInfo.apXYD = [150 0 50; -150 0 50];  
dotInfo.speed = [50 50];
dotInfo.coh = [512 512];
dotInfo.dir = [0 90];
dotInfo.maxDotTime = [3 3];

% [1 fixed duration / 2 reaction time,  1 hold on / 2 hold off] 
% where hold on means subject has to hold fixation during task.
dotInfo.trialtype = [1 1];
dotInfo.dotColor = [255 255 255]; % default white dots
dotInfo.dotSize = 2; % dot size in pixels

% dotInfo.auto
% column 1: 1 to set manually, 2 to use fixation as center point, 3 to use aperture
% as center
% column 2: 1 to set coherence manually, 2 random, 3 correction mode
% column 3: 1 to set direction manually, 2 random
dotInfo.auto = [3 2 2];

%%%%%%% CODES BELOW HERE SHOULD GENERALLY NOT BE CHANGED! %%%%%%%

dotInfo.maxDotsPerFrame = 150; % Test by trial and error depending on graphics card
% Use test_dots7_noRex to find out when we miss frames. The dots routine tries 
% to maintain a constant dot density, regardless of aperture size.  However, it 
% respects MaxDotsPerFrame as an upper bound.

% possible keys active during trial
dotInfo.keyEscape = KbName('escape');
dotInfo.keySpace = KbName('space');
dotInfo.keyReturn = KbName('return');

if inputtype == 1
    dotInfo.keyLeft = KbName('leftarrow');
    dotInfo.keyRight = KbName('rightarrow');
else
    mouse_left = 1;
    mouse_right = 2;
    dotInfo.mouse = [mouse_left, mouse_right];
end

if nargout < 1
    save dotInfoMatrix dotInfo
end
