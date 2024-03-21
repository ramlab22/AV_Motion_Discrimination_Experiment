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

fig_title='Ba Aud 59.95 degree/s velocity 834ms';
path1='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/Ba_aud_59.95velocity_834ms_catchtrials/Ba_audonly_feb2024_59.95velocity_834ms_catchtrialsincluded.fig';
path2='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/Ba_aud_59.95velocity_834ms_nocatch/Ba_audonly_feb2024_59.95velocity_824ms_nocatchtrials.fig';

fig1label='With Catch Trials';
fig2label='Without Catch Trials';

fig1color='r';
fig2color='b';
% Extract data from both fig files
data1 = extractDataFromFig(path1);
data2 = extractDataFromFig(path2);

% ... [previous parts of the code]

% Create combined figure
figure;
hold on;

% Plot data from the first figure and store the handles
handles = []; % Array to store handles for the legend
labels = {}; % Array to store labels for the legend
% Define a thicker line width for scatter plot markers
markerLineWidth = 1.6; 

% Define a scaling factor for marker size
markerSizeScale = 3; 
for i = 1:length(data1.scatter)
    h = scatter(data1.scatter(i).x, data1.scatter(i).y, data1.scatter(i).sizes * markerSizeScale, fig1color, 'LineWidth', markerLineWidth);
    handles = [handles, h];
    labels = [labels, sprintf('Resps from %s',fig1label)];
end

for i = 1:length(data1.line)
    h = plot(data1.line(i).x, data1.line(i).y, 'Color', fig1color, 'LineWidth',4);
    handles = [handles, h];
    labels = [labels, sprintf('NormCDF from %s',fig1label)];
end

% Plot data from the second figure and store the handles
for i = 1:length(data2.scatter)
    h = scatter(data2.scatter(i).x, data2.scatter(i).y, data2.scatter(i).sizes * markerSizeScale, fig2color, 'LineWidth', markerLineWidth);
    handles = [handles, h];
    labels = [labels, sprintf('Resps from %s',fig2label)];
end

for i = 1:length(data2.line)
    h = plot(data2.line(i).x, data2.line(i).y, 'Color',fig2color,'LineStyle',':', 'LineWidth', 4);
    handles = [handles, h];
    labels = [labels, sprintf('NormCDF from %s',fig2label)];
end

% Create the legend using the handles and labels
legend(handles, labels, 'Location', 'Best' ,'Interpreter', 'none' );

% ... [remaining adjustments]


% Adjustments (assuming similar axis settings for both figures)
title(fig_title);
xlabel('Coherence ((+)Rightward, (-)Leftward)');
ylabel('Proportion Rightward Response');
xlim([-max([data1.scatter.x, data2.scatter.x]) max([data1.scatter.x, data2.scatter.x])]);
ylim([0 1]);
grid on;
ax = gca; 
ax.FontSize = 22;

% Note: The text annotations are not combined here. If you wish to include them, you can loop through the `data.text` fields and use the `text` function.

hold off;

load('Ba_aud_dbSNR6_staircase.mat');
aud_mdl=mdl;
aud_xData=xData;
aud_yData=yData;
load('ba_vis_staircase.mat');
vis_mdl=mdl;
vis_xData=xData;
vis_yData=yData;
[Results_MLE] = MLE_Calculations_A_V(aud_mdl, vis_mdl,aud_yData,vis_yData, aud_xData,vis_xData)
