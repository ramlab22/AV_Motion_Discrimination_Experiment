function fig = plot_unisensory_accuracy_vs_trial(dataout, save_name,interval_val,condition)
%plot the cumulative accuracy of responses over the course of the block to
%visualize performance for single modality conditions (aud only or v only)
    %condition: 1=visual, 2=auditory, 3=AV
    [accuracy_vs_trial_data_filename] = get_accuracy_vs_trial_data(dataout, save_name,interval_val)
    current_folder=pwd;
    condition_list={'VIS','AUD','AV'};
    load(sprintf('%s/%s',current_folder,accuracy_vs_trial_data_filename));
    delete(sprintf('%s/%s.mat',current_folder,accuracy_vs_trial_data_filename));
    fig = figure();
    %fig.Position = [850 1240 1550 500];
    if condition==1
        plot(cumulative_accuracy(:,1), cumulative_accuracy(:,2),'b','LineWidth',2.5);

    else
        plot(cumulative_accuracy(:,1), cumulative_accuracy(:,2),'r','LineWidth',2.5);
    end
    hold on
    plot(interval_accuracy(:,1),interval_accuracy(:,2),'g*--','LineWidth',2,'MarkerSize',10);
    plot(cumulative_accuracy(:,1), trial_coherences*100,'k','LineWidth',1.5);
    ax=gca;
    ax.FontSize=19;
    set(ax,'XTick',[0:(interval_val*2):cumulative_accuracy(n_responses,1)]);
    ylim([0,100]);
    xlim([0,cumulative_accuracy(n_responses,1)]);
    legend('cumulative % accuracy','accuracy for last 10 trials', 'coherence', 'Location', 'NorthEast', 'Interpreter', 'none' );
    xlabel('Trial Number');
    ylabel('% Accuracy/Coherence');
    title(sprintf('Performance Across %s Trials\n%s',condition_list{condition},save_name), 'Interpreter', 'none');
    ax.FontSize=12;

    legend('cumulative % accuracy','accuracy for last 10 trials', 'coherence', 'Location', 'NorthEast', 'Interpreter', 'none' );
    

 

end