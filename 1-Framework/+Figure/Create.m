function FigureHandle = Create(Left, Bottom, Width, Height)
        
    	FH  =   figure ('name', '', ...
                        'color', 'w', ...
                        'PaperPositionMode', 'manual', ...
                        'PaperUnits', 'points', ... 
                        'PaperSize', [Width Height], ...  
                        'PaperPosition', [0 0 Width Height], ...
                        ...
                        'Units', 'Points', ...
                        'Position', [Left Bottom Width Height]);
                                
        figure(FH)
        clf(FH)
         
        if nargout > 0 
            FigureHandle = FH;
        end
        
end