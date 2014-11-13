clc, clear variables, close all
tu = 0.01;
N = 128;
bk = round(rand(1,N))*2-1;
bk2 = round(rand(1,N))*2-1;
E = 1;
s = sqrt(E/2)*[bk + 1i*bk2];
fs = 100000; %3.7966e+04/(2*pi);
ts = 1/fs;
t = 0:ts:0.1;
df = 1/tu;
w0 = 2*pi*1000;
x = zeros(size(t));
xt = zeros(size(t));
for i = 1:N
   w = (i-1)*df + w0;
   if real(s(i)) > 0 && imag(s(i)) > 0
      xt = cos(w*t + pi/4);
      
   elseif real(s(i)) < 0 && imag(s(i)) > 0
      xt = cos(w*t + 3*pi/4);
        i
   elseif real(s(i)) < 0 && imag(s(i)) < 0
      xt = cos(w*t + 5*pi/4);
   
   elseif real(s(i)) > 0 && imag(s(i)) < 0
      xt = cos(w*t + 7*pi/4);
   end
   x = x + xt;
%     w = w + 
end

% plot(t,x)
f = fft(x);
hold on
% stem(real(f))
% stem(imag(f), 'r')

% omega 

F = abs(f);
phi = angle(f);

% stem(F)
% figure
% stem(phi, 'r')
