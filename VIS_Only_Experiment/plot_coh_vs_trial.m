function fig = plot_coh_vs_trial(dataout, save_name)
hold on 
    trial_num = cell2mat(dataout(2:end,1));
    coh_level = cell2mat(dataout(2:end,8)); 
    
    fig = figure( 'Name', 'Coherence vs Trial Number') ;
    %fig.Position = [850 1240 1550 500];
    plot(trial_num, coh_level)
    
    
    xlabel('Trial Number');
    ylabel('Coherence Level');
    title(sprintf('VIS Coherence Level vs. Trial Number\n%s', save_name), 'Interpreter', 'none');
    

 

end