%% Run
clc, clear variables, clf

iterations = 1;

acErr = 0; %Acumulated error

s = 0; %Std dev for 
E = 1;  %Signal amplitude

N = 128;

% Generate random bit sequence
bitMessage = 2*round(rand(1,2*N))-1;

% Generate random bit for the 'known' messege
knownBits = 2*round(rand(1,2*N))-1;

% Length of cyclic prefix
cyclicPref = 10;

% Filter for channel
ch = 'h2';

% Is the channel known to the reciever?
known_channel = 1;

for k = 1:iterations
    [receivedBits, errs, H_est, trueH, r, estS, S] = testSendRec(s, E, bitMessage, knownBits, N, cyclicPref, ch, known_channel);
    acErr = acErr + errs;
end

avNumOfErrors = acErr/iterations

if known_channel == 1
    H = trueH;
else
    H = H_est;
end
%% Plots

% Plot r(k) and s(k)
figure(1)
stem(bitMessage - receivedBits);

title('Difference between $r(k)$ and $s(k)$', 'Interpreter', 'latex', 'FontSize', 20);
xlabel('bit [n]', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('Defference', 'Interpreter', 'latex', 'FontSize', 16);

% Plot h(n) and est of h(n)
figure(2)
hold on
plot(abs(trueH), 'LineWidth', 1);
plot(abs(H_est), 'ro');

if strcmp(ch, 'h1')
    title('Impulse response of $h_{1}(w)$ and $\hat{h}_{1}(w)$', 'Interpreter', 'latex', 'FontSize', 20);
    ylabel('$|h_{1}(w)|$', 'Interpreter', 'latex', 'FontSize', 16);
else
    title('Impulse response of $h_{2}(w)$ and $\hat{h}_{2}(w)$', 'Interpreter', 'latex', 'FontSize', 20);
    ylabel('$|h_{2}(w)|$', 'Interpreter', 'latex', 'FontSize', 16);
end

xlabel('Sample [n]', 'Interpreter', 'latex', 'FontSize', 16);

legend('Actual', 'Estimation');

H_diff = abs(trueH) - abs(H_est);
H_err = rms(H_diff)
hold off

% Plot of phase for h(n) and est of h(n)
figure(3)
hold on
plot(angle(trueH), 'LineWidth', 1)
plot(angle(H_est), 'r')

if strcmp(ch, 'h1')
    title('Phase of $h_{1}(w)$ and $\hat{h}_{1}(w)$', 'Interpreter', 'latex', 'FontSize', 20);
else
    title('Phase of $h_{2}(w)$ and $\hat{h}_{2}(w)$', 'Interpreter', 'latex', 'FontSize', 20);
end
xlabel('Sample [n]', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('Angle [rad]', 'Interpreter', 'latex', 'FontSize', 16);

legend('Actual', 'Estimation');
hold off

% Plot of s(k), r(k) and estS(k)
figure(4)

subplot(211)
hold on
title('$|s(k)|$ and $|r(k)|$', 'Interpreter', 'latex', 'FontSize', 20);
stem(abs(S), 'Marker','.','LineWidth',1,'Color',[1 0 0])   % |s(k)|
stem(abs(r))        % |r(k)|

xlabel('Symbol [n]', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('Absolute value', 'Interpreter', 'latex', 'FontSize', 16);
legend('s(k)', 'r(k)')
hold off

subplot(212)
hold on
title('Phase of $s(k)$ and $r(k)$', 'Interpreter', 'latex', 'FontSize', 20);
stem(angle(S), 'Marker','.','LineWidth',1,'Color',[1 0 0]) % <s(k)
stem(angle(r))      % <r(k)

xlabel('Symbol [n]', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('Phase', 'Interpreter', 'latex', 'FontSize', 16);
legend('s(k)', 'r(k)')
hold off

figure(5)
subplot(211)
hold on
title('$|s(k)|$ and $|\hat{s}(k)|$', 'Interpreter', 'latex', 'FontSize', 20);
stem(abs(S), 'Marker','.','LineWidth',1,'Color',[1 0 0])   % |s(k)|
stem(abs(estS))        % |estS(k)|

xlabel('Symbol [n]', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('Absolute value', 'Interpreter', 'latex', 'FontSize', 16);
legend('s(k)', 'est. of s(k)')
hold off

subplot(212)
hold on
title('Phase of $s(k)$ and $\hat{s}(k)$', 'Interpreter', 'latex', 'FontSize', 20);
stem(angle(S), 'Marker','.','LineWidth',1,'Color',[1 0 0]) % <s(k)
stem(angle(estS))      % <estS(k)

xlabel('Symbol [n]', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('Phase', 'Interpreter', 'latex', 'FontSize', 16);
legend('s(k)', 'est. of s(k)')
hold off
