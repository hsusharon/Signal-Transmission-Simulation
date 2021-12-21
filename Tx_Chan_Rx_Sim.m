function [BER, Estimates] = Tx_Chan_Rx_Sim(Filter_Params,Uncertainty_Params)
    %% Signal Description
    len = 50;       % msec
    fs  = 16000;    % Hz

    total_len    = 800;     % Bits
    tone_len     = 128;     % Bits - Continuous WF or tone at 0 freq (All "1")
    key_len      = 8;       % Bits - A key for some future use (All "0" for now)
    rnd_data_len = 664;     % Bits - Random data (throughput = 83%)
    throughput   = .83;

    %% Transmitter & Modulator
    tone = ones(1,tone_len);
    key  = zeros(1,key_len);
    % Generates a random list of 0 and 1 non-uniformly depending on desired
    % throughput
    rnd_data = Rand_Data_Gen(rnd_data_len, throughput);

    % Combine the cosine, key and randomly generated data
    data = [tone key rnd_data];

    % Apply pi/4 BPSK Modulation, Upsample and filter the input signal
    Base_Band_Sig = Transmitter(data, Filter_Params);

    %% Channel
    % Apply time delay, frequency uncertainty and noise to the transmitted
    % signal
    Channeled_Sig = Channel(Base_Band_Sig, Uncertainty_Params);

    %% Reciever
    % Detect and remove time delay & freq. uncertainty, then demodulate the
    % and reconstruct the transmitted data
    [Recieved_data,Estimates] = Reciever(Channeled_Sig, Filter_Params);


    % Compute the bit error rate
    BER = Bit_Error_Rate(data, Recieved_data);
end

