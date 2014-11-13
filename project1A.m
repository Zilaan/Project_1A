% Project 1A
%% Generate bit sequence length 2N = 2x128

sig = [-1,1];

N = 128;
bitSeq = zeros(1,2*N);

for n = 1:2*N
    bitSeq(n) = sig(randi(2));
end

%% Encode bitSeq into QPSK
E = 2;
Svector = zeros(1,N);

b = @(re,im) sqrt(E/2)*(re + 1i*im);

for h = 1:N-1
   Svector(h) = b(bitSeq(h),bitSeq(h+1));   
end

%% Generate z(n)

z = zeros(1,N);

for n = 0:N-1
   for k = 0:N-1
       z(n+1) = z(n+1) + (1/N)*Svector(k+1)*exp(1i*2*pi*k*n/N);
   end
end

Fs = ifft(Svector);


%% cycklic_prefix

cyclic_prefix = z(end-40:end);

%% Discrete Time impulse response of H1

h1 = zeros(1,60);

for n = 0:59
   h1(n+1) = 0.8^(n); 
end

h1W = fft(h1);
stem(abs(h1W))


