function [NoisyChanneledSig] = Channel(Base_Band_Sig, Uncertainty_Params)
    NumSamples      = length(Base_Band_Sig);

    % Extract the uncertainty parameters to be used by the channel
    Rand_Freq_Uncert  = Uncertainty_Params(1); 
    Rand_Phase_Uncert = Uncertainty_Params(2);
    Rand_Time_Uncert  = Uncertainty_Params(3);
    
    % Construct the vector that contains delay... start position of
    % delayed signal is originally 641 
    DistortedSig    = zeros(1,length(Base_Band_Sig) + 2*640);
    start            = 640;
    
    for i = 1:NumSamples        
        Rand_Freq_Component  =  exp(1j*2*pi*Rand_Freq_Uncert*i/(16*16000));
        % Currently Rand Phase is disabled... this will evaluate to 1
        Rand_Phase_Component = exp(1j*Rand_Phase_Uncert);
        DistortedSig(start+i+Rand_Time_Uncert) = Rand_Freq_Component*Rand_Phase_Component*Base_Band_Sig(i);
    end
    
    % Adds Gaussian Noise to the time delayed, freq shifted Base Band
    % Signal
    SNR = Uncertainty_Params(4); 
    NoisyChanneledSig = awgn(DistortedSig, SNR);
%     NoisyChanneledSig = DistortedSig;
end

