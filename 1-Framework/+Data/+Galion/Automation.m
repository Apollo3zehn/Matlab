clc
clear
fclose('all');

%% Settings

Shutdown            = false;

Display.Headline('Preparing Galion data')

%% Request file informations

DateTimeBegin       = datenum(2016, 12, 12, 23, 45, 0);
DateTimeEnd         = datenum(2013, 12, 14,  0,  0, 0);

Display.TextWithoutBreaks('Creating file list ... ')
FileInformationList = Data.Galion.Helper.GetFileInformationList(Galion.RawDataPath, DateTimeBegin, DateTimeEnd, 'yyyymmdd', 'ddmmyyhh', 'scn');
Display.Done

FileInfoCount     	= length(FileInformationList);

%%

StopWatch.Start

for FileInfoNumber = 1 : FileInfoCount

    FileInformation = FileInformationList(FileInfoNumber);

    Display.ProgressStatus('file', FileInfoNumber, FileInfoCount, StopWatch.ElapsedTime, 0);
    
    try  
        Data.Galion.ToMat(FileInformation)    
    catch ex
        Display.Warning(ex)
    end

end

%%
display('Finished.')

if Shutdown == 1
	!shutdown -s -f
end