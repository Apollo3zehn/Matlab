function dy = myode(t,y,mypar,ini)

    dy = zeros(6,1);                                                % a column vector
    dy(1) = y(4);                                                   %delta x  = vx = dx/dt
    dy(2) = y(5);                                                   %delta y  = vy = dy/dt
    dy(3) = y(6);                                                   %delta z = vz =dz/dt
    
    dy(4) = -sign(y(4))*(mypar.cd*0.5*ini.A*ini.rho*y(4)^2 /ini.m);            %delta vx = ax = dvx/dt
    dy(5) = -sign(y(5))*(mypar.cd*0.5*ini.A*ini.rho*y(5)^2 /ini.m) + ini.g;    %delta vy = ay = dvy/dt
    
    NewHeight = y(2);
    
    NewWindSpeed2 = shear_wind(ini, NewHeight);
    dy(6) = (mypar.cd*0.5*ini.A*ini.rho* (NewWindSpeed2 -y(6))^2 /ini.m);            %delta vz = az = dvz/dt 
    
    
    dy=dy*t;
    
end

