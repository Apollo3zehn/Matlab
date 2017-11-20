clc
clear

DateTimeBegin       	= datenum(2014, 09, 01, 0, 0, 0);
DateTimeEnd             = datenum(2014, 09, 02, 0, 0, 0);

Interval      	= TimeSpan(1, 0, 0, 0);

SensorNames     = {...          
                    'W1_000_BF_Gondelposition' % 0.01
                    'W1_001_BF_Rotor_Position' % 0.01
                    'W1_002_BF_Rotordrehzahl' % 0.01
                    'W1_003_BF_Generatordrehzahl' % 0.01
                    'W1_004_BF_Windgeschwindigkeit_1' % 0.1
                    'W1_005_BF_Windgeschwindigkeit_2' % 0.1
                    'W1_008_BF_Pitchwinkel_Blatt_1' % 0.01
                    'W1_009_BF_Pitchwinkel_Blatt_2' % 0.01
                    'W1_010_BF_Pitchwinkel_Blatt_3' % 0.01
                    'W1_013_BF_Wirkleistung_Generator'
                    'W1_014_BF_Blindleistung_Generator'
                    'W1_030_BF_Statusvektor_1_WEA'
                    'W1_031_BF_Statusvektor_2_WEA'
                    'W2_112_BF_Auﬂentemperatur_Gondel' % 0.1
                    'W2_113_BF_Luftdruck_Gondel_auﬂen' % 0.1

                    'W2_065_Mast_Windspeed_130m' % 0.01
                    'W2_067_Mast_Windspeed_100_0m' % 0.01
                    'W2_068_Mast_Windspeed_80_0m' % 0.01
                    'W2_069_Mast_Windspeed_60_0m' % 0.01
                    'W2_070_Mast_Winddirection_127_5m' % 0.1
                    'W2_071_Mast_Winddirection125_5m' % 0.1
                    'W2_072_Mast_Winddirection60_0m' % 0.1
                    'W2_073_Mast_Airpressure_126_5m_Messung_1' % 100
                    'W2_075_Mast_Airtemperature_126_5m_Messung_1' % 0.1
                    'W2_076_Mast_Airhumidity_126_5m_Messung_1' % 0.1
                    'W2_079_Mast_Rainsensor_126_5m' % 0.1

                    'W2_088_WLMU_Wirkleistung'
                    'W2_089_WLMU_Blindleistung'                   
                    };


% SensorNames     = {...          
%                     'W1_000_C_Gondelposition'
%                     'W1_001_BF_Rotor_Position'
%                     'W1_002_BF_Rotordrehzahl'
%                     'W1_004_C_Windgeschwindigkeit_1'
%                     'W1_005_C_Windgeschwindigkeit_2'
%                     'W1_008_BF_Pitchwinkel_Blatt_1'
%                     'W1_009_BF_Pitchwinkel_Blatt_2'
%                     'W1_010_BF_Pitchwinkel_Blatt_3'
%                     'W1_013_BF_Wirkleistung_Generator'
%                     'W1_027_Schutz_Wirkleistung_Netz_OSseitig'
%                     'W1_030_BF_Statusvektor_1_WEA'
%                     'W1_031_BF_Statusvektor_2_WEA'
%                     'W1_WCX_152_Achse_1_blade_bearing_RCA'
%                     'W1_WCX_153_Achse_2_blade_bearing_RCA'
%                     'W1_WCX_154_Achse_3_blade_bearing_RCA'
%                     'W1_WCX_155_Achse_1_angular_encoder_RCA'
%                     'W1_WCX_156_Achse_2_angular_encoder_RCA'
%                     'W1_WCX_157_Achse_3_angular_encoder_RCA'
%                     'W2_088_WLMU_Wirkleistung'
%                     'W2_117_BF_Motorstrom_Achse_1'
%                     'W2_118_BF_Motorstrom_Achse_2'
%                     'W2_119_BF_Motorstrom_Achse_3'
%                     'W2_120_Schlagmoment_Blatt_1_Insensys'
%                     'W2_121_Schwenkmoment_Blatt_1_Insensys'
%                     'W2_122_Schlagmoment_Blatt_2_Insensys'
%                     'W2_123_Schwenkmoment_Blatt_2_Insensys'
%                     'W2_124_Schlagmoment_Blatt_3_Insensys'
%                     'W2_125_Schwenkmoment_Blatt_3_Insensys'
%                     };

