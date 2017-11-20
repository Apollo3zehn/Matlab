function [] = SaveAsPng(FigureHandle, OutputPath)

    try  

        Directory.CreateByFilePath(OutputPath);

        print(FigureHandle, '-dpng', OutputPath)

        Display.Text(['Saved file ''' OutputPath '.png''.'])

    catch ex
        Display.Warning(ex)
    end

end