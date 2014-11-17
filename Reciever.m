%% OFDM

% FFT the last 128 of the signal
r = fft(y(end-128+1: end));

%% Equlizer
% Zero padding
zeroh = [h;zeros(length(r) - length(h), 1)];

% FFT filter and inverse
H = fft(zeroh);
conjH = conj(H);

% Estimation of S
r_estS = sign(real(conjH .* r));
i_estS = sign(imag(conjH .* r));

b = [];
for k = 1:128
    b = [b, r_estS(k), i_estS(k)];
end