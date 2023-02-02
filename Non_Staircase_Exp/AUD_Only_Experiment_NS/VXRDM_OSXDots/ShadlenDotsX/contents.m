%
% Contents - OSX dots without clut (using DrawDots)
%
%
% Demos:
%
% Demo1 -
%   shows how the targets and dots are called. It puts multiple targets on the 
%   screen, changes them and then displays the dots. 
%
% Demo2 -
%   demonstrates how to set targets in a place a certain distance from either the 
%   fixation or the aperture and in the direction of the possible motions. This 
%   was created mostly to test moving the dots in relation to the targets/fixation.
%
% dotsOnlyDemo -
%   shows simple script for testing dots (dotsX).
%
% keyDots - 
%   is an experiment using keypresses (including optional correction trial loops, 
%   and a few other bells and whistles). 
%
%
% Functions:
%
% closeExperiment -
%   closes the screen, returns priority to zero, starts the update process,
%   and shows the cursor.
%
% createDotInfo -
%   dotInfo = createDotInfo(screenInfo) makes the structure dotInfo, which
%   contains all of the information necessary to plot the dots - used both
%   with and without clut. this version has all kinds of extra stuff for
%   using my touchscreen/mouse or keypress routines.
%
% createMinDotInfo -
%   dotInfo = createMinDotInfo(screenInfo) makes the structure dotInfo, with
%   the minimum amount of info to plot just dots.
%
% createSound
%   [freq beepmatrix] = createSound
%   makes the matrix to create the same sound used in the human experiments
%   on the eyelink for feedback
%
% createTRect -
%   tarRects = createTRect(target_array, screenInfo) takes a list of target
%   parameters: x,y,diameter, in visual degrees, and creates a target array
%   for use with FillOval or FillRect
%
% dotgui -
%   makes a gui to manipulate the config file (dotInfoMatrix.mat that holds
%   dotInfo).
%
% dotsX -
%   function that actually makes the random dot patches - uses the Screen
%   BlendFunction to make the mask.
%
% dotsXnomask -
%   function that makes the random dot patches in a square (no mask). Not
%   used by any other files in the directory currently.
%
% makeDotTargets -
%   makes targets that are coordinated with dot position or fixation.
%
% makeInterval -
%   interval = makeInterval(typeInt,minNum,maxNum,meanNum)
%   creates a distribution of numbers, either uniform or exponential (or
%   returns the same distribution minNum)
%
% newTargets -
%   function to create/move/change targets. based on targets in original dots
%   code, created to be versatile and separate from dots code. DemoOSX shows
%   how to use it. 
%
% openExperiment -
%   screenInfo = openExperiment(monWidth, viewDist, curScreen)
%   Sets the random number generator, opens the screen, gets the refresh
%   rate, determines the center and ppd, and stops the update process 
%
% randomDotTrial -
% determines if trials are being randomly chosen, and then picks from
% random distribution
%
% setNumTargets -
%   creates the structure where the target information is kept. Should be
%   called before newTargets.
% 
% showTargets -
%   function that shows whichever targets are requested (by way of their
%   index number)
%
