# videoPPG-ZCA
Matlab &amp; Python implementation of the raw RGB to videoPPG signal as from Cerina et al., Influence of acquisition frame-rate and video compression techniques on pulse-rate variability estimation from vPPG signal, 2019

## Initialize repo
Clone the repo with recursive option to obtain also required submodules

`git clone --recursive https://github.com/LucaCerina/videoPPG-ZCA.git`

## Process
The proposed code converts RGB traces obtained from a video (in csv format), and optionally timestamp and motion traces, into a videoPPG signal using Zero Phase Principal Component Analysis (ZCA). The process goes as:
* Resampling, if original timestamps or sampling frequency are known
* Detrending, in order to remove low-frequency wanders in the signal
* Band-pass filtering to focus on physiological intervals of data
* ZCA demixing with filtering tuned on heart rate frequency
* Selection of best ROI based on Signal-to-Noise ratio
* Calculation of PPG peaks

## Original contributors
* Professor Luca Mainardi, Politecnico di Milano
* Professor Riccardo Barbieri, Politecnico di Milano
* Luca Iozzia PhD, TeiaCare, formerly Politecnico di Milano
