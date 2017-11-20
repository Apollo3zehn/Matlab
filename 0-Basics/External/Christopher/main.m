%
% Set Parameters
%
ini.hubheight = 100;  % ground to hub [m]
ini.hubtotip = 60;  % distance hub-bladtip [m]
ini.rotorspeed = 13;  % angular rotor velocity [U/min]
ini.rotorpos = 45;  % rotor position from horizontal [deg]
ini.tmax = 20;  % time interval from 0 to tmax [s]
ini.cd = 1.1;  % damping coefficient [-]
ini.rho = 1.225; % air density [kg/m³)
ini.A = 0.01; % surface chunk [m²]
ini.m = 1; % mass chunk [kg]
ini.g = -9.81; % gravity [m/s²)
ini.v_w = 10; % m/s
ini.shearc = 0.03;


%
% Simulate
%
ret = simulate(ini);
Y = real(ret.Y(ret.Y(:, 2) > 0, :));
T = ret.T(ret.Y(:, 2) > 0, :);


%
% Visualize
%

plot3(Y(:,1),Y(:,2),Y(:,3))

ret = axis;
grid
axis equal;
axis([ret(1) ret(2) 0 300]);
xlabel('x')
ylabel('y')
zlabel('z')



