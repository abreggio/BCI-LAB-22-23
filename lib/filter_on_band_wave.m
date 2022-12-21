function sfilt = filter_on_band_wave(bandwave, body, SampleRate)
    band = [];
    switch bandwave
        case 'mu'
            band = [10 12];
        case 'beta'
            band = [18 22];
        otherwise
            trow(MException('no such argument', 'argument bandwave invalid'))
    end

    sfilt = zeros(size(body));

    for i = 1:size(body,2)
        sfilt(:, i) = bandpass(body(:, i), band, SampleRate);
    end
end
