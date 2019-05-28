function [signalOut] = signalInversion(signalIn)
% Check if PPG signal should be inverted based on median of signal above
% and below 0
% Parameters
% ----------
% signalIn: Input signal
%
% Outputs
% -------
% signalOut: Reversed signal or original signal

A1 = median(signalIn(signalIn>0));
A2 = median(signalIn(signalIn<0));

if abs(A1) < abs(A2)
    signalOut = -1.*signalIn;
else
    signalOut = signalIn;
end
end