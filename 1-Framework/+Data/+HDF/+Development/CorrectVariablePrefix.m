function newVariableName = CorrectVariableName(variableName)

    C_to_BF     = { ...
                    'W1_000_C_Gondelposition'
                    'W1_000_C_Gondelposition'
                    'W1_001_C_Rotor_Position'
                    'W1_002_C_Rotordrehzahl'
                    'W1_003_C_Generatordrehzahl'
                    'W1_004_C_Windgeschwindigkeit_1'
                    'W1_005_C_Windgeschwindigkeit_2'
                    'W1_006_C_Windrichtung_1_relativ'
                    'W1_007_C_Windrichtung_2_relativ'
                    'W1_008_C_Pitchwinkel_Blatt_1'
                    'W1_009_C_Pitchwinkel_Blatt_2'
                    'W1_010_C_Pitchwinkel_Blatt_3'
                    'W1_011_C_Beschleunigung_Gondel_laengs'
                    'W1_012_C_Beschleunigung_Gondel_quer'
                    'W1_029_C_Frequenz_Netz'
                    'W1_038_C_EB_Wirkleistung'   
                    'W1_043_C_Soll_GeneratorklemmenMoment'
                    'W1_044_C_Ist_GeneratorklemmenMoment'
                    'W1_045_C_Beschleunigung_Gondel_laengs2'
                    'W1_046_C_Beschleunigung_Gondel_quer2' 
                    'W1_047_C_Rotorlager_Durchfluss'     
                    'W1_048_C_Yawstrom_Motor_1'
                    'W1_049_C_Yawstrom_Motor_2'
                    'W1_050_C_Yawstrom_Motor_3'
                    'W1_051_C_Yawstrom_Motor_4'
                    'W1_052_C_Yawstrom_Motor_5'
                    'W1_053_C_Yawstrom_Motor_6'
                    'W1_054_C_Yawstrom_Motor_7'
                    'W1_055_C_Yawstrom_Motor_8'
                    'W1_056_C_Wegmessung_Drehmomentstuetze_1_axial'
                    'W1_057_C_Wegmessung_Drehmomentstuetze_1_tangential'
                    'W1_058_C_Wegmessung_Drehmomentstuetze_3_axial'
                    'W1_059_C_Wegmessung_Drehmomentstuetze_3_tangential'
                    'W1_062_C_Getriebeoel_Druck_Eingang_1'
                    'W2_112_C_Aussentemperatur_Gondel'
                    'W2_113_C_Luftdruck_Gondel_aussen'
                    'W2_116_C_Stromaufnahme_24V_Gondel'
                    'W2_117_C_Stromaufnahme_Motorstrom_Achse_1'
                    'W2_118_C_Stromaufnahme_Motorstrom_Achse_2'
                    'W2_119_C_Stromaufnahme_Motorstrom_Achse_3'
                   };

    C_to_Null   = { ...
                    'W1_172_C_elektr_RotorWinkel'
                    'W1_173_C_Strom_Mitsystem_d_Id1_Soll'
                    'W1_174_C_Strom_Mitsystem_q_Iq1_Soll'
                    'W1_WCX_155_C_Achse_1_angular_encoder_RCA'
                    'W1_WCX_156_C_Achse_2_angular_encoder_RCA'
                    'W1_WCX_157_C_Achse_3_angular_encoder_RCA'
                    'W1_WCX_158_C_Achse_3_655TE_HKSteg_SSACC_X'
                    'W1_WCX_159_C_Achse_3_655TE_HKSteg_SSACC_Y'
                    'W2_196_C_Strom_Gegensystem_d_Id2_Soll'
                    'W2_197_C_Strom_Gegensystem_q_Iq2_Soll'
                    'W2_198_C_Windgeschwindigkeit_Rotor'
                    'W2_200_C_rotor_schief_moment'
                    'W2_201_C_rotor_schief_moment_notch'
                    'W2_208_C_Temp_P1_Turmmitte'
                    'W2_209_C_Temp_P1_Leistungskabel'
                    'W2_210_C_Temp_Gondelwand'
                    'W2_211_C_Temp_P9a_Turmmitte'
                    'W2_212_C_Temp_P9a_Turmwand'
                    'W2_213_C_Temp_P7_Turmwand'
                    'W2_214_C_Temp_P3_Turmmitte'
                    'W2_215_C_Temp_P3_Turmwand'
                    'W2_216_C_Temp_P8_Kuppelfeldplattform'
                    'W2_217_C_UmgebungsTemp_Luftaufbereitung'
                    'W2_218_C_UmgebungsTemp_NC300'
                    'W2_219_C_Temp_Luftaufbereitung_Zuluft'
                    'W2_220_C_Luftfeuchte_P8_Kuppelfeldplattform'
                    'W2_221_C_Luftfeuchte_Gondel'
                    'W2_222_C_Luftfeuchte_Luftaufbereitung_Zuluft'
                    'W2_WCX_176_C_Achse_2_33LE_DSACC_X'
                    'W2_WCX_177_C_Achse_2_33LE_DSACC_Y'
                    'W2_WCX_178_C_Achse_2_33TE_SSACC_X'
                    'W2_WCX_179_C_Achse_2_33TE_SSACC_Y'
                    'W2_WCX_180_C_Achse_2_655LE_VKSteg_DSACC_X'
                    'W2_WCX_181_C_Achse_2_655LE_VKSteg_DSACC_Y'
                    'W2_WCX_182_C_Achse_2_655TE_HKSteg_SSACC_X'
                    'W2_WCX_183_C_Achse_2_655TE_HKSteg_SSACC_Y'
                    'W2_WCX_184_C_Achse_1_33LE_DSACC_X'
                    'W2_WCX_185_C_Achse_1_33LE_DSACC_Y'
                    'W2_WCX_186_C_Achse_1_33TE_SSACC_X'
                    'W2_WCX_187_C_Achse_1_33TE_SSACC_Y'
                    'W2_WCX_188_C_Achse_1_655LE_VKSteg_DSACC_X'
                    'W2_WCX_189_C_Achse_1_655LE_VKSteg_DSACC_Y'
                    'W2_WCX_190_C_Achse_1_655TE_HKSteg_SSACC_X'
                    'W2_WCX_191_C_Achse_1_655TE_HKSteg_SSACC_Y'
                    'W2_WCX_192_C_TimeStamp_Low_Word_Gantner'
                    'W2_WCX_193_C_TimeStamp_High_Word_Gantner'
                    'W2_WCX_194_C_Temperatur_GFK_1'
                    'W2_WCX_195_C_Temperatur_GFK_2'
                   };
            
	C_to_Mast   = { ...
                    'W2_064_Watchdog'
                    'W2_065_C_Windspeed_130m'
                    'W2_066_C_Windspeed_130m'
                    'W2_067_C_Windspeed_100_0m'
                    'W2_068_C_Windspeed_80_0m'
                    'W2_069_C_Windspeed_60_0m'
                    'W2_070_C_Winddirection_127_5m'
                    'W2_071_C_Winddirection_125_5m'
                    'W2_072_C_Winddirection_60_0m'
                    'W2_073_C_Airpressure_126_5m_Messung_1'
                    'W2_074_C_Airpressure_126_5m_Messung_2'
                    'W2_075_C_Airtemperature_126_5m_Messung_1'
                    'W2_076_C_Airhumidity_126_5m_Messung_2'
                    'W2_077_C_Airtemperature_126_5m_Messung_2'
                    'W2_078_C_Airhumidity_126_5m_Messung_2'
                    'W2_079_C_Rainsensor_126_5m'
                    'W2_080_C_Neigung_X_Achse'
                    'W2_081_C_Neigung_Y_Achse'
                   };
               
	C_to_WLMU   = { ...
                    'W2_082_C_Strom_L1'
                    'W2_083_C_Strom_L2'
                    'W2_084_C_Strom_L3'
                    'W2_090_C_Frequenz'
                   };
    
	C_to_DNVGL  = { ...
                    'W2_114_C_Leistungsmessung_LKT'
                   };
               
    switch (variableName)
        case C_to_BF
            newVariableName = strrep(variableName, '_C_', '_BF_');
        case C_to_Null
            newVariableName = strrep(variableName, '_C_', '_');
        case C_to_Mast
            newVariableName = strrep(variableName, '_C_', '_Mast_');
        case C_to_WLMU
            newVariableName = strrep(variableName, '_C_', '_WLMU_');
        case C_to_DNVGL
            newVariableName = strrep(variableName, '_C_', '_DNVGL_');
        otherwise
            newVariableName = variableName;
    end 
       
end

