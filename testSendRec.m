function [b, numOfErrors, H_est, trueChannel] = testSendRec(sigmaIn, amp, sentBits, n, cycP, channel)

bitSeq = sentBits;
% Encode bitSeq into QPSK
N = n;
E = amp;
Svector = zeros(1,N);
b = @(re,im) sqrt(E/2)*(re + 1i*im);
for h = 1:N
    % Svector(h) = b(bitSeq(h),bitSeq(h+1));
    Svector(h) = b(bitSeq(2*h-1),bitSeq(2*h));
end
% OFDM - Generate z(n)
z = ifft(Svector);

% add cyclic_prefix to signal
cyclic_prefix = z(end-cycP+1:end);
zz = [cyclic_prefix z].';

% Channel select
h1 = zeros(1,60);
for n = 0:59
    h1(n+1) = 0.8^(n);
end

h2 = zeros(1,9);
h2(1) = 0.5;
h2(9) = 0.5;

if strcmp(channel, 'h1')
   h = h1';
elseif strcmp(channel, 'h2')
   h = h2';
end
    

% Generate noise
% Length of conv signal
y_len = length(zz) + length(h) - 1;
% Create noise of lenght y_len
sigma = sigmaIn;
w = 1/sqrt(2)*sigma*(randn(y_len,1) + 1i*randn(y_len,1));
% Filter through channel
y = conv(h, zz) + w;

% OFDM^1
% FFT the last 128 of the signal

r = fft(y((cycP+1):128+cycP));

% Equalizer
% Zero padding

% FFT filter and inverse
% H = fft(zeroh);
H = fft(h,128);
trueChannel = H;
conjH = conj(H);
% Estimation of S

r_estS = sign(real(conjH .* r));
i_estS = sign(imag(conjH .* r));
b = [];

for k = 1:128
    b = [b, r_estS(k), i_estS(k)];
end

bb = b-bitSeq;

numOfErrors = sum(bb(:) ~= 0);

s = Svector.';
H_est = r./s;

% hold on
% plot(abs(H_est));
% plot(abs(H), 'r')

end