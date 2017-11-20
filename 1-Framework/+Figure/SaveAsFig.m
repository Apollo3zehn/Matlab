function [] = SaveAsFig(FigureHandle, OutputPath)

    try  

        Directory.CreateByFilePath(OutputPath);

        saveas(FigureHandle, [OutputPath '.fig'])

    catch ex
        Display.Warning(ex)
    end

end