clc
clear
close all

DateTimeBegin           = datenum(2015, 05, 01, 13, 0, 0);
DateTimeEnd             = datenum(2015, 05, 05, 15, 0, 0);

SensorNames          = {...                                
                            'W1_030_BF_Statusvektor_1_WEA';
                            'W1_031_BF_Statusvektor_2_WEA';
                            'W1_164_Status_10_Boeen_Detektion_Aktiv';
                            'W1_164_Status_11_Rotor_Schieflast_Ueberwachung_aktiv';
                        };                     
        
HighResolutionData  = Data.Delphin.ByDateTime(Lehe03_MetMast.HighResolution_MetMast.DataDirectory, SensorNames, DateTimeBegin, DateTimeEnd, TimeSpan(0, 0, 0, 0));

DateTime            = HighResolutionData.DateTime;

figure
for i = 1 : 16
    subplot(4, 4, i); plot(DateTime, bitget(HighResolutionData.W1_030_BF_Statusvektor_1_WEA, i))    
    xlim([DateTime(1) DateTime(end)])
    ylim([-0.1 1.1])
    datetick('x', 'keeplimits')
end

figure
for i = 1 : 16
    subplot(4, 4, i); plot(DateTime, bitget(HighResolutionData.W1_031_BF_Statusvektor_2_WEA, i))    
    if i == 10
       hold on; plot(DateTime, ~HighResolutionData.W1_164_Status_10_Boeen_Detektion_Aktiv, 'r')
    end
    xlim([DateTime(1) DateTime(end)])
    ylim([-0.1 1.1])
    datetick('x', 'keeplimits')
end

figure
plot(DateTime, HighResolutionData.W1_164_Status_10_Boeen_Detektion_Aktiv)
xlim([DateTime(1) DateTime(end)])
ylim([-0.1 1.1])
 
datetick('x', 'keeplimits')

figure
plot(DateTime, HighResolutionData.W1_164_Status_11_Rotor_Schieflast_Ueberwachung_aktiv)
xlim([DateTime(1) DateTime(end)])
ylim([-0.1 1.1])

datetick('x', 'keeplimits')