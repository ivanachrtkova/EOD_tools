% Run for EOD sonification via Pulse-wise approach

%% data initialization

clear

sig_A = ... % load signal from first fish
sig_B = ... % load signal from second fish

%% parameters
sfreq = 33333; % sampling frequency
eod_len = 21; % length of eod = length of generated tone
eod_distance = 50; % distance between eods for findpeaks
eod_height = 0.05; % minimum height for eod detection for findpeaks

tones_weight = "normalized"; % "amplitude" - maintains information about eod amplitude,
                             % "normalized" - same amplitude of EODs/tones from single fish

f1 = 1.5e3; % first tone frequency
f2 = 15e3; % second tone frequency

output_filename = "pulse_wise_sonification.wav"; % filename for sonification ouput

%% sonification

% find EODs locations
[~,locsA] = findpeaks(abs(sig_A).^2,'MinPeakDistance', eod_distance, 'MinPeakHeight', eod_height^2);
[~,locsB] = findpeaks(abs(sig_B).^2,'MinPeakDistance', eod_distance, 'MinPeakHeight', eod_height^2);

% single tone generation
dt = 1/sfreq;                   
t1 = (0:dt:(eod_len-1)/sfreq)';
t2 = (0:dt:(eod_len-1)/sfreq)';
tone_1 = sin(2*pi*f1*t1);
tone_2 = sin(2*pi*f2*t2);

sig_Atone = zeros(length(sig_A),1);
sig_Btone = zeros(length(sig_B),1);

% Sonification - insert tone to specific EOD locations 
if tones_weight == "amplitude"
    for i=1:length(locsA)
        sig_Atone(locsA(i)-floor(eod_len/2):locsA(i)+floor(eod_len/2)) = 0.25*tone_1*abs(sig_A(locsA(i)));
    end

    for i=1:length(locsB)
        sig_Btone(locsB(i)-floor(eod_len/2):locsB(i)+floor(eod_len/2)) = 2*tone_2*abs(sig_B(locsB(i)));
    end

elseif tones_weight == "normalized"
    for i=1:length(locsA)
        sig_Atone(locsA(i)-floor(eod_len/2):locsA(i)+floor(eod_len/2)) = 0.25*tone_1;
    end

    for i=1:length(locsB)
        sig_Btone(locsB(i)-floor(eod_len/2):locsB(i)+floor(eod_len/2)) = 2*tone_2;
    end

else
    sprintf("Unrecognized value for tones_weight variable. " + ...
        "Use 'amplitude' or 'normalized' to maintain information " + ...
        "about signal amplitude or generate tones with the same intesity.")
end

%% output

sig = sig_Atone + sig_Btone;
audiowrite(output_filename, rescale(sig), sfreq);
