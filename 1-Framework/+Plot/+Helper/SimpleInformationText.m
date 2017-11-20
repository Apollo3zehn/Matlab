function SH = SimpleInformationText(AxisHandle, Text, xPosition, yPosition)

    SH = text(xPosition, yPosition, Text, 'Units', 'normalized', 'Parent', AxisHandle, ...
             'FontSize', 13, 'FontWeight', 'bold', 'FontName', 'FixedWidth');      

    if nargout == 0 
        clear('SH')
    end

end