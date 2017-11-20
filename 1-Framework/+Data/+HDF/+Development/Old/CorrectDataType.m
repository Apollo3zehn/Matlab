function newData = CorrectDataType(variableName, data)
    
    warning('check if this function is still correct when used for Alexander Meinicke')

	UINT        = { ...
                    'W1_030_BF_Statusvektor_1_WEA'
                    'W1_031_BF_Statusvektor_2_WEA'
                    'W1_039_MotStatusWord1'
                    'W1_040_MotStatusWord2'
                    'W1_041_MotStatusWord3'
                    'W1_042_MotStatusWord4'
                    'W1_164_Status_Umrichter'
                    'W1_175_Watchdog'
                    'W2_064_Watchdog'
                    'W2_091_Watchdog_DNVGL'
                    'W2_WCX_199_Watchdog_CX9020_Nabe'
                    'W2_223_Status_Interrogator'
                   };
               
    switch (variableName)
        case UINT
            newData = typecast(uint16(data), 'int16');
        otherwise
            newData = data;
    end 
       
end

