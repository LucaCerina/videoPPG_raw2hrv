# videoPPG: raw signal to HRV
Matlab implementation of the raw RGB to videoPPG signal and heart rate variability as from `Cerina et al., Influence of acquisition frame-rate and video compression techniques on pulse-rate variability estimation from vPPG signal, 2019` and AFCam project by `Corino et al., Computing in Cardiology (CinC), 2017`

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
* Luca Cerina, formerly Politecnico di Milano
* Professor Luca Mainardi, Politecnico di Milano
* Professor Riccardo Barbieri, Politecnico di Milano
* Luca Iozzia PhD, TeiaCare, formerly Politecnico di Milano

## To cite this work
If you use this project in a scientific paper, please cite:

```
@article{cerina2019influence,
  title={Influence of acquisition frame-rate and video compression techniques on pulse-rate variability estimation from vPPG signal},
  author={Cerina, Luca and Iozzia, Luca and Mainardi, Luca},
  journal={Biomedical Engineering/Biomedizinische Technik},
  volume={64},
  number={1},
  pages={53--65},
  year={2019},
  publisher={De Gruyter}
}
```
