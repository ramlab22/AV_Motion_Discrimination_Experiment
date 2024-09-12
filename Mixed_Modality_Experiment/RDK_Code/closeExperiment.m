function closeExperiment
% CLOSEEXPERIMENT closes screen, returns priority to 0, starts the update process,
%                 and shows the cursor.

Priority(0);
Screen('CloseAll');
ShowCursor; % Show cursor again, if it has been disabled.