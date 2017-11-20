clc
clear
close all

% set(gcf, 'Units', 'Points', ...
%          'Position',[0 0 1000 600])
% movegui(gcf, 'center')

%data    = load('M:\Data Analysis\Testumgebung_VWI\1-Data\Bladed\ByMatlab\Kaimal_Seed_01_V_154.mat');
data	= TurbulentWindField.Data.ReadWnd('M:\Data Analysis\Testumgebung_VWI\1-Data\Bladed\ByMatlab\Kaimal_Seed_01_V_100.wnd');
data	= TurbulentWindField.Preparation.Format(data, [1 0.8 0.5] * 10);

Structures.FieldsToWorkspace(data);

%% Live plot

TimeIndex = 1;

AH1 = subplot(2, 3, 1);
AH2 = subplot(2, 3, 4);
AH3 = subplot(2, 3, 2);
AH4 = subplot(2, 3, 5);
AH5 = subplot(2, 3, 3);
AH6 = subplot(2, 3, 6);

SH1 = surf(AH1, squeeze(WindField_x(1, :, :)), 'EdgeColor', 'none', 'LineStyle', 'none','FaceLighting', 'phong');
caxis(AH1, [MeanWindSpeed-4 MeanWindSpeed+4])
zlim(AH1, [0 20])
title(AH1, 'u (m/s)')
SH2 = pcolor(AH2, squeeze(WindField_x(1, :, :)));
set(SH2, 'EdgeColor', 'none')
caxis(AH2, [MeanWindSpeed-4 MeanWindSpeed+4])

SH3 = surf(AH3, squeeze(WindField_y(1, :, :)), 'EdgeColor', 'none', 'LineStyle', 'none','FaceLighting', 'phong');
caxis(AH3, [-4 +4])
zlim(AH3, [-4 4])
title(AH3, 'v (m/s)')
SH4 = pcolor(AH4, squeeze(WindField_y(1, :, :)));
set(SH4, 'EdgeColor', 'none')
caxis(AH4, [-4 +4])

SH5 = surf(AH5, squeeze(WindField_z(1, :, :)), 'EdgeColor', 'none', 'LineStyle', 'none','FaceLighting', 'phong');
caxis(AH5, [-4 +4])
zlim(AH5, [-4 4])
title(AH5, 'w (m/s)')
SH6 = pcolor(AH6, squeeze(WindField_z(1, :, :)));
set(SH6, 'EdgeColor', 'none')
caxis(AH6, [-4 +4])

for TimeIndex = 1 : FftLength 

    set(SH1, 'ZData', squeeze(WindField_x(TimeIndex, :, :)))
    set(SH2, 'CData', squeeze(WindField_x(TimeIndex, :, :)))
    set(SH3, 'ZData', squeeze(WindField_y(TimeIndex, :, :)))
    set(SH4, 'CData', squeeze(WindField_y(TimeIndex, :, :)))
    set(SH5, 'ZData', squeeze(WindField_z(TimeIndex, :, :)))
    set(SH6, 'CData', squeeze(WindField_z(TimeIndex, :, :)))
    
    drawnow
    
    pause(0.25)    

end