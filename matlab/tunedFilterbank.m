function [harmonics, signalOut] = tunedFilterbank(signalIn, f0, fs, order)
% Perform harmonic filtering starting from a fundamental frequency and the
% number of harmonics to be filtered (Hamming linear filtering)
% Parameters
% ----------
% signalIn: Input signal
% f0: Fundamental frequency
% fs: Sampling frequency
% order: Number fo harmonics to be replicated. 1 = fundamental only
%
% Outputs
% -------
% harmonics:. 
% signalOut: Filtered signal

% Output allocation
harmonics = zeros(size(signalIn,1), order);
signalOut = zeros(size(signalIn,1), 1);

% Filterbank allocation
hammFilter = zeros(100,order);
for i = 1:order
    v = [f0-0.1*f0/i f0+0.1*f0/i].*i.*(2/fs); % Restrict window properly
    [hammFilter(:,i)] = filterbank_fir(v);
end

% Filter application
for j=1:order
    harmonics(:,j) = filtfilt(hammFilter(:,j), 1, signalIn);
end

% Build output signal using summation
signalOut(:,1) = sum(harmonics,2);
end

function [hamm] = filterbank_fir(value)
hamm = fir1(99, value); % Order 99 is arbitrary
end