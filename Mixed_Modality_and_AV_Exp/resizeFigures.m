function resizeFigures(varargin)
   % RESIZEFIGURES Resizes specified figure handles to fit the screen.
   % This function adjusts the size of one or more MATLAB figure windows to fill the entire screen.
   % If no figure handles are specified as input, it resizes all currently open figures.
   %
   % Usage:
   %   RESIZEFIGURES() - Resizes all open figures to fit the screen size.
   %   RESIZEFIGURES(h1, h2, ...) - Resizes the specified figures (h1, h2, ...)
   %                                to fit the screen size.
   %
   % Inputs:
   %   varargin - (Optional) Comma-separated figure handles. If omitted, the function
   %              targets all open figures.
   %
   % Example:
   %   % Resize all open figures
   %   resizeFigures();
   %
   %   % Resize specific figures with handles h1 and h2
   %   resizeFigures(h1, h2);
   %
   % See also FIGURE, GET, SET.
   % Get the size of the screen
   screenSize = get(0, 'ScreenSize');
   if isempty(varargin)
       % If no figures are specified, find all open figure handles
       figHandles = findall(groot, 'Type', 'figure');
   else
       % Use the provided figure handles
       figHandles = [varargin{:}];
   end
   % Loop through each figure handle
   for k = 1:length(figHandles)
       if ishandle(figHandles(k))
           % Set each figure to use the full screen size
           set(figHandles(k), 'Units', 'pixels');
           set(figHandles(k), 'OuterPosition', screenSize);
       else
           warning('Invalid figure handle provided.');
       end
   end
end
