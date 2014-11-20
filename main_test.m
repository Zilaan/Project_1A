%% Run
clc, clear variables, clf, close all

iterations = 100;

acErr = 0; %Acumulated error

s = 0; %Std dev for noise. Our 4 values: [0,0.01,0.05 0.1] 
E = 1;  %Signal amplitude. Always 1!

M = 0; % Shift,  (to make a synchronization error)
%negative integer to get from the prefix.
%poistive integer to get samples from the next OFDMsegment

N = 128;

bitMessage = 2*round(rand(1,2*N))-1;
cyclicPref = 60;
ch = 'h1';
for k = 1:iterations

[receivedBits, errs, H_est, H] = testSendRec(s, E, bitMessage, N, cyclicPref, ch, M);

acErr = acErr + errs;

end

avNumOfErrors = acErr/iterations
avErrorRate = avNumOfErrors/(N*2)

%% Plots

% Plot r(k) and s(k)
figure(1)
stem(bitMessage-receivedBits);

title('Difference between $r(k)$ and $s(k)$', 'Interpreter', 'latex', 'FontSize', 20);
xlabel('bit [n]', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('Defference', 'Interpreter', 'latex', 'FontSize', 16);

% Plot h(n) and est of h(n)
figure(2)
hold on
plot(abs(H), 'LineWidth', 1);
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

H_diff = abs(H)-abs(H_est);
H_err = rms(H_diff)
hold off

% Plot of phase for h(n) and est of h(n)
figure(3)
hold on
plot(angle(H), 'LineWidth', 1)
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