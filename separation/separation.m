
%% data initialization

addpath('../') % !! path to FIt-SNE folder

signal = ...; % load EODs from two individuals

%% parameters
fs = 50e3;
opts_tsne.perplexity = 50;
opts_tsne.late_exag_coeff = 4;
pulse_len_left = 15;
pulse_len_right = 15;
min_eod_distance = 20;
min_eod_height = 0.05;

%% cwt coefficient extraction and EOD classification
[cwt_coef, locs] = cwt_coef_extraction(signal', fs, pulse_len_left, pulse_len_right, min_eod_distance, min_eod_height);
[mapping, idx] = classification(cwt_coef, opts_tsne);

%% visualize output of classified mapping 

figure;
gscatter(mapping(:,1), mapping(:,2), idx, "br");
legend("Fish A", "Fish B"); xlabel("t-SNE feature 1"); ylabel("t-SNE feature 2");
title("Visualization of EOD separation"); grid on;