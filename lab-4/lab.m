%      This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 

% As a side note I start to grow wary of these mindless exercises
% Each has some meaningless addiction to the preceding work
% To the point I deeply regret I didn't go with the original idea
% Of just implementing the most general pipeline pattern. Hell,
% I could just make do with func composition if I just wasnt this
% lazy.

% RANT FINISHED. HERE'S YET ONE MORE PAJEET-TIER SCRIPT

clearvars;


% call preprocess. TO DO don't call preprocess if already preprocessed

preprocess;


%% load and concatenate the data

fileList = dir('./data/*.mat');

PSD = [];
gdf_event_decorator = [];
gdf_event_decorator_is_set = false;

for i = 1 : length(fileList)

    processed_data_struct = load(strcat('./data/', fileList(i).name));
    PSD = cat(1, PSD, processed_data_struct.PSD);
    
    if ~gdf_event_decorator_is_set
        gdf_event_decorator = GDF_event_decorator(processed_data_struct.data.EVENT);
        gdf_event_decorator_is_set = true;
    else
        prev = GDF_event_decorator(processed_data_struct.data.EVENT);
        
        gdf_event_decorator = gdf_event_decorator + prev;
    end
        
    

end

%% create trial and fixation matrix

% TODO Need to reuse and adapt the code to avoid having two slightly
% different functions

trial_matrix = get_trials_for_erd_windows(PSD, gdf_event_decorator);
fix_matrix = get_fixation_matrix_windows(PSD, gdf_event_decorator);

binding = @(matrix) extract_trials_of_type_s_windows(matrix, gdf_event_decorator, [771 773]);

[trial_data_windows_feet, trial_data_windows_hands] = binding(trial_matrix);

[fixation_data_windows_feet, fixation_data_windows_hands] = binding(trial_matrix);


%% compute ERD

baseline_hands = repmat(mean(fixation_data_windows_hands), [size(trial_data_windows_hands, 1) 1 1]);
baseline_feet = repmat(mean(fixation_data_windows_feet), [size(trial_data_windows_feet, 1) 1 1]);


erd_hands = log(trial_data_windows_hands ./ baseline_hands);
erd_feet = log(trial_data_windows_feet ./ baseline_feet);

%% compute average

average_erd_over_trials_feet = mean(erd_feet, 4);
average_erd_over_trials_hands = mean(erd_hands, 4);

%% visualize hands

imagesc(average_erd_over_trials_hands(:,:,9)')
colorbar

%% visualize feet

imagesc(average_erd_over_trials_hands(:,:,9)')
colorbar

%% P2

[PSD_feet, PSD_hands] = extract_windows_of_type_s(PSD, gdf_event_decorator, [771 773]);

fisher_score_hands = get_fisher_score(PSD_hands);
fisher_score_feet = get_fisher_score(PSD_feet);

%% visualize hands

imagesc(fisher_score_hands);
colorbar
%% visualize feet

imagesc(fisher_score_hands);
colorbar
