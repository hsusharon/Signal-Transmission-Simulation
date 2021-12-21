function [Modulated_Sig] = Modulator(data)
    for k = 1:length(data)
        % Converts data from bits 0 or 1 -> -1 or 1
        Bipolar_Sig = 1-2*data(k);
        % Modulate the signal by e^jpik/4
        Modulated_Sig(k) = Bipolar_Sig *exp(1j*pi*k/4);
    end
end

