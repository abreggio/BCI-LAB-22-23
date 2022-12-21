function plot_avg_trial_on_chn(trials_matrix_to_plot, chn)
    mean_avg_trials_on_chn = @(matrix, chn) mean(matrix(:,chn,:), 2);
    
    avg = mean_avg_trials_on_chn(trials_matrix_to_plot, chn);
    
    plot(0:length(avg)-1, avg(:,1))
end