
function [cwt_coef, locs] = cwt_coef_extraction(signal, fs, pulse_len_left, pulse_len_right, min_eod_distance, min_eod_height)
 % Function for extraction of absolute CWT coefficients from EODs
 % Input  - signal: signal with EOD
 %        - fs: sampling frequency
 %        - pulse_len_left, pulse_len_right: define desired length of extracted EODs (length(EOD) = pulse_len_left + pulse_len_right + 1)
 %        - min_eod_distance: minimum distance between EODs for detection
 %        - min_eod_height: minimum height of EOD for detection
 % Output - cwt_coef: absolute wavelet coeficients for detected EODs (in rows of matrix)
 %        - locs: location of detected EODs
 
    % zero padding
    padding = zeros(1, 15);
    
    % find locations of EODs
    [~,locs] = findpeaks(abs(signal).^2,'MinPeakDistance', min_eod_distance, 'MinPeakHeight', (min_eod_height)^2);
    
    % exclude first or last peak if whole EOD cannot be extracted
    if locs(1) < pulse_len_left
        locs(1)=[];
    elseif locs(end) + pulse_len_right > length(signal)
        locs(end) = [];
    end
    
    % extract CWT coefficients
    for j=1:length(locs)
        h1 = locs(j)-pulse_len_left;
        h2 = locs(j)+pulse_len_right;        
        eod = signal(h1:h2); % extract eod

        eod_pad = [padding, eod, padding]; % pad with zeros

        if abs(min(eod_pad)) < max(eod_pad) % reverse polarity if needed
            eod_pad = -eod_pad;
        end

        eod_pad = eod_pad/max(abs(eod_pad)); % normalize
        
        % CWT
        fb = cwtfilterbank('SamplingFrequency', fs, 'SignalLength', length(eod_pad), 'VoicesPerOctave',12, 'FrequencyLimits', [0 round(fs/2)]);
        [w,~] = wt(fb,eod_pad);
        
        max_cwt = max(abs(w), [], 'all');
        w = w(:,15:end-15-1); % cropping back to original size
        
        % construct matrix with CWT coefficients for all eods
        if j == 1
            cwt_coef = zeros(length(locs), size(w,1)*size(w,2));
        end
        
        % store as row vector in matrix and normalize
        cwt_coef(j,:) = abs(w(:))/max_cwt;
    
    end
    
    % return matrix of absolute values of wavelet coefficients
    cwt_coef = abs(cwt_coef);

end
