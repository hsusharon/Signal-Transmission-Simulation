% Returns the FIR coefficients of the RRC Filter
% Corresponding to Rolloff Factor (rf), Span, and Samples Per Symbol (sps) 
function [impulseResp] = Filter(rf, span, sps)
    impulseResp = rcosdesign(rf,span,sps,'sqrt');
    % Tool to visually analyze the discrete time filter
%     fvtool(impulseResp,'impulse')
    % Tool to analyze the power spectrum of the impulse response
%     pspectrum(impulseResp)
end

