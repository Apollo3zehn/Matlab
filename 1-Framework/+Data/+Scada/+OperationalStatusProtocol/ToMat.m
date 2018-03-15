function ToMat(FileInfo)

    try
      
        Convert.FileCommaToDots(FileInfo.Path);
   
        ScadaData               = readtable(FileInfo.Path);
        
        DateBegin               = textscan(strjoin(ScadaData{:, 1}, '\n'), '%2f.%2f.%4f');
        TimeBegin               = textscan(strjoin(ScadaData{:, 2}, '\n'), '%2f:%2f:%2f');
        ScadaData.DateTimeBegin = datenum(DateBegin{:, 3}, DateBegin{:, 2}, DateBegin{:, 1}, TimeBegin{:, 1}, TimeBegin{:, 2}, TimeBegin{:, 3});
        
        DateEnd                 = textscan(strjoin(ScadaData{:, 3}, '\n'), '%2f.%2f.%4f');
        TimeEnd                 = textscan(strjoin(ScadaData{:, 4}, '\n'), '%2f:%2f:%2f');
        ScadaData.DateTimeEnd   = datenum(DateEnd{:, 3}, DateEnd{:, 2}, DateEnd{:, 1}, TimeEnd{:, 1}, TimeEnd{:, 2}, TimeEnd{:, 3});
              
        ScadaData               = Data.Scada.OperationalStatusProtocol.To10MinuteValues(ScadaData); % optional
        
        Directory.CreateByFilePath(FileInfo.OutputPath)

        save([FileInfo.OutputPath '.mat'], 'ScadaData', '-mat');
        writetable(ScadaData, [FileInfo.OutputPath '.csv'], 'delimiter', ';');
        Display.Text(['Saved file ''' FileInfo.OutputPath '.mat''.'])

    catch ex

        fclose('all');
        delete(FileInfo.OutputPath)
        warning(ex.message)

    end

end