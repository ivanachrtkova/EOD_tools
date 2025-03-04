
% @author: Vlastimil Koudelka 

%% data initialization
clear

sig_A = ... % load signal from first fish
sig_B = ... % load signal from second fish

%% parameters
audioSampling = 33.333e3; % audio sampling frequency
fvz = 33.333e3; % sampling frequency of signal
lengthSampl = 30e22*fvz;
depth = 4;

fca = 523.3; % characteristic frequency of first fish
fcb = 392; % characteristic frequency of second fish

eodHeight = 0.05; % minimum height for EOD detection
eodDistance = 50; % minimum distance between EODs for detection

outputFilename = "fm_sonification.wav";
%% fish A
if lengthSampl > length(sig_A)
    lengthSampl = length(sig_A);
end

[pks,locs] = findpeaks(abs(sig_A).^2,'MinPeakHeight',eodHeight^2,'MinPeakDistance',eodDistance);

locsDiff = diff(locs);
diffIdx = 1;
for sampleIdx = 1:locs(end-1)
    iti1(sampleIdx) = locsDiff(diffIdx);
    if sampleIdx == locs(diffIdx+1)
        diffIdx = diffIdx + 1;
    end
end

%fill the last part of the iti1 by constant extrapolation
lastItin = length(sig_A)-length(iti1);
iti1 = [iti1 locsDiff(end)*ones(1,lastItin)];

lpFilt = designfilt('lowpassiir', 'PassbandFrequency', 1, ...
                    'StopbandFrequency', 50, 'PassbandRipple', 1, ...
                    'StopbandAttenuation', 60, 'SampleRate', fvz, ...
                    'DesignMethod', 'butter');

y1 = filtfilt(lpFilt,iti1);
t=0:1/fvz:(length(y1)-1)/fvz;
y1 = -1*y1;
y1 = y1 - mean(y1);
y1 = y1/max(abs(y1));

y1(y1<-0.2) = -0.2;
y1 = y1 - mean(y1);
waveformA = cos(2*pi*fca.*t +y1*depth*fca);
%% fish B
if lengthSampl > length(sig_B)
    lengthSampl = length(sig_B);
end

[pks,locs] = findpeaks(abs(sig_B).^2,'MinPeakHeight',eodHeight^2,'MinPeakDistance', eodDistance);

locsDiff = diff(locs);
diffIdx = 1;
for sampleIdx = 1:locs(end-1)
    iti2(sampleIdx) = locsDiff(diffIdx);
    if sampleIdx == locs(diffIdx+1)
        diffIdx = diffIdx + 1;
    end
end

%fill the last part of the iti by constant extrapolation
lastItin = length(sig_A)-length(iti2);
iti2 = [iti2 locsDiff(end)*ones(1,lastItin)];

lpFilt = designfilt('lowpassiir', 'PassbandFrequency', 1, ...
                    'StopbandFrequency', 50, 'PassbandRipple', 1, ...
                    'StopbandAttenuation', 60, 'SampleRate', fvz, ...
                    'DesignMethod', 'butter');

y2 = filtfilt(lpFilt,iti2);
t=0:1/fvz:(length(y2)-1)/fvz;
y2 = -1*y2;
y2 = y2 - mean(y2);
y2 = y2/max(abs(y2));

y2(y2<-0.2) = -0.2;
y2 = y2 - mean(y2);
waveformB = cos(2*pi*fcb.*t +y2*depth*fca);

%% output
waveform(1,:) = waveformA(1,:);
waveform(2,:) = waveformB(1,:);
audiowrite(outputFilename,waveform',audioSampling)
