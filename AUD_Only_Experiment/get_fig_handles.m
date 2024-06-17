function [h,handles,labels] = get_fig_handles(data,fig_color,markerLineWidth,labels,handles,figlabel)
%GET_FIG_HANDLES Generates figure handles for scatter and line plots.
%   [h, handles, labels] = GET_FIG_HANDLES(data, fig_color, markerLineWidth, labels, handles, figlabel)
%   generates handles for scatter and line plots from the provided data.
%
%   INPUTS:
%       data - Struct containing fields 'scatter' and 'line'. Each field
%              should be a struct array with fields 'x', 'y', and 'sizes' (for scatter).
%       fig_color - Color specification for the plot elements.
%       markerLineWidth - Line width for the scatter plot markers.
%       labels - Cell array to store plot labels.
%       handles - Array to store plot handles.
%       figlabel - Label to be added to each plot.
%
%   OUTPUTS:
%       h - Handle to the last plotted object.
%       handles - Array of handles to all plotted objects.
%       labels - Cell array of labels corresponding to the plotted objects.


    markerSizeScale = 1;  % Scale factor for marker sizes

    % Iterate through scatter data and create scatter plots
    for i = 1:length(data.scatter)
        h = scatter(data.scatter(i).x, data.scatter(i).y, data.scatter(i).sizes * markerSizeScale, fig_color, 'LineWidth', markerLineWidth);
        handles = [handles, h];  % Append scatter plot handle to handles array
        labels = [labels, sprintf('Resps: %s', figlabel)];  % Append label for the scatter plot
    end

    % Iterate through line data and create line plots
    for i = 1:length(data.line)
        if length(data.line(i).x) > 2
            h = plot(data.line(i).x, data.line(i).y, 'Color', fig_color, 'LineStyle', '-', 'LineWidth', 4);
            handles = [handles, h];  % Append line plot handle to handles array
            labels = [labels, sprintf('CDF: %s', figlabel)];  % Append label for the line plot
        end
    end
end
