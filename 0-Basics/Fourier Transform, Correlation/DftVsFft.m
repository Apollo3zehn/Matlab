% X(n) = F{x[k]}

% time domain: x[k]
% N     = number of values
% k     = time step, 0 <= k <= N-1
% [k]   = k · t

% frequency domain: X(n)                                 
% n     = 0 <= n <= N/2                     
% f_k   = n/(N · T_s)

function [] =  DftVsFft()

    clc
    clear
    close all

    x	= rand(2^10, 1);
    t 	= find(x);
    N   = numel(x);

    %% Example 1: DFT
    fprintf('\n1. DFT:\n')
    
    tic

    X1 = zeros(N, 1);

    for n = 0 : N - 1
        for k = 0 : N - 1
            X1(n + 1, 1) = X1(n + 1, 1) + x(k + 1, 1) * exp(-1i*(k*2*pi*n)/N);
        end
    end

    toc

    %% Example 2: vectorized DFT
    fprintf('\n2. vectorized DFT:\n')
    
    tic

    X2 = zeros(N, 1);

    for n = 0 : N - 1

        k               = (0 : N - 1)';
        X2(n + 1, 1)    = sum(x(k + 1, 1) .* exp(-1i*(k*2*pi*n)/N));

    end
    
    toc

    %% Example 3: 1-stage FFT
    fprintf('\n3. 1-stage FFT:\n')
    
    tic

    X3  = zeros(N, 1);

    A   = zeros(N/2 + 1, 1);
    B   = zeros(N/2 + 1, 1);

    W	= exp(-1i * (2 * pi / N));

    for n = 0 : N/2 - 1

        for k = 0 : N/2 - 1
            A(n + 1, 1) = A(n + 1, 1) + x(2*k + 1, 1)       * W^(2*k*n);
            B(n + 1, 1) = B(n + 1, 1) + x(2*k + 1 + 1, 1)   * W^(2*k*n);
        end

        X3(n + 1, 1)        = A(n + 1, 1) + W^n * B(n + 1);
        X3(n + N/2 + 1, 1)  = A(n + 1, 1) - W^n * B(n + 1);

    end
    
    toc

    %% Example 4: n-stage FFT
    fprintf('\n4. n-stage FFT:\n')
    
    tic

    W	= exp(-1i * (2 * pi * (0 : (N / 2) - 1) / N)).';
    X4 	= x(Logical.BitReversedIndex(N) + 1);

    for StageNumber = 1 : log(N) / log(2)
       
        StepSize = 2^(StageNumber - 1);
  
        SubIndex = 0;
        
        for Index = 1 : N
            
            if bitand(Index - 1, bitshift(1, StageNumber - 1)) == 0
                
                Exponent                = (N / 2^StageNumber) * SubIndex;
                
                % W^k * y
                Wky                     = X4(Index + StepSize, 1) * W(Exponent + 1, 1);
                % y' = x - W^k * y
                X4(Index + StepSize, 1) = X4(Index, 1) - Wky;
                % x' = x + W^k * y
                X4(Index, 1)            = X4(Index, 1) + Wky;
                
                SubIndex                = SubIndex + 1;
                
            else
                SubIndex = 0;
            end
            
        end

    end
    
    toc
    
    %% Example 5: vectorized n-stage FFT
    fprintf('\n5. vectorized n-stage FFT:\n')
    
    tic

    W           = exp(-1i * (2 * pi * (0 : (N / 2) - 1) / N)).';
    Indices     = Logical.BitReversedIndex(N);
    X5          = x(Indices + 1);
    StageCount  = log(N) / log(2);

    for StageNumber = 1 : StageCount

        SubIndices                  = bitand(Indices, bitshift(1, StageCount - StageNumber)) > 0;
        
        Exponents                   = repmat((0 : 2^StageCount / 2^StageNumber : 2^(StageCount-1) - 1)', 2^(StageCount - StageNumber), 1);
        
        % W^k * y
        Wky                         = X5(SubIndices, 1) .* W(Exponents + 1, 1);
        % y' = x - W^k * y
        X5(SubIndices, 1)           = X5(~SubIndices, 1) - Wky;
        % x' = x + W^k * y
        X5(~SubIndices, 1)          = X5(~SubIndices, 1) + Wky;
        
    end
    
    toc
    
    %% Example 6: Matlab implemenration (FFT)
    fprintf('\n6. Matlab implementation (FFT):\n')
    
    tic
    
    X6 = fft(x);
    
    toc

    %%

end