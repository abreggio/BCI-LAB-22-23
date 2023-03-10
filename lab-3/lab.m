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
[body, header] = sload('../data/lab.gdf');
[body2, header2] = sload('../data/lab2.gdf');
[body3, header3] = sload('../data/lab3.gdf');

gdf_event_decorator = GDF_event_decorator(header.EVENT) + GDF_event_decorator(header2.EVENT);
gdf_event_decorator = gdf_event_decorator + GDF_event_decorator(header3.EVENT);

body = cat(1, body, body2, body3);

% somehow I get a column of zeros

body = body(:, 1:16);

clear("body2");
clear("body3");

disp(gdf_event_decorator.event_header)

%% load and apply laplacian map

load('../data/laplacian16.mat');

body = body * lap;

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

%% trial extraction

% FIX_DATA

fixation_data_mu_band = get_fixation_matrix(mu_filtered_avg, gdf_event_decorator);
fixation_data_beta_band = get_fixation_matrix(beta_filtered_avg, gdf_event_decorator);


% TRIAL_DATA

trial_data_mu_band = get_trials_for_erd(mu_filtered_avg, gdf_event_decorator);
trial_data_beta_band = get_trials_for_erd(beta_filtered_avg, gdf_event_decorator);

% EXTRACT TYPE

binding = @(matrix) extract_trials_of_type_s(matrix, gdf_event_decorator, [771 773]);

[trial_data_beta_band_feet, trial_data_beta_band_hands] = binding(trial_data_beta_band);
[trial_data_mu_band_feet, trial_data_mu_band_hands] = binding(trial_data_mu_band);

[fixation_data_beta_band_feet, fixation_data_beta_band_hands] = binding(fixation_data_beta_band);
[fixation_data_mu_band_feet, fixation_data_mu_band_hands] = binding(fixation_data_mu_band);


%% Baseline extraction

baseline_hands_mu = repmat(mean(fixation_data_mu_band_hands), [size(trial_data_mu_band_hands, 1) 1 1]);
baseline_feet_mu = repmat(mean(fixation_data_mu_band_feet), [size(trial_data_mu_band_feet, 1) 1 1]);

baseline_hands_beta = repmat(mean(fixation_data_beta_band_hands), [size(trial_data_beta_band_hands, 1) 1 1]);
baseline_feet_beta = repmat(mean(fixation_data_beta_band_feet), [size(trial_data_beta_band_feet, 1) 1 1]);

%% ERD Computation

ERD_hands_mu = log(trial_data_mu_band_hands ./ baseline_hands_mu);
ERD_hands_beta = log(trial_data_beta_band_hands ./ baseline_hands_beta);

ERD_feet_mu = log(trial_data_mu_band_feet ./ baseline_feet_mu);
ERD_feet_beta = log(trial_data_beta_band_feet ./ baseline_feet_beta);

%% average ERD


%% plt averaged erd

% plot hands
figure(1)
tiledlayout(2, 2)

ax1 = nexttile;

plot_avg_c3_cz_c4(ERD_hands_beta);


ax2 = nexttile;
plot_avg_c3_cz_c4(ERD_hands_mu)

ax3 = nexttile;
plot_avg_c3_cz_c4(ERD_feet_beta)

ax4 = nexttile;
plot_avg_c3_cz_c4(ERD_feet_mu)
