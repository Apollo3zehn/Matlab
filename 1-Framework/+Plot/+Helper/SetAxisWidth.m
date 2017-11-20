function [] = SetAxisWidth(AxisHandle, Width)
    set(AxisHandle, 'Units', 'points') 
    Position    = get(AxisHandle, 'Position');
    Left        = Position(1);
    Bottom      = Position(2);
    FullWidth   = Position(3);
    FullHeight  = Position(4);
    set(AxisHandle, 'Position', [(Left + FullWidth / 2 - Width / 2) Bottom Width FullHeight])
end