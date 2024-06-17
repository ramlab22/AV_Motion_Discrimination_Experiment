function [fig]=poster_quality_figure(varargin)
    if isempty(varargin)
        % If no figures are specified, find all open figure handles
        figHandles = findall(groot, 'Type', 'figure');
    else
        % Use the provided figure handles
        figHandles = [varargin{:}];
    end
fig=gcf;
resizeFigures(fig);

grid off;
 ax = gca;
 ax.FontSize = 30;
 set(findobj('Type', 'line'),'LineWidth',7)
  set(findobj('Type', 'line'),'MarkerSize',25)

 % Find all scatter plot objects in the figure
scatters = findobj(fig, 'Type', 'Scatter');

% Loop through each scatter plot object and double the size of the markers
for i = 1:length(scatters)
    scatters(i).SizeData = scatters(i).SizeData * 2 ;
    scatters(i).LineWidth = scatters(i).LineWidth * 2;

end