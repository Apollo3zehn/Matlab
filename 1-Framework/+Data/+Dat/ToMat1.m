clc
clear
close all

FileName            = 'M:\Data Analysis\Testumgebung_VWI\Aufgaben\34-Leistungsmessung BW33 an Peter\3-Traces\2016-02-11_0750_BW33.dat';

FileID              = fopen(FileName, 'r');

Header              = fgetl(FileID);
Header              = strsplit(Header, '\t');
FormatSpec          = '%4f-%2f-%2f %2f:%2f:%2f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f';

fgetl(FileID);
DataSet            	= textscan(FileID, FormatSpec, 'HeaderLines', 1, 'Delimiter', ' ', 'ReturnOnError', true);
DateTime            = datenum(DataSet{:, 1}, DataSet{:, 2}, DataSet{:, 3}, DataSet{:, 4}, DataSet{:, 5}, DataSet{:, 6});
DataSet            	= cell2struct(DataSet, [{'Year' 'Month' 'Day' 'Hours' 'Minutes' 'Seconds'} Header(:, 2 : end)], 2);
DataSet.DateTime   	= DateTime;

[FilePath, FileName, ~] = fileparts(FileName);
save([FilePath '\' FileName], 'DataSet', '-v7.3')

fclose(FileID);

