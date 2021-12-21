% Returns the FIR coefficients of the RRC Filter 
function [impulseResp] = Filter()
    % Rolloff factor
    rf = .35;
    % # of Symbols
    span = 3;
    % Samples per Symbol
    sps = 16;

    impulseResp = rcosdesign(rf,span,sps,'sqrt');
    % Tool to visually analyze the discrete time filter
%     fvtool(impulseResp,'impulse')
    % Tool to analyze the power spectrum of the impulse response
%     pspectrum(impulseResp)
end

