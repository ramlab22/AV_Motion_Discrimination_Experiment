% COMBINE_FIG_FILES
%
% This script combines the plots from two MATLAB .fig files into a single figure.
% It retains the specific line and marker styles from each individual .fig file.
%
% Usage:
% 1. Replace 'path_to_first_fig_file.fig' and 'path_to_second_fig_file.fig' with the paths to your .fig files.
% 2. Run the script.
%
% Outputs:
% - A new figure window displaying the combined plots from both .fig files.
%
% Notes:
% - This script assumes that the .fig files can contain multiple plots.
% - The combined figure will maintain the line and marker styles from the original plots.
% - You might want to adjust the legend entries to reflect the content of your plots.
%
% Author: adriana schoenhaut
% Date: 8/20/23

fig_title='Alv Aud Only 367ms duration low vs high velocity';
%path1='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel9.59_dis8/Baron_audonly_9.59velocity_834ms_8degrees.fig';
%path2='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel26.38_dis22/Baron_AudOnly_dur834ms_vel26.38_22degrees.fig';

% path3='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_velocity/dur1300ms_vel59.95_dis78/Ba_AudOnly_dur1300ms_vel59.95_dis78.fig';
% path2='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_velocity/dur1100ms_vel59.95_dis66/Ba_AudOnly_dur1100ms_vel59.95_dis66.fig';
% path1='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel59.95_dis50/Ba_AudOnly_dur834ms_vel59.95_dis50.fig';
%path3='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_velocity/dur1300ms_vel59.95_dis78/Alv_AudOnly_dur1300ms_vel59.95_dis78.fig';
%path2='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_velocity/dur1100ms_vel59.95_dis66/Alv_AudOnly_dur1100ms_vel59.95_dis66.fig';
%path1='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel59.95_dis50/Alv_AudOnly_dur834ms_vel59.95_dis50.fig';

path3='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/dur312ms_vel250_dis78/Alv_AudOnly_dur312ms_vel250_dis78.fig';
path2='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/dur367ms_vel212_dis77.8/Alv_AudOnly_dur367ms_vel212_dis77.8.fig';
path1='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_displacement/dur367ms_vel59.95_dis22/Alv_AudOnly_dur367ms_vel59.95_dis22.fig';

fig1label='vel59.95_dis22';
fig2label='vel212_dis77.8';
fig3label='dur312ms_vel250_dis78';

% fig2label='dur1100ms_dis66';
% fig1label='dur834ms_dis50';
% fig3label='dur1300ms_dis78';

% fig1label='vel9.59_dis8';
% fig2label='vel26.38_dis22';
% fig3label='vel43_dis36';
% fig4label='vel59.95_dis50';
% fig5label='vel76.74_dis66';
% fig6label='vel93.5_dis78';
fig1color='k';
fig2color='g';
fig3color='m';

% Extract data from both fig files
data1 = extractDataFromFig(path1);
data2 = extractDataFromFig(path2);
data3 = extractDataFromFig(path3);

% Create combined figure
figure;
hold on;

% Plot data from the first figure and store the handles
handles = []; % Array to store handles for the legend
labels = {}; % Array to store labels for the legend
% Define a thicker line width for scatter plot markers
markerLineWidth = 1.6; 
[h,handles,labels] = get_fig_handles(data1,fig1color,markerLineWidth,labels,handles,fig1label);
[h,handles,labels] = get_fig_handles(data2,fig2color,markerLineWidth,labels,handles,fig2label);
[h,handles,labels] = get_fig_handles(data3,fig3color,markerLineWidth,labels,handles,fig3label);

% Create the legend using the handles and labels
legend(handles, labels, 'Location', 'Best' ,'Interpreter', 'none' );


% Adjustments (assuming similar axis settings for both figures)
title(fig_title);
xlabel('Coherence ((+)Rightward, (-)Leftward)');
ylabel('Proportion Rightward Response');
%xlim([-max([data1.scatter.x, data2.scatter.x]) max([data1.scatter.x, data2.scatter.x])]);
xlim([-max([data1.scatter.x, data2.scatter.x,data3.scatter.x]) max([data1.scatter.x, data2.scatter.x, data3.scatter.x])]);

%xlim([-0.5 0.5]);

ylim([0 1]);
grid on;
ax = gca; 
ax.FontSize = 22;
resizeFigures();

% Note: The text annotations are not combined here. If you wish to include them, you can loop through the `data.text` fields and use the `text` function.

% hold off;
% 
% load('Ba_aud_dbSNR6_staircase.mat');
% aud_mdl=mdl;
% aud_xData=xData;
% aud_yData=yData;
% load('ba_vis_staircase.mat');
% vis_mdl=mdl;
% vis_xData=xData;
% vis_yData=yData;
% [Results_MLE] = MLE_Calculations_A_V(aud_mdl, vis_mdl,aud_yData,vis_yData, aud_xData,vis_xData)


