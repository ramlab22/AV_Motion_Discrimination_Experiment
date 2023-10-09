function [coh, pc, fig] = psychometric_plotter_1_direction (directional_probability, direction, dotInfo, save_name)

    coh = directional_probability_visual(:,1);
    pc = directional_probability_visual(:,2); 
    plot_data = [coh, pc]; 
    
    plot_data = plot_data(~isnan(plot_data(:,2)),:); 
    [fig] = createFit_NormCDF_1_direction(plot_data(:,1), plot_data(:,2)/100, direction, dotInfo, save_name); 

end