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
%fig_title='Monkey Ba Aud Only, 59.95°/s Velocity';
fig_title='Monkey Ba Aud Only, 22° Displacement';

%path1='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel9.59_dis8/Baron_audonly_9.59velocity_834ms_8degrees.fig';
%path2='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel26.38_dis22/Baron_AudOnly_dur834ms_vel26.38_22degrees.fig';

% path1='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel9.59_dis8/Ba_AudOnly_dur834ms_vel9.59_dis8_may24.fig';
% path2='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel26.38_dis22/Ba_AudOnly_dur834ms_vel26.38_dis22_may24.fig';
% path3='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel43_dis36/Ba_AudOnly_dur834ms_vel43_dis36_may24.fig';
% path4='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel59.95_dis50/Ba_AudOnly_dur834ms_vel59.95_dis50_may24.fig';
% path5='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel76.74_dis66/Ba_AudOnly_dur834ms_vel76.74_dis66_may24.fig';
% path6='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel93.5_dis78/Ba_AudOnly_dur834ms_vel93.5_dis78_may24.fig';
% 
% path1='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel9.59_dis8/Alv_AudOnly_dur834ms_vel9.59_dis8_may24.fig';
% path2='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel26.38_dis22/Alv_AudOnly_dur834ms_vel26.38_dis22_may24.fig';
% path3='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel43_dis36/Alv_AudOnly_dur834ms_vel43_dis36_may24.fig';
% path4='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel59.95_dis50/Alv_AudOnly_dur834ms_vel59.95_dis50_may24.fig';
% path5='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel76.74_dis66/Alv_AudOnly_dur834ms_vel76.74_dis66_may24.fig';
% path6='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel93.5_dis78/Alv_AudOnly_dur834ms_vel93.5_dis78_may24.fig';
% save_path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/imrf poster/';
% save_name='Alv_audonly_constantduration_psychfuncs';

% path1='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel9.59_dis8/Ba_AudOnly_dur834ms_vel9.59_dis8_noextremes.fig';
% path2='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel26.38_dis22/Ba_AudOnly_dur834ms_vel26.38_dis22_noextremes.fig';
% path3='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel43_dis36/Ba_AudOnly_dur834ms_vel43_dis36_noextremes.fig';
% path4='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel59.95_dis50/Ba_AudOnly_dur834ms_vel59.95_dis50_noextremes.fig';
% path5='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel76.74_dis66/Ba_AudOnly_dur834ms_vel76.74_dis66_noextremes.fig';
% path6='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel93.5_dis78/Ba_AudOnly_dur834ms_vel93.5_dis78_noextremes.fig';
%save_path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_duration/';
%save_name='Ba_audonly_changingvelocity_834ms_noextremes';

% path1='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel9.59_dis8/Alv_AudOnly_dur834ms_vel9.59_dis8_noextremes.fig';
% path2='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel26.38_dis22/Alv_AudOnly_dur834ms_vel26.38_dis22_noextremes.fig';
% path3='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel43_dis36/Alv_AudOnly_dur834ms_vel43_dis36_noextremes.fig';
% path4='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel59.95_dis50/Alv_AudOnly_dur834ms_vel59.95_dis50_noextremes.fig';
% path5='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel76.74_dis66/Alv_AudOnly_dur834ms_vel76.74_dis66_noextremes.fig';
% path6='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_duration/dur834ms_vel93.5_dis78/Alv_AudOnly_dur834ms_vel93.5_dis78_noextremes.fig';
% 
% save_path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_duration/';
% save_name='Alv_audonly_changingvelocity_834ms_noextremes';

% path1='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_velocity/dur133ms_vel59.95_dis8/Alv_AudOnly_dur133ms_vel59.95_dis8.fig';
% path2='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_velocity/dur367ms_vel59.95_dis22/Alv_AudOnly_dur367ms_vel59.95_dis22.fig';
% path3='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_velocity/dur601ms_vel59.95_dis36/Alv_AudOnly_dur601ms_vel59.95_dis36.fig';
% path4='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_velocity/dur834ms_vel59.95_dis50/Alv_AudOnly_dur834ms_vel59.95_dis50.fig';
% path5='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_velocity/dur1100ms_vel59.95_dis66/Alv_AudOnly_dur1100ms_vel59.95_dis66.fig';
% path6='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_velocity/dur1300ms_vel59.95_dis78/Alv_AudOnly_dur1300ms_vel59.95_dis78.fig';
% 
% save_path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_velocity/';
% save_name='Alv_audonly_constantvelocity_psychfuncs';

