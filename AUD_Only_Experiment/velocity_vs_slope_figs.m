velocities=[9.59,26.38,43,59.95,76.74,93.5]   ;
%velocities2=["9.59","26.38","43","59.95","76.74","93.5"]   ;

%alv_overallslope=[0.141,0.339,0.446,0.451,0.468,0.49];
alv_slope50=[1.774,1.358,1.679,1.722,2.439,2.538];
alv_std_cumgaus=[0.225,0.294,0.238,0.232,0.164,0.157];

%alv_overallslope_SE=[0.009,0.044,0.039,0.009,0.077,0.006];
alv_slope50_SE=[1.054,0.189,0.137,0.210,0.205,0.017];
alv_std_cumgaus_SE=[0.170,0.025,0.028,0.016,0.01,0.017];

%ba_overallslope=[0.167,0.665,0.882,0.468,0.483,0.483];
ba_slope50=[1.369,1.521,1.535,1.818,2.132,2.486];
ba_std_cumgaus=[0.291,0.262,0.260,0.219,0.187,0.160];

%ba_overallslope_SE=[0.063,0.038,0.008,0.079,0.123,0.118];
ba_slope50_SE=[0.307,0.215,0.125,0.117,0.214,0.737];
ba_std_cumgaus_SE=[0.249,0.042,0.21,0.013,0.013,0.024];

Path_Ba='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Ba/aud_only_velocity_vs_duration/trials200/';
[ba_slope_50_200,ba_std_cumgaus_200,~] = load_data_for_parameter_performance_plot(Path_Ba)

Path_Alv='/Users/adrianaschoenhaut/Documents/AV_Motion_Discrimination_Experiment/Mixed_Modality_and_AV_Exp/test_data/Alv/aud_only_velocity_vs_duration/trials200/';
[alv_slope_50_200,alv_std_cumgaus_200,~] = load_data_for_parameter_performance_plot(Path_Alv)
%% std cummulative gaussian      
    fig = figure('Name', 'velocity_vs_std_cummulative_gaussian_200trials');
    plot(velocities, alv_std_cumgaus_200, 'bo-','LineWidth', 2);
    hold on;
    plot(velocities, ba_std_cumgaus_200, 'ro-','LineWidth', 2);
   
    % Set plot labels and styling
    title('Alv and Ba changes in std of cummulative gaussian vs. velocity 200 trials per coh');
    xlabel('Velocity (degrees/s)');
   % ylabel('Overall Slope', 'Interpreter', 'none');
    ylabel('std of cummulative gaussian', 'Interpreter', 'none');
    ylim([0 0.6]);
    grid on;
    ax = gca; 
    ax.FontSize = 22;
    % Add legend to the plot
    legend('Alvarez','Baron', 'Location', 'Best', 'Interpreter', 'none');
%% overall slope
    fig = figure('Name', 'velocity_vs_slope');
    errorbar(velocities, alv_overallslope, alv_overallslope_SE, 'bo-','LineWidth', 2);
    hold on;
    errorbar(velocities, ba_overallslope, ba_overallslope_SE, 'ro-','LineWidth', 2);
   
    % Set plot labels and styling
    title('Alv and Ba changes in overall slope with velocity 041124', 'Interpreter', 'none');
    xlabel('Velocity (degrees/s)');
    ylabel('Overall Slope', 'Interpreter', 'none');

    grid on;
    ax = gca; 
    ax.FontSize = 22;
    % Add legend to the plot
    legend('Alvarez','Baron', 'Location', 'Best', 'Interpreter', 'none');
    
%% slope at 50% rightward resp
    fig = figure('Name', 'velocity_vs_slope50');
    errorbar(velocities, alv_slope50, alv_slope50_SE, 'bo-','LineWidth', 2);
    hold on;
    errorbar(velocities, ba_slope50, ba_slope50_SE, 'ro-','LineWidth', 2);
   
    % Set plot labels and styling
    title('Alv and Ba changes in slope at 50% rightward resp vs. velocity 041124', 'Interpreter', 'none');
    xlabel('Velocity (degrees/s)');
    ylabel('Slope at 50% Rightward Response', 'Interpreter', 'none');

    grid on;
    ax = gca; 
    ax.FontSize = 22;
    % Add legend to the plot
    legend('Alvarez','Baron', 'Location', 'Best', 'Interpreter', 'none');

%% std cummulative gaussian      
    fig = figure('Name', 'velocity_vs_std_cummulative_gaussian');
    errorbar(velocities, alv_std_cumgaus, alv_std_cumgaus_SE, 'bo-','LineWidth', 2);
    hold on;
    errorbar(velocities, ba_std_cumgaus, ba_std_cumgaus_SE, 'ro-','LineWidth', 2);
   
    % Set plot labels and styling
    title('Alv and Ba changes in std of cummulative gaussian vs. velocity 041124');
    xlabel('Velocity (degrees/s)');
   % ylabel('Overall Slope', 'Interpreter', 'none');
    ylabel('std of cummulative gaussian', 'Interpreter', 'none');

    grid on;
    ax = gca; 
    ax.FontSize = 22;
    % Add legend to the plot
    legend('Alvarez','Baron', 'Location', 'Best', 'Interpreter', 'none');
