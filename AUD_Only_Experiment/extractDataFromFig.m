% Function to store extracted data and properties
function data = extractDataFromFig(filename)
    open(filename);
    ax = gca;
    children = ax.Children;

    data = struct();
    data.scatter = [];
    data.line = [];
    data.text = {};

    for i = 1:length(children)
        child = children(i);
        if isa(child, 'matlab.graphics.chart.primitive.Scatter')
            data.scatter(end+1).x = child.XData;
            data.scatter(end).y = child.YData;
            data.scatter(end).sizes = child.SizeData;
            data.scatter(end).color = child.CData(1, :); % Assuming uniform color
        elseif isa(child, 'matlab.graphics.chart.primitive.Line')
            data.line(end+1).x = child.XData;
            data.line(end).y = child.YData;
            data.line(end).color = child.Color;
        elseif isa(child, 'matlab.graphics.primitive.Text')
            data.text{end+1} = child.String;
        end
    end
    close(gcf); % Close the opened figure
end
