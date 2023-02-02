function [accuracy_vs_trial_data_filename] = get_accuracy_vs_trial_data(dataout, save_name,interval_val)
trial_num = cell2mat(dataout(2:end,1));
    n_trials=size(trial_num,1);
    completed_dataout=dataout(2:n_trials+1,:);
    single_response_accuracy=completed_dataout(:,6);
    trial_coherences=cell2mat(completed_dataout(:,8));
    single_response_accuracy_values=trial_num;
    for i_trial=1:n_trials
        if single_response_accuracy{i_trial,1}(2) == 'e'
            single_response_accuracy_values(i_trial,2) = 1;
        end
        if single_response_accuracy{i_trial,1}(2) == 'o'
            single_response_accuracy_values(i_trial,2) = 0;
        end
        if single_response_accuracy{i_trial,1}(2) == '/'
            single_response_accuracy_values(i_trial,1) = NaN;
            single_response_accuracy_values(i_trial,2) = NaN;
            
        end
    end
    non_nan_idx=~isnan(single_response_accuracy_values);
    single_response_accuracy_values=single_response_accuracy_values(non_nan_idx(:,1),:);
    trial_coherences=trial_coherences(non_nan_idx(:,1),:);
    n_responses=size(single_response_accuracy_values,1);
    cumulative_accuracy=single_response_accuracy_values(:,1);
    interval_accuracy=nan(floor(n_responses/interval_val),2);
    interval_startpoint=1;
    for i_response=1:n_responses
        cumulative_accuracy(i_response,2)=(sum(single_response_accuracy_values(1:i_response,2))/i_response)*100;
    end
    for i_interval=1:floor(n_responses/interval_val)
        interval_endpoint=i_interval*interval_val;
        interval_accuracy(i_interval,1)=cumulative_accuracy(interval_endpoint,1);
        interval_accuracy(i_interval,2)=sum(single_response_accuracy_values(interval_startpoint:interval_endpoint,2)/interval_val)*100;
        interval_startpoint=interval_startpoint+interval_val;
    end
    remaining_trials=rem(n_responses,interval_val);
    if remaining_trials ~= 0
        interval_endpoint=n_responses;
        interval_accuracy(floor(n_responses/interval_val)+1,1)=cumulative_accuracy(interval_endpoint,1);
        interval_startpoint=n_responses-remaining_trials+1;
        interval_accuracy(floor(n_responses/interval_val)+1,2)=sum(single_response_accuracy_values(interval_startpoint:interval_endpoint,2)/remaining_trials)*100;
        
    end
    accuracy_vs_trial_data_filename=sprintf('%s_AccVsTrial',save_name);
    save(accuracy_vs_trial_data_filename);
    