function [coh, pc, fitresult, gof, fig] = psychometric_plotter_1_direction (directional_probability, direction)

    coh = directional_probability(:,1);
    pc = directional_probability(:,2); 
    plot_data = [coh, pc]; 
    
    plot_data = plot_data(~isnan(plot_data(:,2)),:); 
    [fitresult, gof, fig] = createFit_Weibull_1_direction(plot_data(:,1), plot_data(:,2)/100, direction); 

end