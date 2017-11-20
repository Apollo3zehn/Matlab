function [u, v] = RotateVectorField(x, y, u, v, Angle)

%   - Idea -
%   Rotate coordinates x and y in normal direction. Interpolate data (located at new
%   coordinates) for each point of old coordinates to maintain old shape.
%   But: not possible, since interp2 requires uniformly coordinates
%
%   - Workaround -
%   Rotate coordinates in opposite direction. Switch the meaning of old and
%   new coordinates. Interpolate data (located at "new" coordinates) for
%   each point of "old" coordinates to maintain old shape.
%
%   - Test -
%
%   Angle    = 20; 
%   [x, y]   = ndgrid(0 : 10, 0 : 10); 
%   u        = ones(size(x)); 
%   v        = zeros(size(x)); 
%   [u1, v1] = Transformation2D.RotateVectorField(x, y, u, v, Angle/180*pi); 
%     
%   quiver(x, y, u, v, 0.4); hold on;  
%   quiver(x, y, u1, v1, 0.4, 'r'); hold off; 
%   ylim([-20 20]); xlim([-20 20])

    [u_new, v_new] = Transformation2D.Rotate(u, v, Angle);
    [x_new, y_new] = Transformation2D.Rotate(x, y, -Angle);
   
    u = interp2(x.', y.', u_new.', x_new.', y_new.');
    v = interp2(x.', y.', v_new.', x_new.', y_new.');
    
    u = u.';
    v = v.';

end

