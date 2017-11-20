clc
clear
close all

%% Settings

WindModel = 'ImprovedVonKarman'; % {'Kaimal', 'ImprovedVonKarman', 'Mann'}

HubHeight           = 130;

TurbulenceIntensity = 0.00; % 16.00
ShearCoefficient    = 0.3;
Seed                = 6;
RunName           	= '24';

Frequency           = 1;
Seconds             = 600;

zPositions       	= [130 100 80 60];
yPositions       	= [0 0 0 0];

%% Preparation

InputFilePath       = [Bladed.RawDataPath '\Lastenmessung\s6\' RunName '.wnd'];

switch WindModel
    case 'Kaimal'
        BladedWindFile = TurbulentWindField.Data.ReadBladedWindFile(InputFilePath, 'TurbulenceIntensity', [1 0.8 0.5] * TurbulenceIntensity);
    case 'ImprovedVonKarman'
        BladedWindFile = TurbulentWindField.Data.ReadBladedWindFile(InputFilePath);
    case 'Mann'
        BladedWindFile = TurbulentWindField.Data.ReadBladedWindFile(InputFilePath, 'TurbulenceIntensity', [10 8 5]);
    otherwise
end

if ~all(rem(zPositions, BladedWindFile.header.gridPointSpacing.vertical) == 0)
    error('zCoordinates must be a multiple of %d.', BladedWindFile.header.gridPointSpacing.vertical)
end

if ~all(rem(yPositions, BladedWindFile.header.gridPointSpacing.lateral) == 0)
    error('yCoordinates must be a multiple of %d.', BladedWindFile.header.gridPointSpacing.lateral)
end

%% Calculation

DataLength              = size(BladedWindFile.field.longitudinal, 1);
Offset                  = find(BladedWindFile.coordinates.time > (BladedWindFile.coordinates.time(end) - Seconds), 1, 'first');

zCoordinates            = Matrix.FindArrayIndicesInArray(zPositions - HubHeight, BladedWindFile.coordinates.vertical);
yCoordinates            = Matrix.FindArrayIndicesInArray(yPositions, BladedWindFile.coordinates.lateral);
CoordinateCount         = numel(zPositions);
LongitudinalWindField   = Matrix.ExtractColumns3D(BladedWindFile.field.longitudinal, yCoordinates, zCoordinates);

LongitudinalWindField   = WindHelper.ApplyShearCoefficient(LongitudinalWindField, HubHeight, ones(size(LongitudinalWindField, 1), 1) * zPositions, ShearCoefficient);

LongitudinalWindField 	= interp1(BladedWindFile.coordinates.time(1 : end - Offset), ...
                                  LongitudinalWindField(Offset : end - 1, :), ...
                                  (1 : 1 / Frequency : Seconds)');

LongitudinalWindField(1, :)     = LongitudinalWindField(2, :);
LongitudinalWindField(end, :)   = LongitudinalWindField(end - 1, :);

%% Save

OutputFilePath = sprintf('%s\\%s_Run_%s_Seed_%02d_Shear_%03.0f_V_%03.0f_TI_%03.0f', Bladed.DataDirectory, strrep(BladedWindFile.header.windModel.text, ' ', '_'), RunName, Seed, ShearCoefficient * 1000, BladedWindFile.header.meanWindSpeed * 10, BladedWindFile.header.turbulenceIntensity.longitudinal * 100);

Directory.CreateByFilePath(OutputFilePath);

save(OutputFilePath, 'LongitudinalWindField');
