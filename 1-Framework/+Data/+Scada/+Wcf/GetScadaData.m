clc
clear
close all

%%

BasePath = 'C:\Users\vwilms\Desktop\Adwen.Scada\Adwen.Scada\bin\Release\';
NET.addAssembly([BasePath 'Adwen.Scada.dll']);

%%

ScadaConnection = Adwen.Scada.ScadaConnection('VWilms', 'janosch1');
TenMinuteValues = ScadaConnection.GetTenMinuteValues(1, 21, System.DateTime(2016, 10, 01), System.DateTime.Now, 'WEA003');
TenMinuteValues = double(TenMinuteValues);

ScadaConnection.GetWindFarmInfo

plot(TenMinuteValues);
grid on
xlabel('Time')
ylabel('Power in kW')

