function [window, ifi, screenXpixels, screenYpixels, xCenter, yCenter] = setupPsychtoolbox()

    % Setup Psychtoolbox
    PsychDefaultSetup(2);
    screenNumber = 2;
    black = BlackIndex(screenNumber);
    [screenXpixels, screenYpixels] = Screen('WindowSize', screenNumber);
    [xCenter, yCenter] = RectCenter([0 0 screenXpixels screenYpixels]);
    [window, ~] = PsychImaging('OpenWindow', screenNumber, black);
    Screen('Flip', window);
    ifi = Screen('GetFlipInterval', window);

end