% path1='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_displacement/dur133ms_vel165.4_dis22/Alv_AudOnly_dur133ms_vel165.4_dis22.fig';
% path2='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_displacement/dur367ms_vel59.95_dis22/Alv_AudOnly_dur367ms_vel59.95_dis22.fig';
% path3='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_displacement/dur601ms_vel36.61_dis22/Alv_AudOnly_dur601ms_vel36.61_dis22.fig';
% path4='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_displacement/dur834ms_vel26.38_dis22/Alv_AudOnly_dur834ms_vel26.38_dis22.fig';
% path5='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_displacement/dur1100ms_vel20_dis22/Alv_AudOnly_dur1100ms_vel20_dis22.fig';
% path6='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_displacement/dur1300ms_vel16.9_dis22/Alv_AudOnly_dur1300ms_vel16.9_dis22.fig';
% 
% save_path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/constant_displacement/';
% save_name='Alv_audonly_constantdisplacement_psychfuncs';
%path1='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_displacement/dur133ms_vel165.4_dis22/Ba_AudOnly_dur133ms_vel165.4_dis22.fig';
path2='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_displacement/dur367ms_vel59.95_dis22/Ba_AudOnly_dur367ms_vel59.95_dis22.fig';
path3='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_displacement/dur601ms_vel36.61_dis22/Ba_AudOnly_dur601ms_vel36.61_dis22.fig';
path4='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_displacement/dur834ms_vel26.38_dis22/Ba_AudOnly_dur834ms_vel26.38_dis22.fig';
path5='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_displacement/dur1100ms_vel20_dis22/Ba_AudOnly_dur1100ms_vel20_dis22.fig';
path6='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_displacement/dur1300ms_vel16.9_dis22/Ba_AudOnly_dur1300ms_vel16.9_dis22.fig';

save_path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_displacement/';
save_name='Ba_audonly_constantdisplacement_psychfuncs';

%path1='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_velocity/dur133ms_vel59.95_dis8/Ba_AudOnly_dur133ms_vel59.95_dis8.fig';
% path2='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_velocity/dur367ms_vel59.95_dis22/Ba_AudOnly_dur367ms_vel59.95_dis22.fig';
% path3='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_velocity/dur601ms_vel59.95_dis36/Ba_AudOnly_dur601ms_vel59.95_dis36.fig';
% path4='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_velocity/dur834ms_vel59.95_dis50/Ba_AudOnly_dur834ms_vel59.95_dis50.fig';
% path5='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_velocity/dur1100ms_vel59.95_dis66/Ba_AudOnly_dur1100ms_vel59.95_dis66.fig';
% path6='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_velocity/dur1300ms_vel59.95_dis78/Ba_AudOnly_dur1300ms_vel59.95_dis78.fig';
% 
% save_path='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/constant_velocity/';
% save_name='Ba_audonly_constantvelocity_psychfuncs';

fig1label='0.133s, 165.4°/s';
fig2label='0.367s, 59.95°/s';
fig3label='0.601s, 36.61°/s';
fig4label='0.834s, 26.38°/s';
fig5label='1.1s, 20°/s';
fig6label='1.3s, 16.9°/s';

% fig1label='0.133s, 8°';
%  fig2label='0.367s, 22°';
% fig3label='0.601s, 36°';
% fig4label='0.834s, 50°';
% fig5label='1.1s, 66°';
% fig6label='1.3s, 78°';

% fig1label='9.59°/s, 8°';
% fig2label='26.38°/s, 22°';
% fig3label='43°/s, 36°';
% fig4label='59.95°/s, 50°';
% fig5label='76.74°/s, 66°';
% fig6label='93.5°/s, 78°';
% 
%fig1color='k';
fig2color='b';
fig3color='c';
fig4color='g';
fig5color='r';
fig6color='m';

% Extract data from both fig files
%data1 = extractDataFromFig(path1);
data2 = extractDataFromFig(path2);
data3 = extractDataFromFig(path3);
data4 = extractDataFromFig(path4);
data5 = extractDataFromFig(path5);
data6 = extractDataFromFig(path6);

% Create combined figure
fig1=figure;
hold on;

% Plot data from the first figure and store the handles
handles = []; % Array to store handles for the legend
labels = {}; % Array to store labels for the legend
% Define a thicker line width for scatter plot markers
markerLineWidth = 1.6; 
%[h,handles,labels] = get_fig_handles(data1,fig1color,markerLineWidth,labels,handles,fig1label);
[h,handles,labels] = get_fig_handles(data2,fig2color,markerLineWidth,labels,handles,fig2label);
[h,handles,labels] = get_fig_handles(data3,fig3color,markerLineWidth,labels,handles,fig3label);
[h,handles,labels] = get_fig_handles(data4,fig4color,markerLineWidth,labels,handles,fig4label);
[h,handles,labels] = get_fig_handles(data5,fig5color,markerLineWidth,labels,handles,fig5label);
[h,handles,labels] = get_fig_handles(data6,fig6color,markerLineWidth,labels,handles,fig6label);

% Create the legend using the handles and labels
legend(handles, labels, 'Location', 'Best' ,'Interpreter', 'none' );


% Adjustments (assuming similar axis settings for both figures)
title(fig_title);
xlabel('Coherence ((+)Rightward, (-)Leftward)');
ylabel('Proportion Rightward Response');
%xlim([-max([data1.scatter.x, data2.scatter.x, data3.scatter.x, data4.scatter.x, data5.scatter.x]) max([data1.scatter.x, data2.scatter.x, data3.scatter.x, data4.scatter.x, data5.scatter.x])]);

xlim([-1 1]);

ylim([0 1]);
grid on;
ax = gca; 
ax.FontSize = 22;
poster_quality_figure();
saveas(fig1, [save_path save_name '.png']);
saveas(fig1, [save_path save_name '.fig']);

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


