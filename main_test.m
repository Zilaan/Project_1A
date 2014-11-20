%% Run
clc, clear variables, clf

iterations = 1;

acErr = 0; %Acumulated error

s = 0; %Std dev for 
E = 1;  %Signal amplitude

N = 128;

bitMessage = 2*round(rand(1,2*N))-1;
cyclicPref = 10;
ch = 'h2';
for k = 1:iterations

[receivedBits, errs, H_est, H] = testSendRec(s, E, bitMessage, N, cyclicPref, ch);

acErr = acErr + errs;

end

avNumOfErrors = acErr/iterations

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
    title('Impulse response of $h_{1}(n)$ and $\hat{h}_{1}(n)$', 'Interpreter', 'latex', 'FontSize', 20);
    ylabel('$|h_{1}(n)|$', 'Interpreter', 'latex', 'FontSize', 16);
else
    title('Impulse response of $h_{2}(n)$ and $\hat{h}_{2}(n)$', 'Interpreter', 'latex', 'FontSize', 20);
    ylabel('$|h_{2}(n)|$', 'Interpreter', 'latex', 'FontSize', 16);
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
    title('Phase of $h_{1}(n)$ and $\hat{h}_{1}(n)$', 'Interpreter', 'latex', 'FontSize', 20);
else
    title('Phase of $h_{2}(n)$ and $\hat{h}_{2}(n)$', 'Interpreter', 'latex', 'FontSize', 20);
end
xlabel('Sample [n]', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('Angle [rad]', 'Interpreter', 'latex', 'FontSize', 16);

legend('Actual', 'Estimation');
hold off