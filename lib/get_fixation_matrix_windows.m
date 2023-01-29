%      This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

function trial_matrix = get_fixation_matrix_windows(body, gdf_event_decorator)
    
    % each period has its duration in gdf_event_decorator.get_dur()
    % at the same index

    fixation_duration = gdf_event_decorator.get_dur();
    fixation_duration = fixation_duration(gdf_event_decorator.get_typ() == 786);

    sample_dim = max(fixation_duration);

    % get the number of trials starting from the trial start

    trial_num = sum(gdf_event_decorator.index_event(1));

    frequencies = length(body(1,:,1));
    channels = length(body(1,1,:));
    % set up the empty trial matrix
    
    trial_matrix = zeros(sample_dim, frequencies, channels, trial_num);
    
    
    for index = 1 : trial_num
        trial_dur = fixation_duration(index);
        trial_pos = gdf_event_decorator.get_pos_for_fixation();
        trial_pos = trial_pos(index);
        % stupid matlab wont let me chain methods
        trial_matrix(1:trial_dur+1, :, :, index) = body(trial_pos:trial_pos+trial_dur, :, :);
    end
end