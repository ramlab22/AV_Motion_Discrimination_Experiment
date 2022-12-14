function fig = plot_coh_vs_trial_modalities(AUD_dataout, VIS_dataout, save_name)

    AUD_trial_num = cell2mat(AUD_dataout(2:end,1));
    AUD_coh_level = cell2mat(AUD_dataout(2:end,8)); 
    VIS_trial_num = cell2mat(VIS_dataout(2:end,1));
    VIS_coh_level = cell2mat(VIS_dataout(2:end,8)); 

    fig = figure();
    tiledlayout(2,1)

    %Top Plot AUD
    ax1 = nexttile; 
    plot(AUD_trial_num, AUD_coh_level);
    xlabel('Trial Number');
    ylabel('Coherence Level');
    title(sprintf('AUD Coherence Level vs. Trial Number\n%s', save_name), 'Interpreter', 'none')

    %Bottom Plot VIS
    ax2 = nexttile; 
    plot(VIS_trial_num, VIS_coh_level);
    xlabel('Trial Number');
    ylabel('Coherence Level');
    title(sprintf('VIS Coherence Level vs. Trial Number\n%s', save_name), 'Interpreter', 'none')

    
end