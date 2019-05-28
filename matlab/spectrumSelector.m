function [signalOut, selectIndex, fVideo, SNR, freq, power]=spectrumSelector(signalIn, fig, varargin)
% Select a ROI to be used for further processing as the one with the
% highest SNR
% Parameters
% ----------
% signalIn: Input signal
% fig: plot the result ('YES') do not plot otherwise
% varargin: sampling frequency and ECG frequency (if available)
%
% Outputs
% -------
% signalOut: Selected signal
% selectIndex: Selection index
% fVideo: Peak frequency of the selected ROI
% SNR: Signal-to-Noise ratio of the channels
% freq: Frequency of the power spectrum
% power: Power of the power spectrum


% Check varargin
NumVar=length(varargin);
switch NumVar
    case 0
        fs = 60;
        fECG = 0;
    case 1
        fs = varargin{1};
        fECG = 0;
    case 2
        fs = varargin{1};
        fECG = varargin{2};
end

% Iterate all the channels
for i = 1:size(signalIn,2)
    % Estimate power spectrum (4 windows subdivision)
    [power, freq] = pwelch(signalIn(:,i), round(size(signalIn,1)/4), round(size(signalIn,1)/4*0.5), size(signalIn,1), fs);
    % Compare the SNR
    [SNR(i,1), fVideo(i,1)] = SNR_comp(power, freq);
end

% Select the index with maximum SNR
selectIndex = [];
[~,selectIndex] = max(SNR);

% Copy the output signal
signalOut = signalIn(:,selectIndex);
fVideo = fVideo(selectIndex);

% Plot the spectrum
if strcmp(fig,'YES')
    display(fVideo);
    display(SNR');
    %display(z_score');
    [power, freq]=pwelch(signalIn(:,selectIndex),round(size(signalIn,1)/4),round(size(signalIn,1)/4*0.5),size(signalIn,1),fs);
    figure,plot(freq,power),xlabel('frequenza [Hz]'),ylabel('potenza [s^2/ Hz]');
    hold all,stem(fVideo,max(power)),stem(fECG,max(power));
    xlim([0 8]);
    legend('potenza','potenza massima','freq ECG');
end
end


function [SNR, fMax] = SNR_comp(pot, f)
% Calculate the SNR of a heart rate power spectrum
% Parameters
% ----------
% pot: power spectrum values
% f: frequency vector
%
% Outputs
% -------
% SNR: SNR of the spectrum
% fMax: frequency of the peak in the spectrum

% Find index of the spectrum peak
[~, ind] = max(pot);

% Check if the frequency of the peak falls in physiological boundaries
if f(ind)>2.5 || f(ind)<0.5
    SNR = 0;
    fMax = f(ind);
else
    % Find frequency boundaries
    f1 = find(f>=f(ind)-0.15*f(ind),1,'first');
    f2 = find(f<=f(ind)+0.15*f(ind),1,'last');
    X_first = [f1:f2];
    X_sec = 2 * [f1:f2];
    
    % Very low sampling correction
    X_sec(find(X_sec == size(f, 1)):end) = [];
    f_lim = find(f>=5,1,'first');
    S = trapz(X_first,pot(X_first)) + trapz(X_sec,pot(X_sec));
    N = trapz([1:f1],pot([1:f1])) + trapz([f2:2*f1],pot([f2:2*f1])) + trapz([2*f2:f_lim],pot([2*f2:f_lim]));
    
    % Output SNR
    SNR = 10 * log10(S/N);
    fMax = f(ind);
end
end