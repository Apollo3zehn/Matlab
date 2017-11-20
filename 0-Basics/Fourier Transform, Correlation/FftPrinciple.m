function FftPrinciple

    clc
    clear
    close all

    FH = figure ('name', 'FFt Analysis', ...
                'Units', 'Points', ...
                'Position',[0 0 1000 600], ...
                'Resize', 'off', ...
                'CloseRequestFcn', @Figure_CloseRequested);

	uicontrol(FH, 'Style', 'pushbutton', 'String', 'Next frequency', 'Position', [1 50 100 30], 'Callback', @btnContinue_Click);
    uicontrol(FH, 'Style', 'pushbutton', 'String', 'Auto mode', 'Position', [1 10 100 30], 'Callback', @btnAutomatic_Click);
    movegui(FH, 'center')        
    
	%% Calculation
    
    N       = 200;
    fs      = 1;
    f1      = 0.100;
    f2      = 0.203;
    Steps   = 0 : N - 1;
    x       = sin(2*pi*f1*Steps + pi) + sin(2*pi*f2*Steps);
    %x       = sin(2*pi*f1*Steps) + sin(2*pi*f2*Steps) + rand(1, N) * 2;
    %x       = sin(2*pi*f1*Steps + 45 / 180*pi);
    %x       = [sin(2*pi*f1*Steps(1 : round(numel(Steps)/2))), sin(2*pi*f2*Steps(round(numel(Steps)/2) + 1 : end))];

    AH1 = subplot(4, 4, 1 : 2);
    AH2 = subplot(4, 4, 3 : 4);
    AH3 = subplot(4, 4, 5 : 6);
    AH4 = subplot(4, 4, 7 : 8);
    AH5 = subplot(4, 4, 9 : 10);
    AH6 = subplot(4, 4, 11 : 12);
    AH7 = subplot(4, 4, 13 : 15);
    AH8 = subplot(4, 4, 16);
    
    hold(AH1, 'on')
    hold(AH2, 'on')
    hold(AH3, 'on')
    hold(AH4, 'on')
    hold(AH5, 'on')
    hold(AH6, 'on')
    hold(AH7, 'on')
    hold(AH8, 'on')

    ylim(AH1, [-2 2])
    ylim(AH2, [-2 2])
    ylim(AH3, [-2 2])
    ylim(AH4, [-2 2])
    ylim(AH5, [-1 1])
    ylim(AH6, [-1 1])
    ylim(AH7, [-1 1])
    ylim(AH8, [-1 1])

    xlim(AH1, [0 N-1])
    xlim(AH2, [0 N-1])
    xlim(AH3, [0 N-1])
    xlim(AH4, [0 N-1])
    xlim(AH5, [0 fs])
    xlim(AH6, [0 fs])
    xlim(AH7, [0 fs])
    xlim(AH8, [-1 1])

    xlabel(AH5, 'Time (s)')
    xlabel(AH6, 'Time (s)')
    xlabel(AH7, 'Frequency (Hz)')
    xlabel(AH8, 'real part')
    
    ylabel(AH8, 'imaginary part')
    
    grid(AH1, 'on')
    grid(AH2, 'on')
    grid(AH3, 'on')
    grid(AH4, 'on')

    plot(AH1, Steps, x, 'k')
    plot(AH2, Steps, x, 'k')
    plot(AH8, [-1 1], [0 0], 'k')
    plot(AH8, [0 0], [-1 1], 'k')

    SH          = [];
    X           = zeros(1, N);

    Automatic	= false;
    Continue    = false;
    Stop        = false;
    
    for f = 0 : N - 1

        if f >= 20
            a= 1;
        end
        
        CosinePart      = cos(2*pi*f*Steps/N);
        SinePart        = -sin(2*pi*f*Steps/N);
        ComplexResult   = x .* (CosinePart + 1i*SinePart);
        CumsumResult    = cumsum(ComplexResult) / fs / N;
        X(1, f + 1)     = CumsumResult(end);

        delete(SH)
        SH(1)   = plot(AH1, Steps, CosinePart, 'r');
        SH(2)   = plot(AH2, Steps, SinePart, 'r');
        SH(3)   = plot(AH3, Steps, real(ComplexResult), 'k');
        SH(4)   = plot(AH4, Steps, imag(ComplexResult), 'k');
        SH(5)   = bar(AH5, Steps / N, real(CumsumResult), 'b');
        SH(6)   = bar(AH6, Steps / N, imag(CumsumResult), 'b');
        SH(7)   = bar(AH7, Steps / N, abs(fft(x) / N), 'w');
        SH(8)   = bar(AH7, Steps / N, abs(X), 'b');
        SH(9)   = plot(AH8, [0 real(CumsumResult(end))], [0 imag(CumsumResult(end))], '-r');
        SH(10)  = plot(AH8, real(CumsumResult(end)), imag(CumsumResult(end)), 'r.');

        title(AH1, sprintf('Signal (%.3f Hz and %.3f Hz) vs. cosine (%.3f Hz)', f1, f2, f / N))
        title(AH2, sprintf('Signal (%.3f Hz and %.3f Hz) vs. sine (%.3f Hz)', f1, f2, f / N))
        title(AH3, 'Multiplied signals (real part)')
        title(AH4, 'Multiplied signals (imaginary part)')
        title(AH5, 'Cumulated result (real part)')
        title(AH6, 'Cumulated result (imaginary part)')
        title(AH7, 'Real and imaginary part')
        
        while true
            
            drawnow
            
            if Automatic || (~Automatic && Continue)
                Continue = false;
                break
            end
                
            if Stop
                display('Finished.')
                return
            end
            
        end
        
    end

    function btnAutomatic_Click(~, ~, ~)
        Automatic = ~Automatic;
    end
    
    function btnContinue_Click(~, ~, ~)
        Continue = true;
    end

    function Figure_CloseRequested(~, ~, ~)

        Stop = true;
        
        delete(FH)
        
    end

end
