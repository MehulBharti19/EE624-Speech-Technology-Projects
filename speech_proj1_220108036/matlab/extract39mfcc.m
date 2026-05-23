function feat39 = extract39mfcc(wavFile)

[x,fs]=audioread(wavFile);

if size(x,2)>1
 x=mean(x,2);
end

x=x/(max(abs(x))+eps);

%% Pre-emphasis
x=filter([1 -0.97],1,x);

%% Framing
frameLen=round(0.025*fs);
hop=round(0.010*fs);

N=length(x);

numFrames=floor((N-frameLen)/hop)+1;

frames=zeros(frameLen,numFrames);

for i=1:numFrames
 s=(i-1)*hop+1;
 e=s+frameLen-1;
 frames(:,i)=x(s:e);
end

%% Manual Hamming
n=(0:frameLen-1)';
w=0.54-0.46*cos(2*pi*n/(frameLen-1));

frames=frames.*w;

%% FFT
NFFT=512;

spec=abs(fft(frames,NFFT)).^2;

spec=spec(1:NFFT/2+1,:);

%% Mel Filters
M=26;

melMax=2595*log10(1+(fs/2)/700);

mel=linspace(0,melMax,M+2);

hz=700*(10.^(mel/2595)-1);

bin=floor((NFFT+1)*hz/fs);

fb=zeros(M,NFFT/2+1);

for m=2:M+1

 for k=bin(m-1):bin(m)
   fb(m-1,k+1)=...
   (k-bin(m-1))/...
   (bin(m)-bin(m-1)+eps);
 end

 for k=bin(m):bin(m+1)
   fb(m-1,k+1)=...
   (bin(m+1)-k)/...
   (bin(m+1)-bin(m)+eps);
 end

end

melEnergy=log(fb*spec+eps);

%%Manual DCT 
[numFilters,numFrames]=size(melEnergy);

numCoeff=13;
c=zeros(numCoeff,numFrames);

for k=1:numCoeff
 for n=1:numFilters

   c(k,:)=c(k,:)+...
   melEnergy(n,:).*...
   cos(pi*(k-1)*(2*n-1)/(2*numFilters));

 end
end

%% Delta
delta=zeros(size(c));

for t=2:size(c,2)-1
 delta(:,t)=...
 (c(:,t+1)-c(:,t-1))/2;
end

%% Delta-delta
delta2=zeros(size(c));

for t=2:size(c,2)-1
 delta2(:,t)=...
 (delta(:,t+1)-delta(:,t-1))/2;
end

feat39=[c;delta;delta2];

end