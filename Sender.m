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
%    Svector(h) = b(bitSeq(h),bitSeq(h+1));   
       Svector(h) = b(bitSeq(2*h-1),bitSeq(2*h));   

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

cyclic_prefix = z(end-40+1:end);
zz = [cyclic_prefix z].';

%% Discrete Time impulse response of H1

h1 = zeros(1,60);

for n = 0:59
   h1(n+1) = 0.8^(n); 
end
h = h1';

%% Generate noise

% Length of conv signal
y_len = length(zz) + length(h) - 1;

% Create noise of lenght y_len
sigma = 0.01;
w = 1/sqrt(2)*sigma*(randn(y_len,1) + 1i*randn(y_len,1));

%% Filter through channel

y = conv(h, zz);