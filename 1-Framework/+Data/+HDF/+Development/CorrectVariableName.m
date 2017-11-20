function newVariableName = CorrectVariableName(variableName, dateTime)

    switch (variableName)
        case 'W2_093_GLGH_Schwengmment_Blatt_1'
            newVariableName = 'W2_093_GLGH_Schwenkmoment_Blatt_1';
            
        case 'W1_047_BF_Rotorlager_Durchfluss'
            newVariableName = 'W1_047_BF_Rotorlagerdurchfluss';
            
        case 'W2_114_DNVGL_Leistungsmessung_LKT'
            newVariableName = 'W2_114_DNVGL_Power_LKT';
            
        case 'W2_117_BF_Stromaufnahme_Motorstrom_Achse_1'
            newVariableName = 'W2_117_BF_Motorstrom_Achse_1';
            
        case 'W2_118_BF_Stromaufnahme_Motorstrom_Achse_2'
            newVariableName = 'W2_118_BF_Motorstrom_Achse_2';
            
        case 'W2_119_BF_Stromaufnahme_Motorstrom_Achse_3'
            newVariableName = 'W2_119_BF_Motorstrom_Achse_3';
            
        case 'W2_WCX_176_Achse_2_33LE_DSACC_X'
            if datenum(2017, 02, 23) <= dateTime 
                newVariableName = 'W2_WCX_176_Achse_1_Pitchgeschwindigkeit';
            else
                newVariableName = variableName;    
            end
            
        case 'W2_WCX_177_Achse_2_33LE_DSACC_Y' 
            if datenum(2017, 02, 23) <= dateTime 
                newVariableName = 'W2_WCX_177_Achse_2_Pitchgeschwindigkeit';
            else
                newVariableName = variableName;    
            end
            
        case 'W2_WCX_178_Achse_2_33TE_SSACC_X'
            if datenum(2017, 02, 23) <= dateTime 
                newVariableName = 'W2_WCX_178_Achse_3_Pitchgeschwindigkeit';
            else
                newVariableName = variableName;    
            end

        otherwise
            newVariableName = variableName;
    end 
       
end

