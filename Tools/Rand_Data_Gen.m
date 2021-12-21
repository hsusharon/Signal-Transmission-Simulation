% Generates a random list of 0 and 1 non-uniformly
function [Rand_Data] = Rand_Data_Gen(Len, Throughput)
    Rand_Data           = ones(1,Len);
    Zeros_Needed        = floor(Len * (1 - Throughput));
    
    % Randomly determine which indices should be 0 s.t only a percentage
    % corresponding to the throughput is 1's and the rest 0.
    Rand_Idx            = randperm(Len, Zeros_Needed);
    Rand_Data(Rand_Idx) = 0;
end

