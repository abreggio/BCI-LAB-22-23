function trial_matrix = get_trial_matrix(body, gdf_event_decorator)
    trials_dur = sum(reshape(gdf_event_decorator.get_dur(), 4,[]),1);
    sample_dim = max(trials_dur);
    trial_num = sum(gdf_event_decorator.index_event(1));
    trial_matrix = zeros(sample_dim, length(body(1,:)), trial_num);
    for index = 1 : trial_num
        trial_dur = trials_dur(index);
        trial_pos = gdf_event_decorator.get_pos_for_start();
        trial_pos = trial_pos(index);
        % stupid matlab wont let me chain methods
        trial_matrix(1:trial_dur+1, :, index) = body(trial_pos:trial_pos+trial_dur, :);
    end
end