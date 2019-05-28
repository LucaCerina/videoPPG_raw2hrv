function [peaksPos, peaksVal] = ampdFast(signalIn, varargin)
% Perform peak identification using AMPD algorithm 
% Parameters
% ----------
% signalIn: Input signal
% varargin: Order of subdivisions to be performed, default to 10
%
% Outputs
% -------
% peaksPos: Position (in samples) of peaks
% peaksVal: Value of found peaks

% Check input variables
nVar = length(varargin);
% Order of subdivision
sigSize = size(signalIn,1);
if(nVar > 0)
    order = varargin{1};
else
    order = 10;
end
N = floor(sigSize / (2*order)); % TODO it could be done better
% Control on the N divisor
if(mod(sigSize, N) ~= 0)
    div = unique(cumprod(perms(factor(sigSize)),2));
    order = div(abs(div - order) == min(abs(div - order)));
    N = sigSize / order;
end

% Calculation of peaks in sub-blocks
peaksPos = [];
for i=1:N:length(signalIn)-N
    %display(length(peaks));
    pks_temp = ampd(signalIn(i:i+2*N-1));
    peaksPos = [peaksPos pks_temp+i-1];
end

% Eliminate double peaks
peaksPos = unique(peaksPos);

% Extract peak values
peaksVal = signalIn(peaksPos);

end

function varargout = ampd(Signal)
%AMPD Automatic Multiscale-based Peak Detection
%   INPUTS:
%       Signal [*] - This is a real vector containing the data from the
%                    maxima will be found.
% 
%   OUTPUTS:
%       index     - The indicies of the identified peaks in "Signal".
% 
%   USAGE:
%       [index] = ampd(Signal)
%                 Returns the indicies of local maxima detected in 
%                 'Signal'.
% 
%   REFERENCES:
%       [ 1 ] Scholkmann F., Boss J. and Wolf M. "An Efficient Algorithm 
%             for Automatic Peak Detection in Noisy Periodic and 
%             Quasi-Periodic Signals." Algorithms 2012, 5, 588-603;
%             doi:10.3390/a5040588.
% 
	narginchk(1,1);
    nargoutchk(0,1);

    if ~isvector(Signal) || isscalar(Signal)
        error('Input argument ''Signal'' must be a vector')

    elseif ~isfloat(Signal)
        error('Class of input argument ''Signal'' must be ''double''')

    elseif ~isrow(Signal)
        Signal = Signal';

    end

    time = 1:numel(Signal);

    [fitPolynomial,fitError] = polyfit(time,Signal,1);
    [fitSignal,~] = polyval(fitPolynomial,time,fitError);

    dtrSignal = Signal - fitSignal;

    N = length(dtrSignal);
    L = ceil(N/2.0)-1;

    RNG = RandStream('mt19937ar');
    LSM = 1 + ones(L,N,'int8');

    for k=1:L
        for i=k+2:N-k+1
            if(Signal(i-1)>Signal(i-k-1) && Signal(i-1)>Signal(i+k-1))
                LSM(k,i) = 0;
            end
        end
    end

	G = sum(LSM,2);
    [~,l] = min(G);

    LSM = LSM(1:l,:);

    S = sum(LSM);

    varargout{1} = find(S==0)-1;
end