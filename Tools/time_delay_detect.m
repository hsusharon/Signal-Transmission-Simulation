function t0 = time_delay_detect(input_data)
    max_fft = -1000;
    for index = 1:15 %%find the fft of every 16 index
        position = 0;
        while 16*position+index < length(input_data)
            data(position+1) = input_data(16*position+index);
            position = position + 1 ;
        end
        fft_data = fft(data);  %%find fft
        %figure(); plot(abs(fft_data));
        [M, I] = max(fft_data);
        if max_fft < abs(M)
            max_fft = abs(M);
            t0 = index;
        end
        
        clear data;
    end
end