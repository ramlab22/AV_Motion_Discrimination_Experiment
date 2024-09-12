function fig = plot_AndV_accuracy_vs_trial(dataout, save_name, interval_val)
%plot the accuracy of individual trials over the course of the block to
%visualize staircase for blocks with interleaved aud only and vis only
%trials (mixed modality experiment)
    % Get the Frequencies for each coherence in each modality
    [AUD_dataout, VIS_dataout] = modality_splitter(dataout);
    VIS_trial_num = cell2mat(VIS_dataout(2:end,1));
    VIS_n_trials=size(VIS_trial_num,1);
    VIS_completed_dataout=VIS_dataout(2:VIS_n_trials+1,:);
    VIS_single_response_accuracy=VIS_completed_dataout(:,6);
    VIS_trial_coherences=cell2mat(VIS_completed_dataout(:,8));
    VIS_single_response_accuracy_values=VIS_trial_num;
    for i_trial=1:VIS_n_trials
        if VIS_single_response_accuracy{i_trial,1}(2) == 'e'
            VIS_single_response_accuracy_values(i_trial,2) = 1;
        end
        if VIS_single_response_accuracy{i_trial,1}(2) == 'o'
            VIS_single_response_accuracy_values(i_trial,2) = 0;
        end
        if VIS_single_response_accuracy{i_trial,1}(2) == '/'
            VIS_single_response_accuracy_values(i_trial,1) = NaN;
            VIS_single_response_accuracy_values(i_trial,2) = NaN;
            
        end
    end
    VIS_non_nan_idx=~isnan(VIS_single_response_accuracy_values);
    VIS_single_response_accuracy_values=VIS_single_response_accuracy_values(VIS_non_nan_idx(:,1),:);
    VIS_trial_coherences=VIS_trial_coherences(VIS_non_nan_idx(:,1),:);
    VIS_n_responses=size(VIS_single_response_accuracy_values,1);
    VIS_cumulative_accuracy=VIS_single_response_accuracy_values(:,1);
    VIS_interval_accuracy=nan(floor(VIS_n_responses/interval_val),2);
    VIS_interval_startpoint=1;
    for i_response=1:VIS_n_responses
        VIS_cumulative_accuracy(i_response,2)=(sum(VIS_single_response_accuracy_values(1:i_response,2))/i_response)*100;
    end
    for i_interval=1:floor(VIS_n_responses/interval_val)
        VIS_interval_endpoint=i_interval*interval_val;
        VIS_interval_accuracy(i_interval,1)=VIS_cumulative_accuracy(VIS_interval_endpoint,1);
        VIS_interval_accuracy(i_interval,2)=sum(VIS_single_response_accuracy_values(VIS_interval_startpoint:VIS_interval_endpoint,2)/interval_val)*100;
        VIS_interval_startpoint=VIS_interval_startpoint+interval_val;
    end
    VIS_remaining_trials=rem(VIS_n_responses,interval_val);
    if VIS_remaining_trials ~= 0
        VIS_interval_endpoint=VIS_n_responses;
        VIS_interval_accuracy(floor(VIS_n_responses/interval_val)+1,1)=VIS_cumulative_accuracy(VIS_interval_endpoint,1);
        VIS_interval_startpoint=VIS_n_responses-VIS_remaining_trials+1;
        VIS_interval_accuracy(floor(VIS_n_responses/interval_val)+1,2)=sum(VIS_single_response_accuracy_values(VIS_interval_startpoint:VIS_interval_endpoint,2)/VIS_remaining_trials)*100;
        
    end
    AUD_trial_num = cell2mat(AUD_dataout(2:end,1));
    AUD_n_trials=size(AUD_trial_num,1);
    AUD_completed_dataout=AUD_dataout(2:AUD_n_trials+1,:);
    AUD_single_response_accuracy=AUD_completed_dataout(:,6);
    AUD_trial_coherences=cell2mat(AUD_completed_dataout(:,8));
    AUD_single_response_accuracy_values=AUD_trial_num;
    for i_trial=1:AUD_n_trials
        if AUD_single_response_accuracy{i_trial,1}(2) == 'e'
            AUD_single_response_accuracy_values(i_trial,2) = 1;
        end
        if AUD_single_response_accuracy{i_trial,1}(2) == 'o'
            AUD_single_response_accuracy_values(i_trial,2) = 0;
        end
        if AUD_single_response_accuracy{i_trial,1}(2) == '/'
            AUD_single_response_accuracy_values(i_trial,1) = NaN;
            AUD_single_response_accuracy_values(i_trial,2) = NaN;
            
        end
    end
    AUD_non_nan_idx=~isnan(AUD_single_response_accuracy_values);
    AUD_single_response_accuracy_values=AUD_single_response_accuracy_values(AUD_non_nan_idx(:,1),:);
    AUD_trial_coherences=AUD_trial_coherences(AUD_non_nan_idx(:,1),:);
    AUD_n_responses=size(AUD_single_response_accuracy_values,1);
    AUD_cumulative_accuracy=AUD_single_response_accuracy_values(:,1);
    AUD_interval_accuracy=nan(floor(AUD_n_responses/interval_val),2);
    AUD_interval_startpoint=1;
    for i_response=1:AUD_n_responses
        AUD_cumulative_accuracy(i_response,2)=(sum(AUD_single_response_accuracy_values(1:i_response,2))/i_response)*100;
    end
    for i_interval=1:floor(AUD_n_responses/interval_val)
        AUD_interval_endpoint=i_interval*interval_val;
        AUD_interval_accuracy(i_interval,1)=AUD_cumulative_accuracy(AUD_interval_endpoint,1);
        AUD_interval_accuracy(i_interval,2)=sum(AUD_single_response_accuracy_values(AUD_interval_startpoint:AUD_interval_endpoint,2)/interval_val)*100;
        AUD_interval_startpoint=AUD_interval_startpoint+interval_val;
    end
    AUD_remaining_trials=rem(AUD_n_responses,interval_val);
    if AUD_remaining_trials ~= 0
        AUD_interval_endpoint=AUD_n_responses;
        AUD_interval_accuracy(floor(AUD_n_responses/interval_val)+1,1)=AUD_cumulative_accuracy(AUD_interval_endpoint,1);
        AUD_interval_startpoint=AUD_n_responses-AUD_remaining_trials+1;
        AUD_interval_accuracy(floor(AUD_n_responses/interval_val)+1,2)=sum(AUD_single_response_accuracy_values(AUD_interval_startpoint:AUD_interval_endpoint,2)/AUD_remaining_trials)*100;
        
    end
    
    fig = figure();

    %Top Plot AUD
    subplot(2,1,1);
    plot(AUD_cumulative_accuracy(:,1), AUD_cumulative_accuracy(:,2),'r','LineWidth',2.5);
    hold on
    plot(AUD_interval_accuracy(:,1),AUD_interval_accuracy(:,2),'g*--','LineWidth',2,'MarkerSize',10);
    plot(AUD_cumulative_accuracy(:,1), AUD_trial_coherences*100,'k','LineWidth',1.5);
    ax=gca;
    ax.FontSize=19;
    set(ax,'XTick',[0:(interval_val*2):AUD_cumulative_accuracy(AUD_n_responses,1)]);
    ylim([10,100]);
    xlim([0,AUD_cumulative_accuracy(AUD_n_responses,1)]);
    legend('AUD cumulative % accuracy','AUD accuracy for last 10 trials', 'AUD coherence', 'Location', 'NorthEast', 'Interpreter', 'none' );
    xlabel('Trial Number');
    ylabel('% Accuracy/Coherence');
    title(sprintf('AUD Performance Across Trials\n%s',save_name), 'Interpreter', 'none');
    ax.FontSize=12;

    %Bottom Plot VIS
   
    subplot(2,1,2);
    plot(VIS_cumulative_accuracy(:,1), VIS_cumulative_accuracy(:,2),'b','LineWidth',2.5);
    hold on
    plot(VIS_interval_accuracy(:,1),VIS_interval_accuracy(:,2),'g*--','LineWidth',2,'MarkerSize',10);
    plot(VIS_cumulative_accuracy(:,1), VIS_trial_coherences*100,'k','LineWidth',1.5);
    ax=gca;
    ax.FontSize=19;
    set(ax,'XTick',[0:(interval_val*2):VIS_cumulative_accuracy(VIS_n_responses,1)]);
    ylim([10,100]);
    xlim([0,VIS_cumulative_accuracy(VIS_n_responses,1)]);
    %legend('cumulative % accuracy','accuracy for last 10 trials', 'coherence', 'Location', 'NorthEast', 'Interpreter', 'none' );
    xlabel('Trial Number');
    ylabel('% Accuracy/Coherence');
    title(sprintf('VIS Performance Across Trials\n%s',save_name), 'Interpreter', 'none');
    ax.FontSize=12;
end