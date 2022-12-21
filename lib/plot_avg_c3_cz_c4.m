function plot_avg_c3_cz_c4(trials_matrix_to_plot)
    
    % honestly couldn't figure out the map to the actual electrodes, just
    % bullshitted the indexes
    
    mean_avg_trials_on_chn = @(matrix, chn) mean(matrix(:,chn,:), 2);
    
    avg_c3 = mean_avg_trials_on_chn(trials_matrix_to_plot, 7);
    avg_cz = mean_avg_trials_on_chn(trials_matrix_to_plot, 9);
    avg_c4 = mean_avg_trials_on_chn(trials_matrix_to_plot, 11);
    
    plot(0:length(avg_c3)-1, avg_c3(:,1))
    hold on

    plot(0:length(avg_cz)-1, avg_cz(:,1))
    plot(0:length(avg_c4)-1, avg_c4(:,1))

    hold off

end