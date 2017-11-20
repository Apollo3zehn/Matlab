clc
clear

load('M:\Rohdaten_M5000+\2014\09\mat\Dataset_2014-09-01T00-00.mat')

Data        = [struct2cell(data.info.channel_real_names) fieldnames(data.info.channel_real_names)];
[~,Indices] = sort(Data(:, 1));
Data        = Data(Indices, :);

display(Data);