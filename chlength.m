function [] = chlength()
% This is a test function which tests the real function, chlengthREAL.
% A channel is generated as well as noise, which are then sent to the
% function together with the amplitude of the impulse, as well as the
% percentage threshold for channel length. 

% True Channel 
h = zeros(1,128);
h(1) = 0.5;
h(9) = 0.5;

% Noise with mean 0 & std.dev gt
gt = 0.05;
rn = gt.*randn(1,length(conv(h,h)));

channel = h;
noise = rn;
amplitude = 1;
alpha = 0.15;

disp(chlengthREAL(noise, channel, amplitude, alpha))
end



function [length] = chlengthREAL(noise, channel, amp, alpha)
% Used for calculating channel length. 
ch = channel; % Channel  

imp = zeros(1,128); % pulse of width 1 sample
A = amp; % pulse of width 1 sample, amplitude amp
imp(1) = A;

res = conv(ch,imp) + noise; % Resulting conv

% Amplitude change compared to impulse amplitude A, means removed
roc = (res - mean(res))./A; % Resulting value is precentage. 

% Acceptable percentage of diff. against zero (noise threshold). 
cycLength = find(roc > alpha,1,'last');
length = cycLength;

stem(roc)

end



