function freq_distort = Freq_Distort_Detect(input_data)
    
    for index = 1:128
        cos_data(index) = input_data(index);
    end

    cos_data = fft(cos_data);
        
    [M, I] = max(cos_data);
    freq_distort = (I-17)*125;
    
end