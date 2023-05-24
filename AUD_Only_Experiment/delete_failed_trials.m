function [dataout] = delete_failed_trials(dataout)
 dataout(strcmp(dataout(:,6),'N/A'),:)=[]; %delete rows where subject quit before target presented
 dataout(strcmp(dataout(:,10),'N/A'),:)=[]; %delete rows where subject didnt fixate on the presented target

