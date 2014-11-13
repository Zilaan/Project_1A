% Discrete filter analysis 

%% H_2

s = tf('s');
DT = 1;
H = 0.5*(1 + exp(-s*DT*8));
%bode(H)

step(H)

%%

s = tf('s');
DT = 1;

H1 = 0;

for n = 0:59
   H1 = H1 + 0.8^(n)*exp(-s*DT*n); % s = jw 
end

%step(H1)
bode(H1)

%%
z = tf('z');
DT = 1;

H1 = 0;
disp('te')
for n = 0:59
   H1 = H1 + 0.8^(n)*z^(-n); % s = jw 
end

%step(H1)
bode(H1)

%%

H1approx = (1 + z^(-30));
%step(H1approx)
bode(H1approx)

% We choose the last Nh values because the resulting signal Nh+N will still
% be periodic. 
