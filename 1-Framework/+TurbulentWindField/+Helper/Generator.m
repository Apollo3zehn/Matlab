clc
clear

%% Improved von Karman
% 
% ModelName           = 'ImprovedVonKarman';
% MeanWindSpeed       = 10.4;
% Seed                = 1;
% HubHeight           = 130;
% TurbulenceIntensity = 17.42;
% Latitude            = 54;
% Duration            = 600;
% FftLength           = 128;
% GridWidth           = 100;
% Ny                  = 32;
% GridHeight          = 100;
% Nz                  = 32;
% 
% OutputData       	= TurbulentWindField.Generator.ImprovedVonKarman(MeanWindSpeed, Seed, HubHeight, TurbulenceIntensity, Latitude, Duration, FftLength, GridWidth, Ny, GridHeight, Nz);
% OutputFilePath   	= sprintf('%s\\%s_Seed_%02d_V_%03.0f', [Bladed.RawDataPath '\ByMatlab'], ModelName, Seed, MeanWindSpeed * 10);

%% Kaimal

% ModelName           = 'Kaimal';
% MeanWindSpeed       = 10;
% Seed                = 1;
% HubHeight           = 91;
% Duration            = 600;
% FftLength           = 512;
% GridWidth           = 200;
% Ny                  = 64;
% GridHeight          = 200;
% Nz                  = 64;
% 
% OutputData       	= TurbulentWindField.Generator.Kaimal(MeanWindSpeed, Seed, HubHeight, Duration, FftLength, GridWidth, Ny, GridHeight, Nz, true);
% OutputFilePath   	= sprintf('%s\\%s_Seed_%02d_V_%03.0f', [Bladed.RawDataPath '\ByMatlab'], ModelName, Seed, MeanWindSpeed * 10);
% 
% ModelName           = 'Kaimal';
% MeanWindSpeed       = 10;
% Seed                = 1;
% HubHeight           = 91;
% Duration            = 600;
% FftLength           = 256;
% GridWidth           = 200;
% Ny                  = 16;
% GridHeight          = 200;
% Nz                  = 16;
% 
% OutputData       	= TurbulentWindField.Generator.Kaimal(MeanWindSpeed, Seed, HubHeight, Duration, FftLength, GridWidth, Ny, GridHeight, Nz, true);
% OutputFilePath   	= sprintf('%s\\%s_Seed_%02d_V_%03.0f', [Bladed.RawDataPath '\ByMatlab'], ModelName, Seed, MeanWindSpeed * 10);

%% Mann

ModelName           = 'Mann';
MeanWindSpeed       = 10;
Seed                = 1;
HubHeight           = 130;
Duration            = 600;
Nx                  = 512;
GridWidth           = 500;
Ny                  = 32;
GridHeight          = 500;
Nz                  = 32;

OutputData       	= TurbulentWindField.Generator.Mann(MeanWindSpeed, Seed, HubHeight, Duration, Nx, GridWidth, Ny, GridHeight, Nz);
OutputFilePath   	= sprintf('%s\\%s_Seed_%02d_V_%03.0f', [Bladed.RawDataPath '\ByMatlab'], ModelName, Seed, MeanWindSpeed * 10);

%% Save

Directory.CreateByFilePath(OutputFilePath)
save(OutputFilePath, '-struct', 'OutputData')
TurbulentWindField.Data.WriteWnd(OutputFilePath, OutputData)

