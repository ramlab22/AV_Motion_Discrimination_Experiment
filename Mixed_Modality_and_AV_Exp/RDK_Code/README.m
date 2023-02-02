%
%
% This is the latest version (v2.0) of Variable Coherence Random Dot Motion code 
% for visual experiments on Mac OS X. Tests are conducted on Mac OS X 10.9 with 
% Matlab R2014b and PsychToolBox v3.0.11.
%
% PsychToolBox v3.0.11 does NOT read keyboard input connected through thunderbolt. 
% All keyboards must be connected through USB port. 
%
%
% A list of demo files include:
%
% Demo1.m is a good place to start to see how the targets and dots are called. 
% It puts multiple targets on the screen, changes them and then displays the dots. 
%
% Demo2.m demonstrates how to set targets in a place a certain distance from 
% either the fixation or the aperture and in the direction of the possible 
% motions. This was created mostly to test moving the dots in relation to the 
% targets/fixation.
%
% dotsOnlyDemo.m shows simple script for testing dots (dotsX).
%
% keyDots.m is an experiment using keypresses (including optional correction trial 
% loops, and a few other bells and whistles). 
%
%
% The contents.m file lists everything in the directory. The code is, in general, 
% fairly well documented, although probably needs some updating. The dots are 
% created in the same way as in the shadlenDots8 code, but the code has been 
% changed pretty drastically to work with the OS X Psychtoolbox. The code has 
% been tested, but not rigorously. Appreciate any feedback.
%
%
% A note about how the dots are plotted:
%
% Dots are plotted randomly and 3 sets of dots are created to plot in round-robin. 
% For each set of dots, certain percentage of dots (according to the given 
% coherence) are designated to move in the direction of motion. Once the first 
% set of dots is plotted, in the second set of dots, some will be replotted 
% randomly, and others will be replotted a distance away (determined by the size
% of the screen, the viewing distance, the speed of the dots, and the refresh 
% rate of the screen) in the direction of motion.
%
% How long they continue to appear (always every third frame) moving in the 
% direction of motion is also determined by the coherence. No dot ever appears 
% for more than one frame at a time.
%
%
% A note about why we implemented wrap-around of the dots:
% 
% First, it is important to understand that this really affects only dots
% at high coherences. Only a dot that is undergoing displacement in motion
% wraps around. The dots that are appearing in random locations can appear
% anywhere. They have a probability (governed by coherence) of living
% another video frame by being displaced in motion, so at low coherences,
% the dot would have to appear at the edge of the aperture on its first
% frame to live long enough to show up on the other side. Also, because we
% are using a circlular aperture (governs what is seen) inside of the
% square aperture (defines the boundaries for dots), the dot has to first
% appear in the center of the edge, and be a dot that has been randomly
% chosen to move in the direction of motion. The dots are not wrapped
% around in the same sense as a periodic boundary condition, instead, when
% a dot disappears on one side, it can reappear anywhere along the opposite
% boundary. This means that, at low coherences, the dot would have to
% reappear, by random chance, in the center of the opposite side for it to
% be seen at all (otherwise its lifetime dies out before it enters back
% into the circular aperture). This is extremely unlikely.
% 
% So, I hope I have shown that the wrap-around affects dots at high
% coherences only. The reason for introducing the wrap-around is to
% suppress a spatial cue that would arise at high coherences (e.g., > 75%).
% At high coherences, there is a pile-up of moving dots in the direction of
% motion, because now the lifetime of the dots is longer, and more of them
% are moving in one direction, but only half of the new dots are appearing
% in the side opposite the direction of motion. We have tried to minimize
% the spatial cue from the wrap-around itself, by the randomization of the
% plotting of these dots along the edge. This randomization also produces a
% random time between the loss of a moving dot at the right edge (for
% example) of the circular aperture and the reapearance of the dot at the
% left most edge of the circular aperture, since, depending on where it
% reappeared, it would have further to travel before it returned into view
% in the circular aperture. The effect can be reduced further by making the
% square aperture larger than the diameter of the circular aperture
% (although this has not been implemented presently in the code). Finally,
% once you realize that this wrap around only occurs at very high
% coherence, where the path a dot traverses is often a large fraction of
% the aperture. It makes sense that some dots should have long paths
% beginning at the leading edge of the aperture.
%
%
% Maria Mckinley      Feb 2007      parody@u.washington.edu
% Updated June 2014


