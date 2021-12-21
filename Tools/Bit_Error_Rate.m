function [BER] = Bit_Error_Rate(Tx_Data, Rx_Data)
    % Computes how many bits were 
    BER = 1-(sum(Tx_Data == Rx_Data)/length(Tx_Data));
end

