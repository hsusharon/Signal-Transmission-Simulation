clear;
close all;
addpath('./Tools');
addpath('./Comm Components');
addpath('./Multirate Components/');

Experiment_Number = 4;

%% Filter Parameters
rf              = .35;             % Rolloff factor
span            = 3;               % # of Symbols
sps             = 16;              % Samples per Symbol
Filter_Params   = [rf span sps];


if Experiment_Number == 1
    %% Experiment 1: SNR = 100dB, f0 = 0Hz, Time Delay = -2.5 to 2.5 msec, step size = .0625 msec
    Start       = -2.5;
    Stop        = 2.5;
    Step_Size   = .0625;
    Num_Steps   = (Stop - Start)/Step_Size; 
    Num_Sims    = 1000;
    Time_Delays = Start:Step_Size:Stop;

    All_Time_Est    = zeros(Num_Steps,Num_Sims);
    FER             = zeros(Num_Steps,Num_Sims);
    for i = 1:Num_Steps+1
        for j = 1:Num_Sims   
            %%Channel Uncertainty Parameters
            % This generates a random value between -1500 and 1500 for our 
            % f0 (random frequency uncertainty) in Hz
            Rand_Freq_Uncert  = 0;

    %         % This generates a random value between 0 and 2Pi for our
    %         % f0 (random phase) in radians  
    %         Rand_Phase_Uncert = 2*pi*rand(1, 1);
    %         % Temporarily overwrite with 0
            Rand_Phase_Uncert = 0;

            % Extract the current time delay between -2.5 and 2.5 msec
            Curr_Delay_MSEC = Time_Delays(i);

            % Multiply the current time delay in msec by 16 cycles/msec to get number
            % of cycles (bits) before upsample
            Curr_Delay_BITS = Curr_Delay_MSEC*16;

            % Multiply the current time delay in bits by 16 to get the correct
            % time delay for after Upsampling... (being applied to channel data
            % after upsampling occurs)
            Curr_Delay_BITS = Curr_Delay_BITS*16;
            
            Rand_Time_Uncert = Curr_Delay_BITS;

            % SNR of the channel
            SNR = 100;

            Uncertainty_Params = [Rand_Freq_Uncert Rand_Phase_Uncert Rand_Time_Uncert SNR];

            % Runs the Tx, Channel, and Rx with specified parameters
            [BER,Estimates] = Tx_Chan_Rx_Sim(Filter_Params,Uncertainty_Params);
            
            Time_Delay_Estimate     = Estimates(1);
            All_Time_Est(i,j)       = Time_Delay_Estimate;

            if BER == 0
               FER(i,j) = 0;
            else
                FER(i,j) = 1;
            end

        end
    end
    
    Mean_Time_Uncertain = mean(All_Time_Est, 2);
    Std_Time_Uncertain = std(All_Time_Est, 0, 2);
    figure();plot(Time_Delays.', Mean_Time_Uncertain); xlabel('Time Delays(Samples)');ylabel('Mean of Time Uncertain');title('Mean of Time uncertains');
    figure();plot(Time_Delays.', Std_Time_Uncertain); xlabel('Time Delays(Samples)');ylabel('STD of Time Uncertain');title('STD of Time uncertains');


elseif Experiment_Number == 2

    %% Experiment 2: SNR = 100dB, Time Delay = 0, f0 = -1500Hz to 1500Hz, step size = 125 Hz
    Start       = -1500;
    Stop        = 1500;
    Step_Size   = 125;
    Num_Steps   = (Stop - Start)/Step_Size; 
    Num_Steps   = Num_Steps + 1;
    Num_Sims    = 1000;
    Freq_OffSet = Start:Step_Size:Stop;

    All_Freq_Est    = zeros(Num_Steps,Num_Sims);
    FER             = zeros(Num_Steps,Num_Sims);
    for i = 1:Num_Steps
        for j = 1:Num_Sims   
            %%Channel Uncertainty Parameters
            % This generates a random value between -1500 and 1500 for our 
            % f0 (random frequency uncertainty) in Hz
            Rand_Freq_Uncert  = Freq_OffSet(i);

    %         % This generates a random value between 0 and 2Pi for our
    %         % f0 (random phase) in radians  
    %         Rand_Phase_Uncert = 2*pi*rand(1, 1);
    %         % Temporarily overwrite with 0
            Rand_Phase_Uncert = 0;

            Rand_Time_Uncert = 0;

            % SNR of the channel
            SNR = 100;

            Uncertainty_Params = [Rand_Freq_Uncert Rand_Phase_Uncert Rand_Time_Uncert SNR];

            % Runs the Tx, Channel, and Rx with specified parameters
            [BER,Estimates] = Tx_Chan_Rx_Sim(Filter_Params,Uncertainty_Params);

            Freq_Distort_Estimate     = Estimates(2);
            All_Freq_Est(i,j)         = Freq_Distort_Estimate;

            if BER == 0
               FER(i,j) = 0;
            else
                FER(i,j) = 1;
            end
        end
    end

    Mean_Freq_Uncertain = mean(All_Freq_Est, 2);
    Std_Freq_Uncertain = std(All_Freq_Est, 0, 2);
    figure();plot(Freq_OffSet.', Mean_Freq_Uncertain); xlabel('Frequency Offset (Hz)');ylabel('Mean of Freq Uncertain (Hz)');title('Mean of Freq uncertains');
    figure();plot(Freq_OffSet.', Std_Freq_Uncertain); xlabel('Freq_offset (Hz)');ylabel('STD of Freq Uncertain (Hz)');title('STD of Freq uncertains');


elseif Experiment_Number == 3
    %% Experiment 3: SNR = -3dB to 15dB, step size: 0.5dB

    % 3a Time Delay = 0 msec, f0 = 0 Hz
    Start       = -3;
    Stop        = 15;
    Step_Size   = .5;
    Num_Steps   = 1+(Stop - Start)/Step_Size; 
    Num_Sims    = 1000;
    SNR_Range   = Start:Step_Size:Stop;

    Total_BER       = zeros(Num_Steps,Num_Sims);
    Total_FER       = zeros(Num_Steps,Num_Sims);
    All_Freq_Est    = zeros(Num_Steps,Num_Sims);
    All_Time_Est    = zeros(Num_Steps,Num_Sims);

    for i = 1:Num_Steps
        for j = 1:Num_Sims   
            %%Channel Uncertainty Parameters
            % This generates a random value between -1500 and 1500 for our 
            % f0 (random frequency uncertainty) in Hz
            Rand_Freq_Uncert  = 0;

    %         % This generates a random value between 0 and 2Pi for our
    %         % f0 (random phase) in radians  
    %         Rand_Phase_Uncert = 2*pi*rand(1, 1);
    %         % Temporarily overwrite with 0
            Rand_Phase_Uncert = 0;

            Rand_Time_Uncert = 0;

            SNR = SNR_Range(i);
            Uncertainty_Params = [Rand_Freq_Uncert Rand_Phase_Uncert Rand_Time_Uncert SNR];

            % Runs the Tx, Channel, and Rx with specified parameters
            [BER,Estimates] = Tx_Chan_Rx_Sim(Filter_Params,Uncertainty_Params);

            Time_Delay_Estimate     = Estimates(1);    
            Freq_Distort_Estimate   = Estimates(2);

            All_Time_Est(i,j)       = Time_Delay_Estimate;
            All_Freq_Est(i,j)       = Freq_Distort_Estimate;

            Total_BER(i,j) = BER;

            if BER == 0
               Total_FER(i,j) = 0;
            else
                Total_FER(i,j) = 1;
            end
        end
    end
    
    % Computes the mean along the columns
    Avg_BER = mean(Total_BER,2);
    Avg_FER = mean(Total_FER,2);
    Mean_Time_Uncertain = mean(All_Time_Est, 2);
    Std_Time_Uncertain = std(All_Time_Est, 0, 2);
    figure();plot(SNR_Range, Mean_Time_Uncertain); xlabel('SNR dB');ylabel('Mean of Time Uncertain');title('Mean of Time uncertains');
    figure();plot(SNR_Range, Std_Time_Uncertain); xlabel('SNR dB');ylabel('STD of Time Uncertain');title('STD of Time uncertains');
    figure(); semilogy(SNR_Range, Avg_BER); xlabel('SNR dB');ylabel('Avg BER');title('Avg BER over 1000 Simulations By SNR');
    figure();plot(SNR_Range, Avg_FER); xlabel('SNR dB');ylabel('Avg FER');title('Avg FER over 1000 Simulations By SNR');

elseif Experiment_Number == 4

    %% Experiment 3: SNR = -3dB to 15dB, step size: 0.5dB

    % 3b Time Delay = 0 msec, f0 = 0 Hz
    Start       = -3;
    Stop        = 15;
    Step_Size   = .5;
    Num_Steps   = 1+(Stop - Start)/Step_Size; 
    Num_Sims    = 1000;
    SNR_Range   = Start:Step_Size:Stop;

    Total_BER       = zeros(Num_Steps,Num_Sims);
    Total_FER       = zeros(Num_Steps,Num_Sims);
    All_Freq_Est    = zeros(Num_Steps,Num_Sims);
    All_Time_Est    = zeros(Num_Steps,Num_Sims);

    for i = 1:Num_Steps
        for j = 1:Num_Sims   
            %%Channel Uncertainty Parameters
            % This generates a random value between -1500 and 1500 for our 
            % f0 (random frequency uncertainty) in Hz
            Rand_Freq_Uncert  = 600;

    %         % This generates a random value between 0 and 2Pi for our
    %         % f0 (random phase) in radians  
    %         Rand_Phase_Uncert = 2*pi*rand(1, 1);
    %         % Temporarily overwrite with 0
            Rand_Phase_Uncert = 0;

            Rand_Time_Uncert = .25*16^2;

            SNR = SNR_Range(i);
            Uncertainty_Params = [Rand_Freq_Uncert Rand_Phase_Uncert Rand_Time_Uncert SNR];

            % Runs the Tx, Channel, and Rx with specified parameters
            [BER,Estimates] = Tx_Chan_Rx_Sim(Filter_Params,Uncertainty_Params);

            Time_Delay_Estimate     = Estimates(1);    
            Freq_Distort_Estimate   = Estimates(2);

            All_Time_Est(i,j)       = Time_Delay_Estimate;
            All_Freq_Est(i,j)       = Freq_Distort_Estimate;

            Total_BER(i,j) = log10(BER);

            if BER == 0
               Total_FER(i,j) = 0;
            else
                Total_FER(i,j) = 1;
            end
        end
    end
  
    % Computes the mean along the columns
    Avg_BER = mean(Total_BER,2);
    Avg_FER = mean(Total_FER,2);
    Mean_Time_Uncertain = mean(All_Time_Est, 2);
    Std_Time_Uncertain = std(All_Time_Est, 0, 2);
    figure();plot(SNR_Range, Mean_Time_Uncertain); xlabel('SNR dB');ylabel('Mean of Time Uncertain');title('Mean of Time uncertains');
    figure();plot(SNR_Range, Std_Time_Uncertain); xlabel('SNR dB');ylabel('STD of Time Uncertain');title('STD of Time uncertains');
    figure(); semilogy(SNR_Range, Avg_BER); xlabel('SNR dB');ylabel('Avg BER');title('Avg BER over 1000 Simulations By SNR');
    figure();plot(SNR_Range, Avg_FER); xlabel('SNR dB');ylabel('Avg FER');title('Avg FER over 1000 Simulations By SNR');

elseif Experiment_Number == 5
    %% Experiment 3: SNR = -3dB to 15dB, step size: 0.5dB

    % 3c Time Delay = 0 msec, f0 = 0 Hz
    Start       = -3;
    Stop        = 15;
    Step_Size   = .5;
    Num_Steps   = 1+(Stop - Start)/Step_Size; 
    Num_Sims    = 1000;
    SNR_Range   = Start:Step_Size:Stop;

    Total_BER       = zeros(Num_Steps,Num_Sims);
    Total_FER       = zeros(Num_Steps,Num_Sims);
    All_Freq_Est    = zeros(Num_Steps,Num_Sims);
    All_Time_Est    = zeros(Num_Steps,Num_Sims);

    for i = 1:Num_Steps
        for j = 1:Num_Sims   
            %%Channel Uncertainty Parameters
            % This generates a random value between -1500 and 1500 for our 
            % f0 (random frequency uncertainty) in Hz
            Rand_Freq_Uncert  = 62.5;

    %         % This generates a random value between 0 and 2Pi for our
    %         % f0 (random phase) in radians  
    %         Rand_Phase_Uncert = 2*pi*rand(1, 1);
    %         % Temporarily overwrite with 0
            Rand_Phase_Uncert = 0;

            Rand_Time_Uncert = (2.5/80)*16^2; 

            SNR = SNR_Range(i);
            Uncertainty_Params = [Rand_Freq_Uncert Rand_Phase_Uncert Rand_Time_Uncert SNR];

            % Runs the Tx, Channel, and Rx with specified parameters
            [BER,Estimates] = Tx_Chan_Rx_Sim(Filter_Params,Uncertainty_Params);

            Time_Delay_Estimate     = Estimates(1);    
            Freq_Distort_Estimate   = Estimates(2);

            All_Time_Est(i,j)       = Time_Delay_Estimate;
            All_Freq_Est(i,j)       = Freq_Distort_Estimate;

            Total_BER(i,j) = log10(BER);

            if BER == 0
               Total_FER(i,j) = 0;
            else
                Total_FER(i,j) = 1;
            end
        end
    end
        
    % Computes the mean along the columns
    Avg_BER = mean(Total_BER,2);
    Avg_FER = mean(Total_FER,2);
    Mean_Time_Uncertain = mean(All_Time_Est, 2);
    Std_Time_Uncertain = std(All_Time_Est, 0, 2);
    figure();plot(SNR_Range, Mean_Time_Uncertain); xlabel('SNR dB');ylabel('Mean of Time Uncertain');title('Mean of Time uncertains');
    figure();plot(SNR_Range, Std_Time_Uncertain); xlabel('SNR dB');ylabel('STD of Time Uncertain');title('STD of Time uncertains');
    figure(); semilogy(SNR_Range, Avg_BER); xlabel('SNR dB');ylabel('Avg BER');title('Avg BER over 1000 Simulations By SNR');
    figure();plot(SNR_Range, Avg_FER); xlabel('SNR dB');ylabel('Avg FER');title('Avg FER over 1000 Simulations By SNR');
end