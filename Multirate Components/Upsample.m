function [upsampled_data] = Upsample(data)
    k = 1;
    for i = 1:length(data)
        upsampled_data(k) = data(i);
        k = k+1;
        
        % Place 15 0s between each data point
        counter = 1;
        while counter < 16
            upsampled_data(k) = 0;
            k = k + 1;
            counter = counter + 1;
        end
    end
end

