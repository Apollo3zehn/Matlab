% Point format: [x y]
% Algorithm: http://mathworld.wolfram.com/Line-LineIntersection.html

function [x, y] = Intersection(Point11, Point12, Point21, Point22)

    x11_x12 = Point11(1) - Point12(1); % x11 - x12
    x21_x22 = Point21(1) - Point22(1); % x21 - x22

    y11_y12 = Point11(2) - Point12(2); % y11 - y12
    y21_y22 = Point21(2) - Point22(2); % y21 - y22


    Det     = det([x11_x12 y11_y12; x21_x22 y21_y22]);
    Det1    = det([Point11(1) Point11(2); Point12(1) Point12(2)]);
    Det2    = det([Point21(1) Point21(2); Point22(1) Point22(2)]);
       
    if Det1 == 0
        x = NaN;
        y = NaN;
    else
        x = det([Det1 x11_x12; Det2 x21_x22]) / Det;
        y = det([Det1 y11_y12; Det2 y21_y22]) / Det;
    end
    
%     clf
%     hold on
%     plot([Point11(1); Point12(1)], [Point11(2); Point12(2)])
%     plot([Point21(1); Point22(1)], [Point21(2); Point22(2)])
%     plot(x, y, 'or')    
        
end