% SensorNames     = {...                                
%                     'W1_000_C_Gondelposition'
%                     'W1_001_BF_Rotor_Position'
%                     'W1_002_BF_Rotordrehzahl'
%                     'W1_004_C_Windgeschwindigkeit_1'
%                     'W1_005_C_Windgeschwindigkeit_2'
%                     'W1_008_BF_Pitchwinkel_Blatt_1'
%                     'W1_009_BF_Pitchwinkel_Blatt_2'
%                     'W1_010_BF_Pitchwinkel_Blatt_3'
%                     'W1_013_BF_Wirkleistung_Generator'
%                     'W1_027_Schutz_Wirkleistung_Netz_OSseitig'
%                     'W1_WCX_152_Achse_1_blade_bearing_RCA'
%                     'W1_WCX_153_Achse_2_blade_bearing_RCA'
%                     'W1_WCX_154_Achse_3_blade_bearing_RCA'
%                     'W1_WCX_155_Achse_1_angular_encoder_RCA'
%                     'W1_WCX_156_Achse_2_angular_encoder_RCA'
%                     'W1_WCX_157_Achse_3_angular_encoder_RCA'
%                     'W2_088_WLMU_Wirkleistung'
%                     'W2_117_BF_Motorstrom_Achse_1'
%                     'W2_118_BF_Motorstrom_Achse_2'
%                     'W2_119_BF_Motorstrom_Achse_3'
%                     'W2_120_Schlagmoment_Blatt_1_Insensys'
%                     'W2_121_Schwenkmoment_Blatt_1_Insensys'
%                     'W2_122_Schlagmoment_Blatt_2_Insensys'
%                     'W2_123_Schwenkmoment_Blatt_2_Insensys'
%                     'W2_124_Schlagmoment_Blatt_3_Insensys'
%                     'W2_125_Schwenkmoment_Blatt_3_Insensys'
%                     };

% SensorNames     = {...                                
%                     'W1_000_C_Gondelposition'
%                     'W1_001_C_Rotor_Position'
%                     'W1_002_C_Rotordrehzahl'
%                     'W1_004_C_Windgeschwindigkeit_1'
%                     'W1_005_C_Windgeschwindigkeit_2'
%                     'W1_008_C_Pitchwinkel_Blatt_1'
%                     'W1_009_C_Pitchwinkel_Blatt_2'
%                     'W1_010_C_Pitchwinkel_Blatt_3'
%                     'W1_013_BF_Wirkleistung_Generator'
%                     'W1_027_Schutz_Wirkleistung_Netz_OSseitig'
%                     'W2_088_WLMU_Wirkleistung'
%                     'W2_120_Schlagmoment_Blatt_1_Insensys'
%                     'W2_121_Schwenkmoment_Blatt_1_Insensys'
%                     'W2_122_Schlagmoment_Blatt_2_Insensys'
%                     'W2_123_Schwenkmoment_Blatt_2_Insensys'
%                     'W2_124_Schlagmoment_Blatt_3_Insensys'
%                     'W2_125_Schwenkmoment_Blatt_3_Insensys'
%                     };

