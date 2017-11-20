function [] = SaveAsEmf(FigureHandle, OutputPath)

    try  

        Directory.CreateByFilePath(OutputPath);

        print(FigureHandle, '-dmeta', OutputPath)

    catch ex
        Display.Warning(ex)
    end

end