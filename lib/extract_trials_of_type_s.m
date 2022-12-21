%      This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 

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