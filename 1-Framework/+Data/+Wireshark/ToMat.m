clc
clear
close all

% Replace " and ' before

FileName            = 'M:\Data Analysis\Testumgebung_VWI\Aufgaben\36-Entwicklung neues Messsystem\Vergleich USB vs Intel Netzwerkkarte\Intel NIC 2.csv';
FileID              = fopen(FileName, 'r');

Header              = fgetl(FileID);
Header              = strsplit(Header, ',');
FormatSpec          = '%f %4f-%2f-%2f %2f:%2f:%2f.%6f %f %f %s %s %s %s %s %s %s %s';

DataSet            	= textscan(FileID, FormatSpec, 'HeaderLines', 0, 'Delimiter', ',', 'ReturnOnError', true);
DateTime            = datenum(DataSet{:, 2}, DataSet{:, 3}, DataSet{:, 4}, DataSet{:, 5}, DataSet{:, 6}, DataSet{:, 7});
DataSet            	= cell2struct(DataSet, {'No' 'Year' 'Month' 'Day' 'Hours' 'Minutes' 'Seconds' 'Microseconds' 'Length' 'Time' 'Info1' 'Info2' 'Info3' 'Source' 'Destination' 'Protocol' 'Index1' 'Index2'}, 2);
DataSet.DateTime    = DateTime;

save('M:\Data Analysis\Testumgebung_VWI\Aufgaben\36-Entwicklung neues Messsystem\Vergleich USB vs Intel Netzwerkkarte\Intel NIC 2.mat', 'DataSet', '-v7.3')

fclose(FileID);

