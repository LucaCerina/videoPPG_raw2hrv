function signalOut = signalFilter(signalIn, fs, cutDown, cutUp)
% Basspand or lowpass filter a signal with a known sampling frequency with
% Hamming linear filter
% Parameters
% ----------
% signalIn: Input signal
% fs: Sampling frequency
% cutDown: high-pass frequency cutoff
% cutUp: low-pass frequency cutoff
%
% Outputs
% -------
% signalOut: Filtered signal

% Check cutoff 
if (cutDown == -1)
    frc = (cutUp*2) / fs;
else
    frc = [(cutDown*2) / fs (cutUp*2) / fs];
end

% Build filter
hamm = fir1(127, frc);

%Apply filter
signalOut = filtfilt(hamm, 1, signalIn);
end

 