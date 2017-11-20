function IterationCount = Mandelbrot(xGrid, yGrid, MaxIterationCount, Threshold)

    IterationCount = arrayfun(@ProcessMandelbrotElement, xGrid, yGrid, MaxIterationCount);
    IterationCount = gather(IterationCount);

    function Count = ProcessMandelbrotElement(x0, y0, MaxIterationCount)

        z0              = complex(x0, y0);
        z               = z0;
        Count           = 1;

        while (Count <= MaxIterationCount) && (abs(z) <= Threshold)
            Count   = Count + 1;
            z       = z*z + z0;
        end
        
        Count = log(Count);

    end
    
end