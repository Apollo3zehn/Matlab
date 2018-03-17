clc
clear
close all

%%

BasePath = 'C:\Users\vwilms\Desktop\Company.Scada\Company.Scada\bin\Release\';
NET.addAssembly([BasePath 'Company.Scada.dll']);

%%

ScadaConnection = Company.Scada.ScadaConnection('username', 'password');
TenMinuteValues = ScadaConnection.GetTenMinuteValues(1, 21, System.DateTime(2016, 10, 01), System.DateTime.Now, 'WEA003');
TenMinuteValues = double(TenMinuteValues);

ScadaConnection.GetWindFarmInfo

plot(TenMinuteValues);
grid on
xlabel('Time')
ylabel('Power in kW')

