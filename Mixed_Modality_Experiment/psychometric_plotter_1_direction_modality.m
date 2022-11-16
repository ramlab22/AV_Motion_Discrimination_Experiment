function [coh, pc, fitresult, gof, fig] = psychometric_plotter_1_direction_modality(AUD_directional_probability, VIS_directional_probability, direction)

    AUD.coh = AUD_directional_probability(:,1);
    AUD.pc = AUD_directional_probability(:,2); 
    AUD.plot_data = [AUD.coh, AUD.pc]; 

    VIS.coh = VIS_directional_probability(:,1);
    VIS.pc = VIS_directional_probability(:,2); 
    VIS.plot_data = [VIS.coh, VIS.pc]; 
    
    AUD.plot_data = AUD.plot_data(~isnan(AUD.plot_data(:,2)),:); 
    VIS.plot_data = VIS.plot_data(~isnan(VIS.plot_data(:,2)),:); 

    [fitresult, gof, fig] = createFit_Weibull_1_direction_modality(AUD.plot_data(:,1), AUD.plot_data(:,2)/100, VIS.plot_data(:,1), VIS.plot_data(:,2)/100, direction); 

end