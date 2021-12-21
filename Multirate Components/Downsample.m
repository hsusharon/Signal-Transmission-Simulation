function [downsampled_data] = Downsample(data, t0)
    % Only take every 16 samples 
    idx = 1;
    while 16*(idx-1)+t0 < length(data)
       downsampled_data(idx) =  data(16*(idx-1)+t0);
       idx = idx + 1;
    end
end
