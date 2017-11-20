function SH = DateTimeInformationText(AxisHandle, DateTimeBegin, DateTimeEnd, xPosition, yPosition)
        
    Text = sprintf('from: %s\n  to: %s', ...
                  datestr(DateTimeBegin, 'yyyy-mm-dd hh:MM:ss'), ...
                  datestr(DateTimeEnd, 'yyyy-mm-dd hh:MM:ss'));

    SH = text(xPosition, yPosition, Text, 'Units', 'normalized', 'Parent', AxisHandle, ...
             'FontSize', 13, 'FontWeight', 'bold', 'FontName','FixedWidth');      

    if nargout == 0 
        clear('SH')
    end

end