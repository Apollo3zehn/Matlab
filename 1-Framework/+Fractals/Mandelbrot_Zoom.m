function Mandelbrot_Zoom

    clc
    clear
    close all

    MaxIterationCount   = 500;
    Threshold           = 2;
    Size                = 500;
    xLimit              = [-2, 2];
    yLimit              = [-2, 2];
    
    Figure.Create(100, 100, 600, 600);
    xlim(xLimit)
    ylim(yLimit)
    colormap(hot)
    %colormap(flipud(colormap))
    set(gcf, 'Pointer', 'crosshair')
    set(gcf, 'WindowButtonMotionFcn', @Figure_WindowButtonMotion);
    ReferencePoint      = [0 0];
    CurrentPoint        = [0 0];
    pause(2)

    while true
        
        x           	= gpuArray.linspace(xLimit(1), xLimit(2), Size);
        y              	= gpuArray.linspace(yLimit(1), yLimit(2), Size);

        [xGrid, yGrid] 	= meshgrid(x, y);
        IterationCount 	= Fractals.Mandelbrot(xGrid, yGrid, MaxIterationCount, Threshold);

        imagesc(x, y, IterationCount)
        axis image
        drawnow

        
        Shift           = 0.2 * [CurrentPoint(1, 1) - ReferencePoint(1) CurrentPoint(1, 2) - ReferencePoint(2)];
        xLimit          = xLimit + Shift(1);
        yLimit          = yLimit + Shift(2);
        ReferencePoint  = ReferencePoint + Shift;
        
        xLimit          = xLimit + [0.005 -0.005] * diff(xLimit);
        yLimit          = yLimit + [0.005 -0.005] * diff(yLimit);

    end
    
    function Figure_WindowButtonMotion(~, ~)
        CurrentPoint = get(gca, 'CurrentPoint');
    end
    
end