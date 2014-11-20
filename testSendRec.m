function [b, numOfErrors, H_est, trueChannel] = testSendRec(sigmaIn, amp, sentBits, knownBits, n, cycP, channel, known_channel)

    bitSeq = sentBits;

    N = n;
    E = amp;

    % Allocate memory
    Svector = zeros(1, N);
    knownVector = zeros(1, N);

    % Handel to generate QPSK
    b = @(re,im) sqrt(E/2)*(re + 1i*im);

    % Encode Seq into QPSK
    for h = 1:N
        Svector(h) = b(bitSeq(2*h - 1), bitSeq(2*h));
        knownVector(h) = b(knownBits(2*h - 1), knownBits(2*h));
    end

    % OFDM - Generate z(n) and known
    z = ifft(Svector);
    knownZ = ifft(knownVector);

    % Add cyclic_prefix to signal and known signal
    cyclic_prefix = z(end - cycP + 1:end);
    zz = [cyclic_prefix z].';

    cyclic_prefix = knownZ(end - cycP + 1:end);
    knownZZ = [cyclic_prefix knownZ].';

    % Channel select
    h1 = zeros(1,60);
    for n = 0:59
        h1(n+1) = 0.8^(n);
    end

    h2 = zeros(1,9);
    h2(1) = 0.5;
    h2(9) = 0.5;

    if strcmp(channel, 'h1')
       h = h1';
    elseif strcmp(channel, 'h2')
       h = h2';
    end


    % Generate noise

    % Length of conv signal
    y_len = length(zz) + length(h) - 1;
    known_y_len = length(knownZZ) + length(h) - 1;

    % Weigth of noise
    sigma = sigmaIn;

    % Noise for known and unknown signal
    known_w = 1/sqrt(2)*sigma*(randn(known_y_len, 1) + 1i*randn(known_y_len, 1));
    w = 1/sqrt(2)*sigma*(randn(y_len, 1) + 1i*randn(y_len, 1));

    % Filter through channel when sending
    y = conv(h, zz) + w;
    known_y = conv(h, knownZZ) + known_w;

    % OFDM^1
    % FFT the last 128 of the signal
    r = fft( y((cycP + 1):128 + cycP) );
    known_r = fft( known_y((cycP + 1):128 + cycP) );

    % Estimate filter
    s = knownVector.';
    H_est = known_r./s;

    % FFT filter and inverse
    H = fft(h,128);
    trueChannel = H;

    % Is the channel know to us?
    %   If not: use estimation of channel for decoding
    if known_channel == 1
        % Real channel
        conjH = conj(H);
    else
        % Estimation of channel
        conjH = conj(H_est);
    end

    % Estimation of S for known and unknown signal
    r_estS = sign(real(conjH .* r));
    i_estS = sign(imag(conjH .* r));

    % Decode QPSK to bits
    b = [];
    for k = 1:128
        b = [b, r_estS(k), i_estS(k)];
    end

    % Diff between true and recieved bits
    bb = b - bitSeq;

    % Number of errors after decoding
    numOfErrors = sum(bb(:) ~= 0);
end