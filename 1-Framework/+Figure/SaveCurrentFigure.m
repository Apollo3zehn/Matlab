function [] = SaveCurrentFigure()

    OutputPath = [Environment.TempDirectory '\temporary'];

    Figure.SaveAsFig(gcf, OutputPath)
    Figure.SaveAsPng(gcf, OutputPath)
    Figure.SaveAsEmf(gcf, OutputPath)
    Figure.SaveAsPdf(gcf, OutputPath)

end

