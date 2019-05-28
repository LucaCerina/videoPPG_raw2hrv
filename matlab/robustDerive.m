function signalOut = robustDerive(signalIn)
% Perform robust five point, central, first order derivative of the signal
% Parameters
% ----------
% signalIn: Input signal
%
% Outputs
% -------
% signalOut: Derivative of the input

% Derivative coefficients
coeffs = [1/12, -2/3, 0, 2/3, 1/12];

% Output allocation
signalOut = zeros(length(signalIn),1);

% Apply derivative
for i = 3:length(signalIn)-2
    signalOut(i-2) = coeffs*signalIn(i-2:i+2);
end
end

