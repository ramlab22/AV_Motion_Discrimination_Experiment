function plot_combodata(xData_matrix, yData_matrix, x_matrix, p_matrix, fileNames)
    %PLOTALLDATA Plots extracted data from multiple .fig files in a single plot.
    %
    %   PLOTALLDATA(AUD_xData_matrix, AUD_yData_matrix, x_matrix, AUD_p_matrix, fileNames)
    %
    %   Inputs:
    %       AUD_xData_matrix - n x length(AUD_xData) matrix containing AUD_xData from all files.
    %       AUD_yData_matrix - n x length(AUD_yData) matrix containing AUD_yData from all files.
    %       x_matrix - n x length(x) matrix containing x data from all files.
    %       AUD_p_matrix - n x length(AUD_p) matrix containing AUD_p data from all files.
    %       fileNames - 1 x n cell containing an ordered list of all the .fig file names.
    %
    %   Example:
    %       plotAllData(AUD_xData_matrix, AUD_yData_matrix, x_matrix, AUD_p_matrix, fileNames);
    %

    % Number of files
    n = size(xData_matrix, 1);

    % Generate distinct colors for each file
    colors = lines(n);

    % Create a figure
    figure;
    set(0,'DefaultLegendInterpreter','none')
    % Loop through each file's data and plot
    for i = 1:n
        % Plot xdata and AUD_yData (responses)
        plot(xData_matrix(i, :), yData_matrix(i, :), 'o', 'Color', colors(i, :), 'LineWidth',2.5,'DisplayName', [fileNames{i} ' (responses)']);
        hold on;

        % Plot x and AUD_p data (Norm-CDF)
        plot(x_matrix(i, :), p_matrix(i, :), '-', 'Color', colors(i, :), 'LineWidth',2.5,'DisplayName', [fileNames{i} ' (Norm-CDF)']);
    end

    % Add labels and legend
    xlabel('Coherence ((+)Rightward, (-)Leftward)');
    ylabel('% Rightward Response');
    title('Ba AUD: 26 degrees/s, 834ms');
    legend('Location', 'best');
    ax = gca; 
    ax.FontSize = 16;
    % Hold off to stop adding to the current plot
    hold off;
end
