function mov_mean = moving_mean(body, window_size)

    mov_mean = zeros(size(body));
    
    to_convolve = ones(1, window_size);
    
    for i = 1:size(body, 2)

        mov_mean(:, i) = conv(body(:, i), to_convolve, 'same') / 512;

    end

end
