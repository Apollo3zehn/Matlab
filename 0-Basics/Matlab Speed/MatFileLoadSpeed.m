clc
clear

% Groﬂe Unterschiede, wenn die Dateien lokal oder im Netzwerk liegen

%DirectoryPath = 'M:\Data Analysis\Testumgebung_VWI\2-DataPrepared\Lehe03 HighResolution MetMast Test';
DirectoryPath = 'C:\Users\vwilms\Desktop\MatFileLoadSpeed';

v7FileNames  	= { ...
                    [DirectoryPath '\Dataset_2014-07-01T00-00.mat'];
                    [DirectoryPath '\Dataset_2014-07-01T00-10.mat'];
                    [DirectoryPath '\Dataset_2014-07-01T00-20.mat'];
                    [DirectoryPath '\Dataset_2014-07-01T00-30.mat'];
                    [DirectoryPath '\Dataset_2014-07-01T00-40.mat'];
                    [DirectoryPath '\Dataset_2014-07-01T00-50.mat'];
                    [DirectoryPath '\Dataset_2014-07-01T01-00.mat'];
                    [DirectoryPath '\Dataset_2014-07-01T01-10.mat'];
                    [DirectoryPath '\Dataset_2014-07-01T01-20.mat'];
                    [DirectoryPath '\Dataset_2014-07-01T01-30.mat'];
              };
          
v73FileNames  	= { ...
                    [DirectoryPath '\Dataset_2014-07-01T00-00_2.mat'];
                    [DirectoryPath '\Dataset_2014-07-01T00-10_2.mat'];
                    [DirectoryPath '\Dataset_2014-07-01T00-20_2.mat'];
                    [DirectoryPath '\Dataset_2014-07-01T00-30_2.mat'];
                    [DirectoryPath '\Dataset_2014-07-01T00-40_2.mat'];
                    [DirectoryPath '\Dataset_2014-07-01T00-50_2.mat'];
                    [DirectoryPath '\Dataset_2014-07-01T01-00_2.mat'];
                    [DirectoryPath '\Dataset_2014-07-01T01-10_2.mat'];
                    [DirectoryPath '\Dataset_2014-07-01T01-20_2.mat'];
                    [DirectoryPath '\Dataset_2014-07-01T01-30_2.mat'];
                };

disp('--- v7 ---')
Display.NewLine

disp('matfile (1x)')
tic
a = matfile(v7FileNames{1, 1});
b = a.CH001;
c = a.CH002;
d = a.CH003;
e = a.CH004;
f = a.CH005;
g = a.CH006;
h = a.CH007;
toc
Display.NewLine

disp('load load (10x)')
tic
for FileName = v7FileNames'
    load(char(FileName), 'info')
end
for FileName = v7FileNames'
    load(char(FileName), 'CH001', 'CH002', 'CH003', 'CH004', 'CH005', 'CH006', 'CH007')
end
toc
Display.NewLine

disp('load (10x)')
tic
for FileName = v7FileNames'
    load(char(FileName))
end
toc
Display.NewLine

disp('--- v7.3 ---')
Display.NewLine

disp('h5read (10x)')
tic
for FileName = v73FileNames'
    a=h5read(char(FileName), '/CH001/values'); 
    b=h5read(char(FileName), '/CH002/values'); 
    c=h5read(char(FileName), '/CH003/values'); 
    d=h5read(char(FileName), '/CH004/values'); 
    e=h5read(char(FileName), '/CH005/values'); 
    f=h5read(char(FileName), '/CH006/values'); 
    g=h5read(char(FileName), '/CH007/values'); 
end
toc
Display.NewLine

disp('matfile (1x)')
tic
a = matfile(v7FileNames{1, 1});
b = a.CH001;
c = a.CH002;
d = a.CH003;
e = a.CH004;
f = a.CH005;
g = a.CH006;
h = a.CH007;
toc
Display.NewLine

disp('load load (10x)')
tic
for FileName = v73FileNames'
    load(char(FileName), 'info')
end
for FileName = v73FileNames'
    load(char(FileName), 'CH001', 'CH002', 'CH003', 'CH004', 'CH005', 'CH006', 'CH007')
end
toc
Display.NewLine

disp('load (10x)')
tic
for FileName = v73FileNames'
    load(char(FileName))
end
toc
Display.NewLine