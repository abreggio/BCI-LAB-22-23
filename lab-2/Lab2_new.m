clear all
clc

addpath(genpath('assignment_lib'))

channelLb  = {'Fz', 'FC3', 'FC1', 'FCz', 'FC2', 'FC4', 'C3', 'C1', 'Cz', 'C2', 'C4', 'CP3', 'CP1', 'CPz', 'CP2', 'CP4'};

addpath(genpath('t200_FileAccess'))
addpath(genpath('t210_Events'))

datapath   = strcat(pwd,'/data_lab/');

[s1,h1]=sload(strcat(datapath, 'ah7.20170613.161402.offline.mi.mi_bhbf.gdf'));
[s2,h2]=sload(strcat(datapath, 'ah7.20170613.162331.offline.mi.mi_bhbf.gdf'));
[s3,h3]=sload(strcat(datapath, 'ah7.20170613.162934.offline.mi.mi_bhbf.gdf'));
[s4,h4]=sload(strcat(datapath, 'ah7.20170613.170929.online.mi.mi_bhbf.ema.gdf'));
[s5,h5]=sload(strcat(datapath, 'ah7.20170613.171649.online.mi.mi_bhbf.dynamic.gdf'));
[s6,h6]=sload(strcat(datapath, 'ah7.20170613.172356.online.mi.mi_bhbf.dynamic.gdf'));
[s7,h7]=sload(strcat(datapath, 'ah7.20170613.173100.online.mi.mi_bhbf.ema.gdf'));

gdf_event_decorator = GDF_event_decorator(h1) + GDF_event_decorator(h2);
gdf_event_decorator = gdf_event_decorator + GDF_event_decorator(h3);
gdf_event_decorator = gdf_event_decorator + GDF_event_decorator(h4);
gdf_event_decorator = gdf_event_decorator + GDF_event_decorator(h5);
gdf_event_decorator = gdf_event_decorator + GDF_event_decorator(h6);
gdf_event_decorator = gdf_event_decorator + GDF_event_decorator(h7);

body = cat(1, s1, s2, s3,s4,s5,s6,s7);
body = body(:,1:16);

clear s1 s2 s3 s4 s5 s6 s7 h1 h2 h3 h4 h5 h6 h7

disp(gdf_event_decorator.event_header)

%% filter

sfilt_beta = butter_on_band_wave('beta', body, gdf_event_decorator.event_header.SampleRate,4);

sfilt_mu = butter_on_band_wave('mu', body, gdf_event_decorator.event_header.SampleRate,4);

%% logBP

slogpower_mu = logBP(sfilt_beta, gdf_event_decorator.get_SR());

slogpower_beta = logBP(sfilt_mu, gdf_event_decorator.get_SR());

%% trial extraction

[trial_matrix_unfiltered, EventLbl] = get_trial_matrix_upd(body, gdf_event_decorator); % check

trial_matrix_filtered_mu = get_trial_matrix_upd(sfilt_mu, gdf_event_decorator);
trial_matrix_filtered_beta = get_trial_matrix_upd(sfilt_beta, gdf_event_decorator);

TrialData_mu = get_trial_matrix_upd(slogpower_mu, gdf_event_decorator); % check
TrialData_beta = get_trial_matrix_upd(slogpower_beta, gdf_event_decorator);

%% plot 1 single trial

CH = make_channel_map();
c = [CH.C3,CH.Cz,CH.C4];
channelLb = fieldnames(CH);
TrialID = 65;

nsamples = size(trial_matrix_unfiltered,1);
SR = gdf_event_decorator.get_SR();
time = linspace(0,nsamples/SR,nsamples);

figure
subplot 131
plot(time, trial_matrix_unfiltered(:,c,TrialID));
xlabel('seconds')
ylabel('mV')
title('raw data')

subplot 132
plot(time, trial_matrix_filtered_mu(:,c,TrialID));
xlabel('seconds')
ylabel('mV')
title('\mu band [8 12]')

subplot 133
plot(time, trial_matrix_filtered_beta(:,c,TrialID));
xlabel('seconds')
ylabel('mV')
title('\beta band [18 22]')


%% plt 2 avg trial
NumTrials = size(trial_matrix_unfiltered,3);

% get the different cues

figure;
ClassSelected = [773 771];
ClassLabel = {'both hands', 'both feet'};

nClassSelected = length(ClassSelected);
colors = {'r', 'g'};
h_mu = nan(length(c), 1);
maxlim_mu = [nan nan];
plt=nan(nClassSelected,1);
for chId = 1:length(c)
    subplot(2, length(c), chId);
    
    for cId = 1:nClassSelected
        hold on;
        plt(cId) = plot(time,mean(TrialData_beta(:, c(chId), EventLbl==ClassSelected(cId)), 3), colors{cId});
        plot(time,mean(TrialData_beta(:, c(chId), EventLbl==ClassSelected(cId)), 3) + std(TrialData_beta(:, c(chId), EventLbl==ClassSelected(cId))/sqrt(NumTrials/2), [], 3), [colors{cId} ':']);
        plot(time,mean(TrialData_beta(:, c(chId), EventLbl==ClassSelected(cId)), 3) - std(TrialData_beta(:, c(chId), EventLbl==ClassSelected(cId))/sqrt(NumTrials/2), [], 3), [colors{cId} ':']);
        hold off;
    end
    legend(plt,ClassLabel)
    title(['mu band | Mean +/- SE | channel ' channelLb{c(chId)}]);
    xlabel('Time [s]');
    ylabel('power [dB]');
    grid on;
    cylim = get(gca, 'YLim');
    maxlim_mu = [min(maxlim_mu(1), cylim(1)) max(maxlim_mu(2), cylim(2))];
    h_mu(chId) = gca;
end
set(h_mu, 'YLim', maxlim_mu);

h_beta = nan(length(c), 1);
maxlim_beta = [nan nan];
for chId = 1:length(c)
    subplot(2, length(c), chId+3);
    for cId = 1:nClassSelected
        hold on;
        plt(cId) = plot(time, mean(TrialData_mu(:, c(chId), EventLbl==ClassSelected(cId)), 3), colors{cId});
        plot(time,mean(TrialData_mu(:, c(chId), EventLbl==ClassSelected(cId)), 3) + std(TrialData_mu(:, c(chId), EventLbl==ClassSelected(cId))/sqrt(NumTrials/2), [], 3), [colors{cId} ':']);
        plot(time,mean(TrialData_mu(:, c(chId), EventLbl==ClassSelected(cId)), 3) - std(TrialData_mu(:, c(chId), EventLbl==ClassSelected(cId))/sqrt(NumTrials/2), [], 3), [colors{cId} ':']);
        hold off;
    end

    legend(plt,ClassLabel)
    title(['mu band | Mean +/- SE | channel ' channelLb{c(chId)}]);
    xlabel('Time [s]');
    ylabel('power [dB]');
    grid on;
    
    
    cylim = get(gca, 'YLim');
    maxlim_mu = [min(maxlim_mu(1), cylim(1)) max(maxlim_mu(2), cylim(2))];
    h_mu(chId) = gca;
end
set(h_mu, 'YLim', maxlim_mu);

