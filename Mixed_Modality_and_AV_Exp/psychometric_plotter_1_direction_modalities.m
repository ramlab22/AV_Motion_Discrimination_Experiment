function [fig] = psychometric_plotter_1_direction_modalities(AUD_directional_probability,...
                                                             VIS_directional_probability,...
                                                             AV_directional_probability,...
                                                             direction,...
                                                             audInfo, dotInfo, AVInfo, save_name)

    AUD.coh = AUD_directional_probability(:,1);
    AUD.pc = AUD_directional_probability(:,2); 
    AUD.plot_data = [AUD.coh, AUD.pc]; 

    VIS.coh = VIS_directional_probability(:,1);
    VIS.pc = VIS_directional_probability(:,2); 
    VIS.plot_data = [VIS.coh, VIS.pc]; 

    AV_aud.coh = AVInfo.coherences_aud';
    AV_aud.pc = AV_directional_probability(:,2); 
    AV_aud.plot_data = [AV_aud.coh, AV_aud.pc]; 

    AV_vis.coh = AVInfo.coherences_dot';
    AV_vis.pc = AV_directional_probability(:,2); 
    AV_vis.plot_data = [AV_vis.coh, AV_vis.pc]; 
    
    AUD.plot_data = AUD.plot_data(~isnan(AUD.plot_data(:,2)),:); 
    VIS.plot_data = VIS.plot_data(~isnan(VIS.plot_data(:,2)),:); 
    AV_aud.plot_data = AV_aud.plot_data(~isnan(AV_aud.plot_data(:,2)),:);
    AV_vis.plot_data = AV_vis.plot_data(~isnan(AV_vis.plot_data(:,2)),:);

    [fig] = createFit_NormCDF_1_direction_modalities(AUD.plot_data(:,1), AUD.plot_data(:,2)/100,...
                                                     VIS.plot_data(:,1), VIS.plot_data(:,2)/100,...
                                                     AV_aud.plot_data(:,1), AV_aud.plot_data(:,2)/100,...
                                                     AV_vis.plot_data(:,1), AV_vis.plot_data(:,2)/100,...
                                                     direction,...
                                                     audInfo, dotInfo, AVInfo, save_name); 

end