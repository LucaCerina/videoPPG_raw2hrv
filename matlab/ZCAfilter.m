function [signalOut, compLoad] = ZCAfilter(signalIn, fs, fSub, hrms)
% Perform raw signal separation using Zero-phase Principal Component
% Analysis (ZCA)
% Parameters
% ----------
% signalIn: Input signal
% fs: Sampling frequency
% fSub: Frequency subDivision to manage signals with different/unknown fs.
% Default should be = 1
% hrms: Number of harmonics considered. Generally between 1 (only
% fundamental) and 3 (first 2 harmonics)
%
% Outputs
% -------
% signalOut: Separated signal

% Hardcoded variables
nChannels = 3; % Assume RGB signals
overlap = 2; % Level of overlap in ZCA blocks. 2 = 50% overlap

% Samples and ROIs
nSamples = size(signalIn, 1);
ROIs = size(signalIn,2) / nChannels;

% Window definition
% window = round(N/order);
wLength = round(fs * 5 * fSub); % 5 seconds window
block = round(wLength/overlap/(fSub^2)); % Step update size

% Signal allocation
signalOut = zeros(nSamples, ROIs);
hannWindow = hann(wLength)'; 
compLoad = []; % DEPRECATED determine computational load in time

% Process each ROI separately
for i=0:ROIs-1
    % Temporary variables
    Fc=[]; % Peak frequency of signals
    
    % Determine step update
    step = 1:wLength;
    k = 1;
    % Process the signal
    while(step(end) <= nSamples)
        % Select a block of input
        sigBlock = [signalIn(step,i*nChannels+1:(i+1)*nChannels)];
        
        % First window
        if step(1) == 1
            tic
            % Find ZCA demixed signal
            [zeroca] = zca(sigBlock);
            % Find peak frequency
            [fc] = peakFreq(zeroca,fs);
            Fc(k,i+1) = fc;
            
            % Filter the signal tuning on the peak frequency
            [~, zeroca] = tunedFilterbank(zeroca, fc, fs, hrms);
            
            % Copy the filtered signal
            signalOut(step,i+1) = zeroca;
            compLoad = [compLoad,toc];
        else
            tic
            % Find ZCA demixed signal
            [zeroca] = zca(sigBlock);
        
            % Find peak frequency
            [fc] = peakFreq(zeroca, fs);
            
            % Control update of fc to avoid false detection
            if k>5
                fControl = median(Fc(k-4:k-1,i+1));
                if (fc > (fControl+0.2*fControl) || fc < (fControl-0.2*fControl))
                    fc = fControl;
                end
            end
            Fc(k,i+1)=fc;
            
            % Filter the signal tuning on the peak frequency
            [~, sigPresent] = tunedFilterbank(zeroca, fc, fs, hrms);
            
            % Apply Hanning filtering to update the window
            sigPresent = sigPresent.*hannWindow';
            
            % Copy the filtered signal
            signalOut(step,i+1) = [signalOut(step,i+1) + sigPresent];
            compLoad = [compLoad,toc];
        end
        
        % Refresh the step
        step = step+block;
        k = k+1;
    end
end
end

function [zeroca] = zca(signalIn)
% Find unmixing sphere using ZCA estimation and apply it to the signal
% selecting the green channel
% Parameters
% ----------
% signalIn: Input signal
%
% Outputs
% -------
% zeroca: Unmixed signal

% Find unmixing sphere
sphere = 2.0 * pinv(sqrtm(cov(signalIn)));
% Apply transformation
zeroca = signalIn * sphere;
% Select green channel
zeroca = zeroca(:,2);
end

function [fc] = peakFreq(signalIn, fs)
% Find maximum frequency peak of a signal using Welch power spectrum estimation
% Parameters
% ----------
% signalIn: Input signal
% fs: Sampling frequency
%
% Outputs
% -------
% fc: expected peak frequency

[psdOut, f] = pwelch(signalIn, length(signalIn), 0, [], fs);
[~, pos] = max(psdOut);
fc = f(pos);
end

