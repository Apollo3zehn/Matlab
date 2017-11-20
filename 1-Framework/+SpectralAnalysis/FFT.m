% zero-padding: http://www.bitweenie.com/listings/fft-zero-padding/#
% + Increases the frequency resolution
% + Fastens the FFT
% - Introduces new frequencies due to the sudden drop to zero
%
% Parseval's theorem: http://math.stackexchange.com/questions/636847/understanding-fourier-transform-example-in-matlab
% AmplitudePhase = fft(Data, FftLength) / Frequency;

function [Frequency, Amplitude, Phase] = FFT(Data, SamplingFrequency, ZeroPadding)
    
    SignalLength	= numel(Data);
   
    if ZeroPadding
        FftLength	= 2^nextpow2(SignalLength);
    else
        FftLength	= SignalLength;
    end
       
    AmplitudePhase  = fft(Data, FftLength) / SignalLength;
    
    if mod(FftLength, 2) == 0
        BinCount            = FftLength / 2 + 1;
        Amplitude           = abs(AmplitudePhase(1 : BinCount));
        Amplitude(2 : end-1)= 2 * Amplitude(2 : end-1);
    else
        BinCount            = (FftLength + 1) / 2;
        Amplitude           = abs(AmplitudePhase(1 : BinCount));
        Amplitude(2 : end)  = 2 * Amplitude(2 : end);
    end  
        
    Phase           = angle(AmplitudePhase(1 : BinCount));
    Frequency       = SamplingFrequency / 2 * linspace(0, 1, BinCount);
    
end

