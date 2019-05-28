function [vPPGSignal, vPPGDerive, signalPeaks, signalPP] = video2PPG(filenameVideo, varargin)
% Detailed summary

% harcoded constants
fs = 256; % 256Hz frequency is arbitrary but comply with existing PPG

% Check arguments
switch nargin
    case 2
       filenameTstamp = varargin{1};
    case 3
       filenameTstamp = varargin{2};
       filenameMotion = varargin{3};
end

%% Load raw video signal from csv file
rawSignal = csvread(filenameVideo);
nRois = size(rawSignal, 2)/3; % Number of ROIs from the video, assume RGB channels

%% Load sampling timestamps from csv file
tStampflag = false; 
if exist('filenameTStamp', 'var')
    rawTstamps = csvread(filenameTstamp);
    tStampflag = true;
end

%% Load ROI movements from csv file
motionflag = false; 
if exist('filenameMotion', 'var')
    rawMotion = csvread(filenameMotion);
    avgMotion = sqrt(rawMotion(:,1:2:end-1).^2 + rawMotion(:,2:2:end).^2);
    motionflag = true;
end

%% Perform signal resampling if timestamps are available
if tStampflag
    rawSignal = signalResample(rawSignal, rawTstamps, fs);
end

%% Perform signal detrend
dtrLength = 1280; % 5 seconds in samples at 256Hz
lambda = 400;
dtrSignal = detrendSample(rawSignal, lambda, dtrLength);

%% Perform bass-pand filtering
fDown = 0.3;
fUp = 8;
filtSignal = signalFilter(dtrSignal, fs, fDown, fUp);

%% Apply ZCA demixing
hrms = 1; % Get only fundamental signal
vPPGSignal = ZCAfilter(filtSignal, fs, 1, hrms);

%% Select ROI upon SNR
[vPPGSignal, ~, ~, SNR, ~, ~] = spectrumSelector(vPPGSignal, 'NO', 256);

%% Control signal inversion
vPPGSignal = signalInversion(vPPGSignal);

%% Calculate also signal derivative, with peaks corresponding to systolic rise
vPPGDerive = robustDerive(vPPGSignal);

%% Find peaks and calculate inter-beat intervals
signalPeaks = ampdFast(vPPGDerive, 20);
signalPP = diff(unique(signalPeaks))./fs;

%% Correct inter-beat intervals
signalPP = hrvCleaner(signalPP);

end

