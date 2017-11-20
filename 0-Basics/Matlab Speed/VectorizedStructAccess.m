clc
clear
close all

%% Data preparation

Data(1).Velocity.x  = 10;
Data(1).Velocity.y  = 11;
Data(1).Date        = now;

Data(2).Velocity.x  = 10;
Data(2).Velocity.y  = 21;

Data(3).Velocity.x  = 9;
Data(3).Velocity.y  = 11;

%% Data access

Velocity            = [Data.Velocity];
Speed               = sqrt([Velocity.x].^2 + [Velocity.y].^2);


