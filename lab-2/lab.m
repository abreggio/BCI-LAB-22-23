%      This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 

%%
clearvars;

% this is a workaround to avoid using full path name, just set your env
% variable to your biosig path, or copy paste yours.

biosig_loc = getenv("BIOSIG_LOC");
addpath("../lib/")
addpath(strcat(biosig_loc, '/t200_FileAccess/'))
addpath(strcat(biosig_loc, '/t250_ArtifactPreProcessingQualityControl/'))
[body, header] = sload('lab.gdf');
[body2, header2] = sload('lab2.gdf');
[body3, header3] = sload('lab3.gdf');
gdf_event_decorator = GDF_event_decorator(header.EVENT) + GDF_event_decorator(header2.EVENT);
gdf_event_decorator = gdf_event_decorator + GDF_event_decorator(header3.EVENT);

body = cat(1, body, body2, body3);
clear("body2");
clear("body3");

disp(gdf_event_decorator.event_header)

%% filter

beta_filtered = filter_on_band_wave('beta', body, gdf_event_decorator.event_header.SampleRate);

mu_filtered = filter_on_band_wave('mu', body, gdf_event_decorator.event_header.SampleRate);

%% squaring

beta_filtered_avg = beta_filtered .^ 2;

mu_filtered_avg = mu_filtered .^ 2;

%% mvn avg

beta_filtered_avg = moving_mean(beta_filtered_avg, gdf_event_decorator.event_header.SampleRate);

mu_filtered_avg = moving_mean(mu_filtered_avg, gdf_event_decorator.event_header.SampleRate);

%% log

beta_filtered_avg = log(beta_filtered_avg);

mu_filtered_avg = log(mu_filtered_avg);

%% 

%% trial extraction

trial_matrix_unfiltered = get_trial_matrix(body, gdf_event_decorator);

trial_matrix_filtered = get_trial_matrix(mu_filtered, gdf_event_decorator);
trial_matrix_filtered_beta = get_trial_matrix(beta_filtered, gdf_event_decorator);

trial_matrix_pipelined = get_trial_matrix(mu_filtered_avg, gdf_event_decorator);
trial_matrix_pipelined_beta = get_trial_matrix(beta_filtered_avg, gdf_event_decorator);

%% plt trial

% get the different cues

binding = @(matrix) extract_trials_of_type_s(matrix, gdf_event_decorator, [771 773]);

[trial_hands_unfiltered, trial_feet_unfiltered] = binding(trial_matrix_unfiltered);

[trial_hands_filtered, trial_feet_filtered] = binding(trial_matrix_filtered);

[trial_hands_pipelined, trial_feet_pipelined] = binding(trial_matrix_pipelined);

[trial_hands_filtered_beta, trial_feet_filtered_beta] = binding(trial_matrix_filtered_beta);

[trial_hands_pipelined_beta, trial_feet_pipelined_beta] = binding(trial_matrix_pipelined_beta);

% plot a trial for each cue

% plot hands
figure(1)
tiledlayout(3, 3)

ax1 = nexttile;

plot_avg_c3_cz_c4(trial_hands_unfiltered);


ax2 = nexttile;
plot_avg_c3_cz_c4(trial_hands_filtered)

ax3 = nexttile;
plot_avg_c3_cz_c4(trial_hands_filtered_beta)

ax4 = nexttile;
plot_avg_trial_on_chn(trial_hands_pipelined, 7);

ax4 = nexttile;
plot_avg_trial_on_chn(trial_hands_pipelined, 9);

ax4 = nexttile;
plot_avg_trial_on_chn(trial_hands_pipelined, 11);

ax4 = nexttile;
plot_avg_trial_on_chn(trial_hands_pipelined_beta, 7);

ax4 = nexttile;
plot_avg_trial_on_chn(trial_hands_pipelined_beta, 9);

ax4 = nexttile;
plot_avg_trial_on_chn(trial_hands_pipelined_beta, 11);
