function [dataout]=convert_vis_directioncode(dataout)
%for visual only dataframes, convert how stimulus direction is coded from
%0=right, 180=left to 0=left, 1=right (i.e. the same scheme auditory uses)

for i_trial=2:length(dataout(:,1))
    trial_direction=dataout{i_trial,9};
    switch trial_direction
        case 0
            dataout{i_trial,9}=1;
            
        case 180
            dataout{i_trial,9}=0;
    end
    
end
