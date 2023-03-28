function [Figdata, hFig, hAxes, hLine] = InitEyeDisplay
btnColor=get(0,'DefaultUIControlBackgroundColor');

% Code for the live eye tracker Graph - IN PROGRESS 

% Position the figure on right extended screen at the bottom
screenUnits=get(0,'Units');
screenSize=get(0,'ScreenSize');
set(0,'Units',screenUnits);
figWidth=640;
figHeight=512;
figPos=[0 40  ...
    figWidth                    figHeight];

% Create the figure window.
hFig=figure(...
    'Color'             ,btnColor                 ,...
    'IntegerHandle'     ,'off'                    ,...
    'DoubleBuffer'      ,'on'                     ,...
    'MenuBar'           ,'none'                   ,...
    'HandleVisibility'  ,'on'                     ,...
    'Name'              ,'Eye Position'  ,...
    'Tag'               ,'Eye Position'  ,...
    'NumberTitle'       ,'off'                    ,...
    'Units'             ,'pixels'                 ,...
    'Position'          ,figPos                   ,...
    'UserData'          ,[]                       ,...
    'Colormap'          ,[]                       ,...
    'Pointer'           ,'arrow'                  ,...
    'Visible'           ,'off'                     ...
    );

% Create target,fixation window,eye position xy plot

hAxes(1) = axes(...
    'Position'          , [0.08 0.3 0.55 0.55], ...
    'Parent'            , hFig, ...
    'XLim'              , [-6 6], ...
    'YLim'              , [-6 6] ...
    );
i=1:33;
Figdata.xcoord(i)=cos(i*pi/16);
Figdata.ycoord(i)=sin(i*pi/16);
hLine(3) = plot(1*Figdata.xcoord,1*Figdata.ycoord,'Parent',hAxes(1)); % fixation window
hLine(2) = line('XData',0,'YData',0,'marker','+');  % eye position
hLine(1) = line('XData',0,'YData',0,'marker','s'); % stimulus position
xlabel('X');
ylabel('Y');
xlim([-6 6]);
ylim([-6 6]);


% Create Eye X subplot.
hAxes(2) = axes(...
    'Position'          , [0.6700 0.650 0.30 0.15],...
    'Parent'            , hFig,...
    'XLim'              , [0 400],...
    'YLim'              , [-10 10]...
    );
hLine(4) = plot(200,0);
title('Eye X');
xlim([0 400]);
ylim([-10 10]);


% Create Eye Y subplot.

hAxes(3) = axes(...
    'Position'          , [0.670 0.350 0.30 0.15],...
    'Parent'            , hFig,...
    'XLim'              , [0 400],...
    'YLim'              , [-10 10]...
    );
hLine(5) = plot(0,0);
% Label the plot.
xlabel('Time');
title('Eye Y');
xlim([0 400]);
ylim([-10 10]);

Figdata.figure = hFig;
Figdata.axes = hAxes;
Figdata.line = hLine;
set(hFig,'Visible','on');
end

function UpdateEyeDisplay(StimulusCoordinates, FixWindow, FixPosition, vstruct, hLine,visability)
xStimDisplay = (((StimulusCoordinates(1,1)+StimulusCoordinates(1,3))/2)-(vstruct.res(1)/2))*vstruct.degpix(1);
xWindowPosition = (((FixPosition(1,1)+FixPosition(1,3))/2)-(vstruct.res(1)/2))*vstruct.degpix(1);
yStimDisplay = ((((StimulusCoordinates(1,2)+StimulusCoordinates(1,4))/2)-(vstruct.res(2)/2))*vstruct.degpix(2))*-1;
yWindowPosition = ((((FixPosition(1,2)+FixPosition(1,4))/2)-(vstruct.res(2)/2))*vstruct.degpix(2))*-1;
xWindowDisplay = FixWindow(1,:)+ xWindowPosition;
yWindowDisplay = FixWindow(2,:)+ yWindowPosition;
set(hLine(1),'XData',xStimDisplay,'YData',yStimDisplay,'Visible',visability);
set(hLine(3),'XData',xWindowDisplay,'YData',yWindowDisplay,'Visible',visability);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [eyeX, eyeY] = DisplayEye(Display, hAxes, hLine)
global trial_eye_data
% trial_eye_data
% eye=inputSingleScan(ai);
if isempty(trial_eye_data)
    eye =[0, 0];
else
    eye = trial_eye_data(end, :);
    
end
eyeX = (((eye(1,1)-Display.Xscalecenter)*Display.Xscale));
eyeY = (((eye(1,2)-Display.Yscalecenter)*Display.Yscale));
set(hAxes(1), 'XLim', [-20 20],'YLim', [-20 20]);
set(hLine(2), 'XData', eyeX, 'YData', eyeY); % eye position
drawnow
end