function feat39 = extract39mfcc(wavFile)

wavFile = char(wavFile);
wavFile = strtrim(wavFile);

%fprintf('Opening %s\n',wavFile);

[x,fs]=audioread(wavFile);

if size(x,2) > 1
    x = mean(x,2);
end

x = x / (max(abs(x)) + eps);

% Pre-emphasis
x = filter([1 -0.97], 1, x);

% Frame settings
frameLen = round(0.025 * fs);   % 25 ms
hop      = round(0.010 * fs);   % 10 ms

N = length(x);
numFrames = floor((N - frameLen)/hop) + 1;

frames = zeros(frameLen, numFrames);

for i = 1:numFrames
    s = (i-1)*hop + 1;
    e = s + frameLen - 1;
    frames(:,i) = x(s:e);
end

% Manual Hamming window
n = (0:frameLen-1)';
w = 0.54 - 0.46*cos(2*pi*n/(frameLen-1));
frames = frames .* w;

% FFT power spectrum
NFFT = 512;
spec = abs(fft(frames, NFFT)).^2;
spec = spec(1:NFFT/2+1, :);

% Mel filter bank
M = 26;
melMax = 2595*log10(1 + (fs/2)/700);
melPts = linspace(0, melMax, M+2);
hzPts  = 700*(10.^(melPts/2595) - 1);
bins   = floor((NFFT+1) * hzPts / fs);

fb = zeros(M, NFFT/2+1);

for m = 2:M+1
    left  = bins(m-1);
    center = bins(m);
    right = bins(m+1);

    for k = left:center
        fb(m-1, k+1) = (k-left) / (center-left + eps);
    end

    for k = center:right
        fb(m-1, k+1) = (right-k) / (right-center + eps);
    end
end

melEnergy = log(fb * spec + eps);

% Manual DCT (13 coefficients)
[numFilters, numFrames] = size(melEnergy);
numCoeff = 13;

n = 0:numFilters-1;
k = 0:numCoeff-1;
D = cos((pi/numFilters) * (n' + 0.5) * k);
c = D' * melEnergy;   % 13 x T

% Delta
delta = zeros(size(c));
for t = 2:size(c,2)-1
    delta(:,t) = (c(:,t+1) - c(:,t-1)) / 2;
end

% Delta-delta
delta2 = zeros(size(c));
for t = 2:size(c,2)-1
    delta2(:,t) = (delta(:,t+1) - delta(:,t-1)) / 2;
end

feat39 = [c; delta; delta2];

end