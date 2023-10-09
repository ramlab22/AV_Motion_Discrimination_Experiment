function [ExpInfo, dotInfo, file_directory, data_file_directory, figure_file_directory] = initializeExperiment_vis(experiment_type)
    
    % Clear workspace and close all figures
    clear;
    close all;
    sca;

    % Sampling rate of RX8 processor
    sampling_rate = 24414 * 2;

    % Version info
    Version = 'Experiment_027_v.3.0'; % after code changes, change version

    % Directory paths
    file_directory = 'C:\Jackson\Adriana Stuff\AV_Motion_Discrimination_Experiment\VIS_Only_Experiment';
    data_file_directory = 'C:\Jackson\Adriana Stuff\AV_Behavioral_Data\'; 
    figure_file_directory = 'C:\Jackson\Adriana Stuff\AV_Figures\'; 

    % Baron fixation training setup
    baron_fixation_training = 0;
    if baron_fixation_training == 1
        target_reward = 'N/A';
    end

    % Add path for Eye Position vs time file
    addpath('C:\Jackson\Adriana Stuff\AV_Motion_Discrimination_Experiment\VIS_Only_Experiment\Eye_Movement_Data');

    
    for i_main = 1:length(data) % Initialize all State Buttons as zeros 
        if isnan(data(i_main))
            data(i_main) = 0;
        end
    end

    % Create structures for experiment data
    monWidth = 40; % Monitor Width in cm 
    viewDist = 55; % Viewing Distance from monitor in cm 
    switch experiment_type
        case 'MCS'
                [ExpInfo, vstruct, dotInfo] = CreateClassStructure_MCS(data, monWidth, viewDist, xCenter, yCenter);

        case 'staircase'
                [ExpInfo, vstruct, dotInfo] = CreateClassStructure(data, monWidth, viewDist, xCenter, yCenter);

        case 'dotnum'
            [ExpInfo, vstruct, dotInfo] = CreateClassStructure_MCS_dotnum(data, monWidth, viewDist, xCenter, yCenter);

    end

    disp(ExpInfo);
end
