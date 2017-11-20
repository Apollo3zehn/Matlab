function FileCommaToDots(FileName)

        Data    = fileread(FileName);
        Data    = strrep(Data, ',', '.');
        
        FH      = fopen(FileName, 'w');
        
        fwrite(FH, Data, 'char');
        fclose(FH);

end

