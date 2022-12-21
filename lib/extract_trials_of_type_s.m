function varargout = extract_trials_of_type_s(trial_matrix, gdf_event_decorator, events)

    % note: should implement enumerate and enumeration class and some way
    % to iterate over an enumeration because i couldn't find a way and this
    % is very tedious.
    cue_indexes = gdf_event_decorator.get_typ();
    types = zeros(sum(gdf_event_decorator.index_event(1)),1);
    index_typ = 1;
    for cue_index = cue_indexes.'
        
        if(any(events == cue_index))
            types(index_typ) = cue_index;
            index_typ = index_typ + 1;
        end
    end

    for i = 1:length(events)
        event = events(i);
        varargout{i} = trial_matrix(:,:, types == event);
    end
end