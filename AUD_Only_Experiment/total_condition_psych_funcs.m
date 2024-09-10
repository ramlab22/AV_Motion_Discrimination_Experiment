function [fig]=total_condition_psych_funcs(mat_file)
%get all the psychometric functions for each day/file for a given condition
%on one figure to compare functions across days and weed out bad days 
load(mat_file);
[data_save_path, save_name] = deduce_analysis_save_info(mat_file);
fig = figure('Name', 'condition psych funcs');
n_days=size(date_key,2);
[data_save_path, save_name] = deduce_analysis_save_info(Path);
try
    scatter_obj=scatter(x_scatter{1}, y_scatter{1}, 'LineWidth', 2,'HandleVisibility', 'off');
catch
   scatter_obj= scatter(x_scattervals{1}, y_scattervals{1}, 'LineWidth', 2,'HandleVisibility', 'off');

end
    hold on;
    dot_colors = scatter_obj.CData;

    plot(x_curvevals{1}, y_curvevals{1},  'LineWidth', 2.5,'Color',dot_colors);
    
    % Set plot labels and styling
    title(sprintf('Psych. Func. L&R\n%s', save_name), 'Interpreter', 'none');
    xlabel('Coherence ((+)Rightward, (-)Leftward)', 'Interpreter', 'none');
    ylabel('Proportion Rightward Response', 'Interpreter', 'none');
  %  xlim([-max(xData(:)) max(xData(:))]);
    ylim([0 1.2]);
    grid on;
    ax = gca; 
    ax.FontSize = 22;
    legend_values=string(date_key{1});
for i_days=2:n_days
    scatter_obj=scatter(x_scattervals{i_days}, y_scattervals{i_days}, 'LineWidth', 2,'HandleVisibility', 'off');
    dot_colors = scatter_obj.CData;

    hold on;
    plot(x_curvevals{i_days}, y_curvevals{i_days},  'LineWidth', 2.5,'Color', dot_colors);
    legend_values(i_days,1)=string(date_key{i_days});
end
legend(legend_values,...
        'Location', 'NorthWest', 'Interpreter', 'none');
 poster_quality_figure();
