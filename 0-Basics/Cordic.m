classdef Cordic
% see http://math.exeter.edu/rparris/peanut/cordic.pdf
    
enumeration
    Rotating, Vectoring, Circular, Linear, Hyperbolic
end

methods(Static)
            
    %% circular rotating mode
    
    function sin = Sine(Angle, Accuracy)
        [~, y, ~, Kn]   = Cordic.Calculate(1, 0, Angle, Accuracy, Cordic.Rotating, Cordic.Circular);
        sin             = y / Kn;
    end
    
    function cos = Cosine(Angle, Accuracy)
        [x, ~, ~, Kn]   = Cordic.Calculate(1, 0, Angle, Accuracy, Cordic.Rotating, Cordic.Circular);
        cos             = x / Kn;
    end
    
    function tan = Tangent(Angle, Accuracy)
        tan             = Cordic.Sine(Angle, Accuracy) / Cordic.Cosine(Angle, Accuracy);
    end
    
    %% circular vectoring mode
    
    function norm2 = Norm2(x, y, Accuracy)
        [x, ~, ~, Kn]   = Cordic.Calculate(x, y, 0, Accuracy, Cordic.Vectoring, Cordic.Circular);
        norm2           = x / Kn;
    end
    
    function atan = ArcTangent(Numerator, Denominator, Accuracy)
        [~, ~, z, ~]    = Cordic.Calculate(Denominator, Numerator, 0, Accuracy, Cordic.Vectoring, Cordic.Circular);
        atan            = z;
    end
        
    %% linear rotating mode
    
    function prod = Product(Multiplicand, Multiplier, Accuracy)
        [~, y, ~, ~]    = Cordic.Calculate(Multiplicand, 0, Multiplier, Accuracy, Cordic.Rotating, Cordic.Linear);
        prod            = y;
    end
    
    %% linear vectoring mode
    
    function div = Division(Numerator, Denominator, Accuracy)
        [~, ~, z, ~]    = Cordic.Calculate(Denominator, Numerator, 0, Accuracy, Cordic.Vectoring, Cordic.Linear);
        div             = z;
    end
    
    %% hyperbolic rotating mode
    
    function sinh = SineHyperbolic(Angle, Accuracy)
        [~, y, ~, Kn]   = Cordic.Calculate(1, 0, Angle, Accuracy, Cordic.Rotating, Cordic.Hyperbolic);
        sinh            = y / Kn;
    end
    
    function cosh = CosineHyperbolic(Angle, Accuracy)
        [x, ~, ~, Kn]   = Cordic.Calculate(1, 0, Angle, Accuracy, Cordic.Rotating, Cordic.Hyperbolic);
        cosh            = x / Kn;
    end
    
    function tanh = TangentHyperbolic(Angle, Accuracy)
        tanh            = Cordic.SineHyperbolic(Angle, Accuracy) / Cordic.CosineHyperbolic(Angle, Accuracy);
    end
    
    function exp = Exponential(Exponent, Accuracy)
        exp             = Cordic.SineHyperbolic(Exponent, Accuracy) + Cordic.CosineHyperbolic(Exponent, Accuracy);
    end
    
    %% hyperbolic vectoring mode
    
    function atanh = ArcTangentHyperbolic(Numerator, Denominator, Accuracy)
        [~, ~, z, ~]   = Cordic.Calculate(Denominator, Numerator, 0, Accuracy, Cordic.Vectoring, Cordic.Hyperbolic);
        atanh          = z;
    end
    
    function log = Logarithmus(Value, Accuracy)
        log            = 2 * Cordic.ArcusTangensHyperbolic(Value - 1, Value + 1, Accuracy);
    end
    
    function sqrt = SquareRoot(Value, Accuracy)
        [x, ~, ~, Kn]  = Cordic.Calculate(Value + 0.25, Value - 0.25, 0, Accuracy, Cordic.Vectoring, Cordic.Hyperbolic);
        sqrt           = x / Kn;
    end
    
    %% CORDIC core
    
    function [x, y, z, Kn] = Calculate(x, y, z, Accuracy, Mode, CoordinateSystem)

        % Coordinate Rotating Digital Computer (CORDIC)
        %
        % - Syntax -
        %
        % [x, y, z] = Calculate(Data, Accuracy)
        %
        % - Inputs -
        %
        % Data              - Scalar that contains the initial value for z (rotating mode) or 
        %                     2-element vector that contains the inital values for x and y (vectoring mode).
        % Accuracy          - Scalar that specifies the maximum angle deviation.
        % CoordinateSystem  - Enumeration element that specifies the coordinate system to use.
        %
        % - Outputs -
        %
        % x                 - Optional output. Length of the vector on the real axis.
        % y                 - Optional output. Length of the vector on the imaginary axis.
        % z                 - Optional output. Angle accumulator.
        % Kn                - Optional output. Scaling factor.
        %
        % - Test -
        %
        % [x, y, z, Kn] = Cordic.Calculate(1, 0, 38 / 180*pi, 0.00000001, Cordic.Rotating, Cordic.Circular);

        %% Verify input data

        if ~isscalar(x) || ~isscalar(y) || ~isscalar(z) || ~isscalar(Accuracy)  
            error('The first four inputs (x, y, z and Accuracy) must be scalars.')
        end

        if ~(nargout == 0 || nargout == 4)
            error('The number of output arguments must be zero or four.')
        end

        switch CoordinateSystem
            case Cordic.Circular
                if abs(z) > pi/2
                    error('In circular coordinate system, the limit for input z is -pi/2 .. +pi/2.')
                end
            case Cordic.Linear
                if abs(z) > 2
                    error('In linear coordinate system, the limit for input z is -2 .. +2.')
                end
            case Cordic.Hyperbolic
                if abs(z) > 1
                    error('In hyperbolic coordinate system, the limit for input z is -1 .. +1.')
                end
        end
        
        %% Pre-calculation
        
        IterationCount  = ceil(-log(tan(Accuracy)) / log(2) + 1);

        switch CoordinateSystem
            case Cordic.Circular
                Kn   	= prod(sqrt(1 + 2.^(-2 * (0 : IterationCount - 1))));
                mu      = 1;
                e       = atan(2.^-(0 : IterationCount - 1));
            case Cordic.Linear
                Kn    	= 0;
                e       = 2.^-(0 : IterationCount - 1);
                mu      = 0;
            case Cordic.Hyperbolic
                Kn      = prod(sqrt(1 - 2.^(-2 * (1 : IterationCount))));
                e       = atanh(2.^-(1 : IterationCount));
                mu      = -1; 
        end
        
        %% Iteration

        fprintf('           Kn: %f\n   Iterations: %d\nMax deviation: %f\n\n', Kn, IterationCount, Accuracy)

        display(' i   d_i        x_i       y_i       z_i        e_i')
        display('--------------------------------------------------')
        fprintf('%2d   %3d    %7.4f   %7.4f   %7.4f   %8.4f\n', 0, NaN, x, y, z, NaN);
       
        for i = 0 : IterationCount - 1 

            switch Mode
                case Cordic.Rotating
                    d = sign(z);
                case Cordic.Vectoring
                    d = -sign(y);
            end

            if d == 0
                d = 1;
            end
          
            switch CoordinateSystem
                case Cordic.Hyperbolic
                    Old_x 	= x;
                    x       = x - mu * d * bitsra(y    , i + 1);
                    y       = y +      d * bitsra(Old_x, i + 1);
                    z       = z - d * e(i + 1);
                    % duplicate entries would be necessary to increase accuracy
                otherwise
                    Old_x 	= x;
                    x       = x - mu * d * bitsra(y    , i);
                    y       = y +      d * bitsra(Old_x, i);
                    z       = z - d * e(i + 1);         
            end
            
            fprintf('%2d   %3d    %7.4f   %7.4f   %7.4f   %8.4f\n', i + 1, d, x, y, z, d*e(i + 1));

        end

        if nargout == 0
           clear('x', 'y', 'z', 'Kn'); 
        end

    end
    
end

end