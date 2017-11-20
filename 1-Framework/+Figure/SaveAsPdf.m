function [] = SaveAsPdf(FigureHandle, OutputPath)

    try  

        Directory.CreateByFilePath(OutputPath);

        print(FigureHandle, '-dpdf', OutputPath)

        Display.Text(['Saved file ''' OutputPath '.png''.'])

    catch ex
        Display.Warning(ex)
    end

end