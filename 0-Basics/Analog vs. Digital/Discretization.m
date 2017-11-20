function Discretization
    
    clc
    clear
    close all
    warning('off', 'MATLAB:handle_graphics:exceptions:SceneNode');
    
    %% Misc
    
    % Sampling
    DiracSeries = [];
    fc          = 1000;
    fs          = 100;
    Ts          = 1/fs;
    f1          = 5;
    Time = 0 : 1/fc : 0.5;
    
    for t = Time
        DiracSeries = [DiracSeries; Dirac(t)];
    end
        
    Signal      = sin(2*pi*f1*Time)';
    Measurement = Signal .* DiracSeries;
          
    % zero order hold // input must be a series of Dirac impulses, not possible in Matlab
    s       = tf('s');
    ZOH     = (1-exp(-s*Ts)) / (s*Ts);
    ZOH     = ZOH * fc / fs; % Why is compensating necessary? Is the reason the pulse width?
    
    % z convergence
    z_conv  = -10:0.01:10;
    Step    = 1./(1-z_conv.^-1);
    
    %% Plot 1
    
    AH1 = subplot(3, 2, 1);
    plot(AH1, Time, Signal)
    title(AH1, sprintf('sine (f = %d Hz)', f1))
    xlabel(AH1, 'time (s)')
    
    AH2 = subplot(3, 2, 3);
    plot(AH2, Time, Measurement)
    title(AH2, sprintf('sampled sine (f_s = %d Hz)', fs))
    xlabel(AH2, 'time (s)')
    
    % Signal is shifted by multiples of the sampling frequency. Why are
    % there always two peaks? Is the Nyquist-Shannon Theorem violated?
    
    AH3 = subplot(3, 2, 5);
    plot(AH3, linspace(0, fc, numel(Time)), abs(fft(Measurement)))
    xlim(AH3, [0 1000])
    title(AH3, 'fourier transformed sampled sine')
    xlabel(AH3, 'frequency (Hz)')
    
    AH4 = subplot(3, 2, [2 4]);
    hold(AH4, 'on')
    plot(AH4, Time, Signal, 'k')
    lsim(ZOH, Measurement, Time)
    hold(AH4, 'off')
    title(AH4, '\bf{simulated time response of zero order hold system $$H(s)=\frac{1-e^{-T\cdot s}}{s}$$}', 'interpreter', 'latex')
    ylim(AH4, [-1.5 1.5])

    AH5 = subplot(3, 2, 6);
    plot(AH5, z_conv, Step)
    title(AH5, 'z-transformed step function (converges for |z| > 1)')
    xlabel(AH5, 'z = e^{s·T_s}')
    ylim(AH5, [-100 100])
    
    function Impulse = Dirac(t)
        Impulse = abs(t*fs - round(t*fs)) < 1000*eps;
    end

    %% Discretization

    fs      = 10;
    Ts      = 1/fs;
    syms('s', 't', 'z');
    k       = sym('k');
    symTF   = 2 / (s + 3);
    
    % exact transform  
    symTFd  = ilaplace(symTF / s, s, t);
    symTFd  = subs(symTFd, 't', 'k*Ts');
    symTFd 	= (z - 1) / z * ztrans(symTFd, k, z);
    symTFd 	= simplify(symTFd);
       
    z       = tf('z');
    s       = tf('s');
    TF1     = eval(['tf(' char(symTF) ')']);
    TF1d   	= eval(['tf(' char(symTFd) ')']);
    TF1d.Ts	= Ts;
          
    % bilinear transform
    symTFd  = subs(symTF, 's', '2/Ts*(z-1)/(z+1)');
    
    z       = tf('z');
    TF2     = eval(['tf(' char(symTF) ')']);
    TF2d   	= eval(['tf(' char(symTFd) ')']);
    TF2d.Ts = Ts;

    %% Plot 2

    figure
    
    BodeOptions                 = bodeoptions;
    BodeOptions.FreqUnits       = 'Hz';
    BodeOptions.YLimMode        = 'manual';
    BodeOptions.YLim            = [-180 0];
    
    AH1 = subplot(2, 2, 1);
    step(TF1, TF1d, c2d(TF1, Ts))
    grid(AH1, 'on')
    title(AH1, 'Step response of exact discretized system (continuous vs c2d() vs manually)')
    
    AH2 = subplot(2, 2, 3);
    bode(TF1, TF1d, c2d(TF1, Ts), BodeOptions);
    grid(AH2, 'on')
    title(AH2, 'Bode diagram of exact discretized system')
    ylim(AH2, [-40 0])
    
    AH3 = subplot(2, 2, 2);
    step(TF2, TF2d, c2d(TF2, Ts, 'tustin'))
    grid(AH3, 'on')
    title(AH3, 'Step response of bilinear discretized system (continuous vs c2d() vs manually)')
    
    AH4 = subplot(2, 2, 4);
    bode(TF2, TF2d, c2d(TF2, Ts, 'tustin'), BodeOptions)
    grid(AH4, 'on')
    title(AH4, 'Bode diagram of bilinear discretized system')
    ylim(AH4, [-40 0])
     
    %% Discretization of a state space model (double integrator)
    
    Ts      = 0.2;
        
    A       = [0 1;
               0 0];    
    B       = [0 1]';
    C       = [1 0];
    D       = 0;
        
    sys 	= ss(A, B, C, D);
    n       = size(A, 1);
        
    % numerical calculation (matrix exponential)
    AdBd    = expm([[A B]; zeros(1, size(A, 2) + size(B, 2))] * Ts);
    Ad      = AdBd(1 : size(A, 1), 1 : size(A, 2));
    Bd      = AdBd(1 : size(B, 1), size(A, 2) + 1 : size(A, 2) + size(B, 2));
    Cd      = C;
    Dd      = D;
    sysd1   = ss(Ad, Bd, Cd, Dd, Ts);
    
    % numerical approximation (aborted power series of the matrix exponential)
    Ad      = eye(n) + A * Ts;
    Bd      = eye(n) * Ts * B;
    Cd      = C;
    Dd      = D;
    sysd2   = ss(Ad, Bd, Cd, Dd, Ts);
    
    % exact calculation (Laplace)
    syms('s', 't')
    Ad      = ilaplace((s*eye(n)-A)^-1);
    Ad      = eval(subs(Ad, 't', Ts));
    Bd      = ilaplace((s*eye(n)-A)^-1 / s * B);
    Bd      = eval(subs(Bd, 't', Ts));
    Cd      = C;
    Dd      = D;
    sysd3   = ss(Ad, Bd, Cd, Dd, Ts);
    
    % Matlab calculation
    sysd4   = c2d(sys, Ts);
    
    %% Plot 3
    
    figure
        
    AH1 = subplot(2, 2, 1);
    step(sys, sysd1, 10)
    grid(AH1, 'on')
    title(AH1, 'numerical calculation (matrix exponential)')
    
    AH2 = subplot(2, 2, 3);
    step(sys, sysd2, 10)
    grid(AH2, 'on')
    title(AH2, 'numerical approximation (aborted power series of the matrix exponential)')
    
    AH3 = subplot(2, 2, 2);
    step(sys, sysd3, 10)
    grid(AH3, 'on')
    title(AH3, 'exact calculation (Laplace)')
    
    AH4 = subplot(2, 2, 4);
    step(sys, sysd4, 10)
    grid(AH4, 'on')
    title(AH4, 'Matlab c2d(...)')
    
end