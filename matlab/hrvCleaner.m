 function signalOut = hrvCleaner(signalIn)
% Clean the inter-beat PPG signal using Median Array Dispersion and
% recursive correction based on Kullback-Leibler distance
% Parameters
% ----------
% signalIn: Input signal
%
% Outputs
% -------
% signalOut: Filtered signal

% Temporary signal
signalTemp = signalIn;
% Obtain Median Array Dispersion on population
madInput = mad(signalIn);
epsilon = 0.0001;

%for every sample, update the divergence
rho = madInput;
for steps = 1:length(signalIn)
    rho_dev = zeros(length(signalIn) - steps, 1);
    div_input = zeros(length(signalIn) - steps, 1);
    % Traverse data array
    for i = steps:length(signalIn)
        rho_dev(i) = mad(signalTemp(steps:i));
        div_input(i) = rho * log(rho/rho_dev(i)) + (1-rho) * log((1-rho)/(1-rho_dev(i)));
        if div_input(i) < epsilon && i+1 < length(signalIn)
            signalTemp(i) = (signalTemp(i-1) + signalTemp(i+1))/2;
            break
        end
    end
end

signalOut = signalTemp;
end

