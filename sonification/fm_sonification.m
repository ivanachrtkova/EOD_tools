
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

fca = 523.3; % characteristic frequency of the first fish
fcb = 392; % characteristic frequency of the second fish

eodHeight = 0.05; % minimum height for EOD detection
eodDistance = 50; % minimum distance between EODs for detection

outputFilename = "fm_sonification.wav";
%% fish A
if lengthSampl > length(sig_A)
    lengthSampl = length(sig_A); % ensure sample length does not exceed signal length
end

[pks,locs] = findpeaks(abs(sig_A).^2,'MinPeakHeight',eodHeight^2,'MinPeakDistance',eodDistance);
% detect EOD peaks in fish A signal

locsDiff = diff(locs); % compute intervals between EOD peaks
diffIdx = 1;
for sampleIdx = 1:locs(end-1)
    iti1(sampleIdx) = locsDiff(diffIdx); % assign current inter-peak interval
    if sampleIdx == locs(diffIdx+1)
        diffIdx = diffIdx + 1; % move to next interval at each detected peak
    end
end

% fill the last part of the iti1 by constant extrapolation
lastItin = length(sig_A)-length(iti1); % remaining samples after last interval
iti1 = [iti1 locsDiff(end)*ones(1,lastItin)]; % extrapolate using last interval

lpFilt = designfilt('lowpassiir', 'PassbandFrequency', 1, ...
                    'StopbandFrequency', 50, 'PassbandRipple', 1, ...
                    'StopbandAttenuation', 60, 'SampleRate', fvz, ...
                    'DesignMethod', 'butter');
% design a low-pass Butterworth filter

y1 = filtfilt(lpFilt,iti1); % filter the interval sequence
t=0:1/fvz:(length(y1)-1)/fvz; % create time vector
y1 = -1*y1; % invert signal
y1 = y1 - mean(y1); % center to zero mean
y1 = y1/max(abs(y1)); % normalize to range [-1, 1]

y1(y1<-0.2) = -0.2; % clip minimum value
y1 = y1 - mean(y1); % recenter after clipping
waveformA = cos(2*pi*fca.*t +y1*depth*fca); % generate FM waveform for fish A

%% fish B
if lengthSampl > length(sig_B)
    lengthSampl = length(sig_B); % ensure sample length does not exceed signal length
end

[pks,locs] = findpeaks(abs(sig_B).^2,'MinPeakHeight',eodHeight^2,'MinPeakDistance', eodDistance);
% detect EOD peaks in fish B signal

locsDiff = diff(locs); % compute intervals between EOD peaks
diffIdx = 1;
for sampleIdx = 1:locs(end-1)
    iti2(sampleIdx) = locsDiff(diffIdx); % assign current inter-peak interval
    if sampleIdx == locs(diffIdx+1)
        diffIdx = diffIdx + 1; % move to next interval at each detected peak
    end
end

% fill the last part of the iti by constant extrapolation
lastItin = length(sig_A)-length(iti2); % remaining samples after last interval
iti2 = [iti2 locsDiff(end)*ones(1,lastItin)]; % extrapolate using last interval

lpFilt = designfilt('lowpassiir', 'PassbandFrequency', 1, ...
                    'StopbandFrequency', 50, 'PassbandRipple', 1, ...
                    'StopbandAttenuation', 60, 'SampleRate', fvz, ...
                    'DesignMethod', 'butter');
% design a low-pass Butterworth filter

y2 = filtfilt(lpFilt,iti2); % filter the interval sequence
t=0:1/fvz:(length(y2)-1)/fvz; % create time vector
y2 = -1*y2; % invert signal
y2 = y2 - mean(y2); % center to zero mean
y2 = y2/max(abs(y2)); % normalize to range [-1, 1]

y2(y2<-0.2) = -0.2; % clip minimum value
y2 = y2 - mean(y2); % recenter after clipping
waveformB = cos(2*pi*fcb.*t +y2*depth*fca); % generate FM waveform for fish B

%% output
waveform(1,:) = waveformA(1,:); % assign fish A waveform to first channel
waveform(2,:) = waveformB(1,:); % assign fish B waveform to second channel
audiowrite(outputFilename,waveform',audioSampling) % write stereo waveform to audio file
