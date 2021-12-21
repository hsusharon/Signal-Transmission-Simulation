function output_data = Demodulator(input_data, freq_distort)

    for index = 1:800 
        data(index) = exp(-2j*pi*freq_distort*index) * input_data(index) * exp(-1*1j*pi*index/4);
        %data(index) = exp(-2*1j*pi*freq_distort) * input_data(index) * exp(-1*1j*pi*index/4);
        data_angle = rad2deg(angle(data(index)));
        if data_angle > -45 && data_angle < 45 
            output_data(index) = 0;
        else 
            output_data(index) = 1;
        end         
    end
    data_angle = rad2deg(angle(data));
end