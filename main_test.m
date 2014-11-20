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

figure(1)
stem(bitMessage-receivedBits);

title('Difference between decoded and actual', 'Interpreter', 'latex', 'FontSize', 20);
xlabel('bit [n]', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('Defference', 'Interpreter', 'latex', 'FontSize', 16);

figure(2)
hold on
plot(abs(H));
plot(abs(H_est), 'ro');

title('Estimation and true value of $h_{x}(n)$', 'Interpreter', 'latex', 'FontSize', 20);
xlabel('Samples [n]', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('$|h_{x}(n)|$', 'Interpreter', 'latex', 'FontSize', 16);
legend('Actual', 'Estimation');

H_diff = abs(H)-abs(H_est);
H_err = rms(H_diff)