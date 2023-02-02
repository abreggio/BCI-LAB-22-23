function output = logBP(body,SampleRate)
% take as input filtered eeg data and returns the Logarithmic Band Power

% squaring

body = power(body,2);

% average over 1s

timewin = 1;
body_avg = moving_mean(body,timewin,SampleRate);

% Natural Logarithm

output = log(body_avg);

end