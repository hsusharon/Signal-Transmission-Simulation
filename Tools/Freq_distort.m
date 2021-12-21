function freq_distort = Freq_distort(input_data)
    for index = 1:128
        cos_data(index) = input_data(index);
    end

    cos_data = fft(cos_data);
    figure(); plot(abs(cos_data));
    [M, I] = max(abs(cos_data));
    freq_distort = (I-17)*125;
    
end