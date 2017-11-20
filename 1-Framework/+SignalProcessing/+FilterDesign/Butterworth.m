function [b, a, sos] = Butterworth(Order, CutOffFrequency, Type)
% second-order-sections vs. rational transfer function

    %% Prototype

    IsEven              = mod(Order, 2) == 0;
    
    if IsEven
        SosCount        = Order / 2;
    else
        SosCount     	= (Order - 1) / 2;
    end

    k                   = (1 : SosCount).';
    b                   = [zeros(SosCount, 2) ones(SosCount, 1)];
    a                   = [ones(SosCount, 1) -2*cos((2*k + Order - 1) * pi / (2*Order)) ones(SosCount, 1)];
    
    if ~IsEven
        b               = [b; [0 1 0]];
        a               = [a; [1 1 0]];        
        SosCount        = SosCount + 1;
    end
    
    %% Low pass
    
    TransformMatrix 	= ones(SosCount, 6);
    TransformMatrix     = bsxfun(@times, TransformMatrix, CutOffFrequency.^([0 1 2 0 1 2]));

    switch Type
        case 'Highpass'
            b        	= [ones(SosCount, 1) zeros(SosCount, 2)];            
    end
    
    sos                 = [b a] .* TransformMatrix;
    b                   = sos(1, 1:3);
    a                   = sos(1, 4:6);

    if SosCount > 1
        for SosRow = 2 : SosCount
            b = conv(b, sos(SosRow, 1:3));
            a = conv(a, sos(SosRow, 4:6));
        end  
    end

end
