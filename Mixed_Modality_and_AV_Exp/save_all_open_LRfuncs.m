
function [] = save_all_open_LRfuncs(Path, totalfiles_names)
% SAVE_ALL_OPEN_LRFUNCS Saves all open figures that do not have 'LEFT ONLY' or 'RIGHT ONLY' in their name.
%
% Parameters:
%   Path (string): The destination folder where the figures should be saved.
%   totalfiles_names (cell array of strings): An array containing the names that should be assigned to the saved figures. 
%                                             The names are used in reverse order to name the figures.
%
% This function iterates through all open figures and saves those whose names do not contain the phrases 
% 'LEFT ONLY' or 'RIGHT ONLY' to the specified path with names from totalfiles_names in reverse order.

% Find all figure objects
FigList = findobj(allchild(0), 'flat', 'Type', 'figure');

% Get the number of file names to be used
fignum = length(totalfiles_names);

% Loop through each figure object
for iFig = 1:length(FigList)
  % Get the handle to the current figure
  FigHandle = FigList(iFig);
  
  % Check if the figure name does not contain 'LEFT ONLY' or 'RIGHT ONLY'
  if ~contains(FigHandle.Name, 'LEFT ONLY') && ~contains(FigHandle.Name, 'RIGHT ONLY')
      % Get the name to be used for the current figure from the totalfiles_names array
      FigName = totalfiles_names{fignum};
      
      % Set the current figure to be FigHandle
      set(0, 'CurrentFigure', FigHandle);
      
      % Save the current figure to the specified path with the
      % corresponding file name
      savefig(fullfile(Path, [FigName '.fig']));
      
      % Decrement the file name index
      fignum = fignum - 1;
  end
end
end
