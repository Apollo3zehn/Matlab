function ret = simulate(ini)
% 
%

%
% Build struct
%
mypar.locstart = [  ...    
    -cos(ini.rotorpos/180*pi)*ini.hubtotip  ...
    ini.hubheight + sin(ini.rotorpos/180*pi)*ini.hubtotip  ...
    0
    ];  % initial location
mypar.velstart = [  ...
    sin(ini.rotorpos/180*pi)*ini.rotorspeed/60*(2*pi)*ini.hubtotip  ...
    cos(ini.rotorpos/180*pi)*ini.rotorspeed/60*(2*pi)*ini.hubtotip  ...
    0
    ];  % initial velocity

mypar.cd = ini.cd;  % damping coefficient? 
                    


mypar.time = [0 ini.tmax];

%
% Run ODE
%
[T,Y] = ode45(  ...
    @(t,y) myode(t,y,mypar,ini),  ...          
    mypar.time,  ...                %endtime
    [mypar.locstart mypar.velstart]  ...    %initial parameters
    );
ret.T = T;
ret.Y = Y;
end