% SensorNames     = {...                                
%                     'W1_000_C_Gondelposition'
%                     'W1_001_C_Rotor_Position'
%                     'W1_002_C_Rotordrehzahl'
%                     'W1_004_C_Windgeschwindigkeit_1'
%                     'W1_008_C_Pitchwinkel_Blatt_1'
%                     'W1_009_C_Pitchwinkel_Blatt_2'
%                     'W1_010_C_Pitchwinkel_Blatt_3'
%                     'W1_013_BF_Wirkleistung_Generator'
%                     'W1_WCX_032_blade3_low_pressure_strain'
%                     'W1_WCX_033_blade3_low_pressure_temperature'
%                     'W1_WCX_035_blade1_transverse_trailing_edge_strain'
%                     'W1_WCX_036_blade3_transverse_high_pressure_strain_dummy'
%                     'W1_WCX_037_blade3_transverse_high_pressure_strain'
%                     'W1_160_RotorNickMoment'
%                     'W1_161_RotorGierMoment'
%                     'W2_092_GLGH_Schlagmoment_Blatt_1'
%                     'W2_093_GLGH_Schwenkmoment_Blatt_1'
%                     'W2_094_GLGH_Schlagmoment_Blatt_2'
%                     'W2_095_GLGH_Schwenkmoment_Blatt_2'  
%                     'W2_096_GLGH_Schlagmoment_Blatt_3'
%                     'W2_097_GLGH_Schwenkmoment_Blatt_3'
%                     'W2_108_Sim_Schlagmoment_Blatt_1'
%                     'W2_109_Sim_Schwenkmoment_Blatt_1'
%                     'W2_110_Sim_Schlagmoment_Blatt_2'
%                     'W2_111_Sim_Schwenkmoment_Blatt_2'
%                     'W2_117_C_Stromaufnahme_Motorstrom_Achse_1'
%                     'W2_118_C_Stromaufnahme_Motorstrom_Achse_2'
%                     'W2_119_C_Stromaufnahme_Motorstrom_Achse_3'
%                     'W2_120_Schlagmoment_Blatt_1_Insensys'
%                     'W2_121_Schwenkmoment_Blatt_1_Insensys'
%                     'W2_122_Schlagmoment_Blatt_2_Insensys'
%                     'W2_123_Schwenkmoment_Blatt_2_Insensys'
%                     'W2_124_Schlagmoment_Blatt_3_Insensys'
%                     'W2_125_Schwenkmoment_Blatt_3_Insensys'
%                     'W2_126_Sim_Schlagmoment_Blatt_3'
%                     'W2_127_Sim_Schlagmoment_Blatt_3'
%                     'W1_WCX_152_Achse_1_blade_bearing_RCA'
%                     'W1_WCX_153_Achse_2_blade_bearing_RCA'
%                     'W1_WCX_154_Achse_3_blade_bearing_RCA'
%                     'W1_WCX_155_Achse_1_angular_encoder_RCA'
%                     'W1_WCX_156_Achse_2_angular_encoder_RCA'
%                     'W1_WCX_157_Achse_3_angular_encoder_RCA'
%                     'W1_WCX_155_C_Achse_1_angular_encoder_RCA'
%                     'W1_WCX_156_C_Achse_2_angular_encoder_RCA'
%                     'W1_WCX_157_C_Achse_3_angular_encoder_RCA'
%                     'W1_WCX_152_Achse_3_33LE_DSACC_X'
%                     'W1_WCX_153_Achse_3_33LE_DSACC_Y'
%                     'W1_WCX_154_Achse_3_33TE_SSACC_X'
%                     'W1_WCX_155_Achse_3_33TE_SSACC_Y'
%                     'W1_WCX_156_Achse_3_655LE_VKSteg_DSACC_X'
%                     'W1_WCX_157_Achse_3_655LE_VKSteg_DSACC_Y'
%                     'W1_WCX_158_Achse_3_655TE_HKSteg_SSACC_X'
%                     'W1_WCX_159_Achse_3_655TE_HKSteg_SSACC_Y'
%                     'W2_WCX_176_Achse_2_33LE_DSACC_X'
%                     'W2_WCX_177_Achse_2_33LE_DSACC_Y'
%                     'W2_WCX_178_Achse_2_33TE_SSACC_X'
%                     'W2_WCX_179_Achse_2_33TE_SSACC_Y'
%                     'W2_WCX_180_Achse_2_655LE_VKSteg_DSACC_X'
%                     'W2_WCX_181_Achse_2_655LE_VKSteg_DSACC_Y'
%                     'W2_WCX_182_Achse_2_655TE_HKSteg_SSACC_X'
%                     'W2_WCX_183_Achse_2_655TE_HKSteg_SSACC_Y'
%                     'W2_WCX_184_Achse_1_33LE_DSACC_X'
%                     'W2_WCX_185_Achse_1_33LE_DSACC_Y'
%                     'W2_WCX_186_Achse_1_33TE_SSACC_X'
%                     'W2_WCX_187_Achse_1_33TE_SSACC_Y'
%                     'W2_WCX_188_Achse_1_655LE_VKSteg_DSACC_X'
%                     'W2_WCX_189_Achse_1_655LE_VKSteg_DSACC_Y'
%                     'W2_WCX_190_Achse_1_655TE_HKSteg_SSACC_X'
%                     'W2_WCX_191_Achse_1_655TE_HKSteg_SSACC_Y'
%                     'W2_117_C_Stromaufnahme_Motorstrom_Achse_1'
%                     'W2_118_C_Stromaufnahme_Motorstrom_Achse_2'
%                     'W2_119_C_Stromaufnahme_Motorstrom_Achse_3'
%                     };

for i = DateTimeBegin : Interval.ToDateTime : DateTimeEnd
    
    try
           
        DataSet = Data.Delphin.ByDateTime(Lehe03_MetMast.HighResolution_MetMast.DataDirectory, SensorNames, i, i + Interval.ToDateTime, TimeSpan(0, 0, 0, 0.04));

        OutputFilePath = FileInformation.BuildOutputFilePathByDateTime(Environment.PreparedPath, ...
                                                                   'Lehe03 HighResolution MetMast GetSensorsFromMat Jon', ...
                                                                   [], ...
                                                                   i, i + Interval.ToDateTime);

        Directory.CreateByFilePath(OutputFilePath)

        save(OutputFilePath, 'DataSet', '-v7.3')
        
    catch ex 
        warning(ex.message)
    end
    
end
              