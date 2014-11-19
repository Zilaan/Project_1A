function [b, numOfErrors, H_est, trueChannel] = testSendRec(sigmaIn, amp, sentBits, n)

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
% Generate z(n)
z = zeros(1,N);
for n = 0:N-1
    for k = 0:N-1
        z(n+1) = z(n+1) + (1/N)*Svector(k+1)*exp(1i*2*pi*k*n/N);
    end
end
Fs = ifft(Svector);
% cyclic_prefix 60
% cyclic_prefix = z(end-40+1:end);
cyclic_prefix = z(end-60+1:end);
zz = [cyclic_prefix z].';
% Discrete Time impulse response of H1

h1 = zeros(1,60);
for n = 0:59
    h1(n+1) = 0.8^(n);
end
h = h1';
   

% Generate noise
% Length of conv signal
y_len = length(zz) + length(h) - 1;
% Create noise of lenght y_len
sigma = sigmaIn;
w = 1/sqrt(2)*sigma*(randn(y_len,1) + 1i*randn(y_len,1));
% Filter through channel
y = conv(h, zz) + w;

% OFDM
% FFT the last 128 of the signal

r = fft(y(61:128+60));

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