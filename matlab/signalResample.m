function [signalOut, timeOut] = signalResample(signalIn, timeIn, desFc)
% Resample a signal using timestamps and desired sampling frequency
% Parameters
% ----------
% signalIn: Input signal
% timeIn: Input time signal, must have the same length of signalIn
% desFc: Desired sampling frequency for resampling (in Hz)
%
% Outputs
% -------
% signalOut: Resampled signal
% timeOut: Timestamps of resampled signal

% Check size
assert(size(signalIn,1) == size(timeIn,1), 'Signal and timestamps should have the same length.');
% Check frequency
desFc = abs(desFc);

% Remove mean of input to avoid border effects
mSignal = mean(signalIn);
signalDtr = bsxfun(@minus, signalIn, mSignal);

% Resample
[signalOut, timeOut] = resample(signalDtr, timeIn, desFc);
signalOut = bsxfun(@plus, signalOut, mSignal);

end

