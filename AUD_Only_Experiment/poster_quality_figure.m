function [fig] = poster_quality_figure(varargin)
    % POSTER_QUALITY_FIGURE Adjusts figure properties for high-quality posters.
    %
    % This function modifies the appearance of figures to make them suitable
    % for high-quality poster presentations. It adjusts the font size, line
    % width, and marker size for various plot elements within the figure.
    %
    % Usage:
    %   poster_quality_figure()
    %       Modifies all open figure handles.
    %   poster_quality_figure(fig1, fig2, ...)
    %       Modifies the specified figure handles.
    %
    % Input:
    %   varargin - Variable input arguments representing figure handles.
    %              If no input is provided, all open figure handles are modified.
    %
    % Output:
    %   fig - Handle to the current figure.
    %
    % The function performs the following adjustments:
    %   - Sets the font size of the current axis to 30.
    %   - Sets the line width of all line objects to 7.
    %   - Sets the marker size of all line objects to 25.
    %   - Doubles the size of markers and line width of scatter plot objects.
    %   - Doubles the marker size (if applicable) and line width of errorbar plot objects.
    %
    % Example:
    %   fig1 = figure;
    %   plot(rand(10,1));
    %   poster_quality_figure(fig1);
    %
    % Note:
    %   The function `resizeFigures` is assumed to be defined elsewhere and
    %   is used to resize the figures as needed.
    %
    % Author: Your Name
    % Date: YYYY-MM-DD

    if isempty(varargin)
        % If no figures are specified, find all open figure handles
        figHandles = findall(groot, 'Type', 'figure');
    else
        % Use the provided figure handles
        figHandles = [varargin{:}];
    end
    fig = gcf;

    grid off;
    ax = gca;
    ax.FontSize = 30;
    set(findobj('Type', 'line'), 'LineWidth', 7)
    set(findobj('Type', 'line'), 'MarkerSize', 25)

    % Find all scatter plot objects in the figure
    scatters = findobj(fig, 'Type', 'Scatter');

    % Loop through each scatter plot object and double the size of the markers
    for i = 1:length(scatters)
        scatters(i).SizeData = scatters(i).SizeData * 2;
        scatters(i).LineWidth = scatters(i).LineWidth * 2;
    end

    % Find all errorbar plot objects in the figure
    errorbars = findobj(fig, 'Type', 'Errorbar');

    % Loop through each errorbar plot object and double the marker size and line width
    for i = 1:length(errorbars)
        errorbars(i).LineWidth = errorbars(i).LineWidth * 2;
        if isprop(errorbars(i), 'MarkerSize')
            errorbars(i).MarkerSize = errorbars(i).MarkerSize * 2;
        end
    end
        resizeFigures();

end
