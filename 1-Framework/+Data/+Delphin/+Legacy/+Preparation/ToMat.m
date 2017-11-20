function [] = ToMat (FileInfo)

    load(FileInfo.Path)

    HighResolutionData      = D;
    
    DateTimeBegin           = DateTime.ParseExact(FileInfo.Name, 1, 'yyyy-mm-dd_hh-MM-ss');
   
    HighResolutionData.RowCount = length(D.TimeInSec);
    
    HighResolutionData      = Structures.AddDateTimeField(HighResolutionData, HighResolutionData.RowCount, DateTimeBegin, Lehe03_MetMast.HighResolution_MetMast.FullTimeSpan);
    HighResolutionData      = Structures.RenameField(HighResolutionData, 'BF_Gondelposition', 'BF_Gondelposition__000');
    HighResolutionData      = Structures.RenameField(HighResolutionData, 'BF_Rotordrehzahl', 'BF_Rotordrehzahl__002');
    HighResolutionData      = Structures.RenameField(HighResolutionData, 'BF_Anemometer1_Windspeed', 'BF_Windgeschwindigkeit_1__004');
    HighResolutionData      = Structures.RenameField(HighResolutionData, 'BF_Pitchwinkel_Blatt_1', 'BF_Pitchwinkel_Blatt_1__008');
    HighResolutionData      = Structures.RenameField(HighResolutionData, 'BF_Wirkleistung_Generator', 'BF_Wirkleistung_Generator__013');
    HighResolutionData      = rmfield(HighResolutionData, 'TimeInSec');
    HighResolutionData      = orderfields(HighResolutionData);
    
    Directory.CreateByFilePath(FileInfo.OutputPath)

    save(FileInfo.OutputPath, 'HighResolutionData', '-mat');
    Display.NewLine
    display(['Saved file ''' FileInfo.OutputPath '''.'])

end