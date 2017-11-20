function [] = Korrelation

    clc
    clear
    close('all')

    %% Globale Variablen
    
    global GetNewReferenceImage;
    GetNewReferenceImage = false;
        
    global Restart;
    Restart = false;
        
    global Stop;
    Stop = false;
    
    %% Einstellungen

    Left            = 600;
    Top             = 600;
    Width           = 641;
    Height          = 481;
    
    Offset          = 20;    
    %vid.ROIPosition = [363 361 959 583];
    ROI             = [Left Top Width Height];
    Transformation  = [+Offset +Offset -2*Offset -2*Offset];
    RefAusschnitt   = [0 0 Width Height] + Transformation;
    
    OutputFileName  = [pwd '\' datestr(now, 'yyyy-mm-dd hh-MM-ss') '.csv'];
    
    Daten           = NaN(0, 1);
    Koeffizienten   = NaN(0, 1);       % legt Matrix an, in die Ergebnisse geschrieben werden

    %% Layout
    
    FH = figure ('name', 'Ergebnisse', ...              %erzeugt eine Gesamtansicht von allen Axen
                    'PaperPositionMode', 'manual', ...
                    'PaperUnits', 'points', ... 
                    'PaperSize', [1700 1000], ...  
                    'PaperPosition', [0 0 1700 1000], ...
                    ...
                    'Units', 'Points', ...
                    'Position',[0 0 1700 1000]);

    UH1 = uicontrol(FH, ...
                  'Style', 'edit', 'String', '0',...
                  'Position', [20 600 50 40]);
          
    UH2 = uicontrol(FH, ...
                  'Style', 'edit', 'String', '1',...
                  'Position', [70 600 50 40]); 

    UH3 = uicontrol(FH, ...
              'Style', 'pushbutton', 'String', 'Pause',...
              'Position', [20 500 100 40],...
              'Callback', @btnPause_Click); 
          
    UH4 = uicontrol(FH, ...
      'Style', 'pushbutton', 'String', 'Debug-Pause',...
      'Position', [20 400 100 40],...
      'Callback', @btnDebugPause_Click); 
          
    UH5 = uicontrol(FH, ...
              'Style', 'pushbutton', 'String', 'Neues Ref.-Bild',...
              'Position', [20 300 100 40],...
              'Callback', @btnGetNewReferenceImage_Click); 
          
    UH6 = uicontrol(FH, ...
              'Style', 'pushbutton', 'String', 'Neustart',...
              'Position', [20 200 100 40],...
              'Callback', @btnRestart_Click);  
          
    UH7 = uicontrol(FH, ...
              'Style', 'pushbutton', 'String', 'Stop',...
              'Position', [20 100 100 40],...
              'Callback', @btnStop_Click); 

    %% Referenzbild aufnehmen

    VH = videoinput('winvideo', 1);    %VideoHandle einmal definiert
    VH.ReturnedColorspace = 'grayscale';
    VH.ROIPosition = ROI;
    
    src = getselectedsource(VH);                        % Manuelle Kameraeinstellungen
    src.ExposureMode = 'manual';
    src.Exposure = -4;
    src.GainMode = 'manual';
    src.Gain = 275;

    % Referenzbild
    imgRef = getsnapshot(VH); 
    imwrite(imgRef, 'imgRef.bmp');

    %% Bilder aufnehmen

    while true
        
        % Bild aufnehmen 
        img = getsnapshot(VH); 
        imwrite(img, 'img2A.bmp');

        %% Berechnung (händisch)

        F     = fft2(imgRef);   %IMG1 Fouriertransformieren
        G     = fft2(img);      %IMG2 Fouriertransformieren
        G_konj= conj(G);        %IMG2 konjugiert komplex nehmen
        I     = F.*G_konj;      %Produkt: IMG1 * IMG2
        K     = ifft2(I);       %Rücktransformieren ??
        
        [imgOffsetY, imgOffsetX] = find(K==max(K(:)), 1, 'first');
        
        if imgOffsetX < Width / 2
            imgOffsetX = -imgOffsetX + 1;
        else
            imgOffsetX = -imgOffsetX + Width + 1;
        end
        
        if imgOffsetY < Height / 2
            imgOffsetY = -imgOffsetY + 1;
        else
            imgOffsetY = -imgOffsetY + Height + 1;
        end
             
        imgAusschnitt   = RefAusschnitt + [imgOffsetX imgOffsetY 0 0];
        
        Koeffizient = NaN;
        
        if abs(imgOffsetX) <= Offset && abs(imgOffsetY) <= Offset
            Koeffizient = corr2(imgRef(RefAusschnitt(2) : RefAusschnitt(2) + RefAusschnitt(4), RefAusschnitt(1) : RefAusschnitt(1) + RefAusschnitt(3)), ...
                                img(imgAusschnitt(2) : imgAusschnitt(2) + imgAusschnitt(4), imgAusschnitt(1) : imgAusschnitt(1) + imgAusschnitt(3)));
        end   
            
        if Koeffizient < 0;
            continue
        end
        
        Daten(end + 1, 1)           = now;
        Koeffizienten(end + 1, 1)   = Koeffizient;
        
        Steigung = diff(Koeffizienten);
        
        % Differenzbild (nur für Anzeige und Kontrolle, wird nicht weiter
        % verwendet)
        
        Differenz = int16(imgRef) - int16(img);
        

        %% Plots
        
        % Preparation
        
        % Plot 1
        AH1 = subplot(2, 3, 1); % ist der Subplot "AH1" in der 2x3 großen MAtrix an Position 1

        cla(AH1)
        hold(AH1, 'on')
        imshow(imgRef); 
        rectangle('Position', RefAusschnitt, 'EdgeColor', [1 0 0]);
        axis (AH1, 'image');
        title(AH1, 'Referenzbild');
        text(0, -0.15, sprintf('aktueller Korrelationskoeffizient: %.5f', Koeffizienten(end, 1)), 'FontSize', 20, 'Units', 'normalized', 'Parent', AH1);
        
        if numel(Steigung) > 0
            text(0, -0.3, sprintf('Steigung des Korrelationskoeffizienten: %.5f', Steigung(end, 1)), 'FontSize', 20, 'Units', 'normalized', 'Parent', AH1);
        end
        
        % Plot 2
        AH2 = subplot(2, 3, 4);

        hold(AH2, 'on')
        imshow(img); 
        rectangle('Position', imgAusschnitt, 'EdgeColor', [1 0 0]);
        axis (AH2, 'image');
        title(AH2, 'aktuelle Aufnahme');
        
        % Plot 3 - Differenz
        AH3 = subplot(2, 3, 2);
        
        imshow((Differenz + 255) ./ 2);
        caxis([0 255])
        axis (AH3, 'image');
        title(AH3, 'Differenzbild');
        
        % Plot 4 - Histogramm
        AH4 = subplot(2, 3, 5);

        imhist(img);

        % Plot 5 - Rücktransformation
        AH5 = subplot(2, 3, 3);

        L   = fftshift(K);    %Shift für Zentrum
        
%         [imgOffsetY2, imgOffsetX2] = find(L==max(L(:)), 1, 'first');
        
        % Setzt Peak auf 0, damit Farbpalette an das Umfeld angepasst wird.
        % g auf Größe des Peaks setzen!
        
%         g=2;
%         for i=-g:1:g
%             for k=-g:1:+g
%                 
%             L(imgOffsetY2+i, imgOffsetX2+k) = 0;
%             end
%             
%         end
%         
%         M=L(imgOffsetY2-50:imgOffsetY2+50, imgOffsetX2-50:imgOffsetX2+50);  %Zeigt Ausschnitt der Rücktransformierten um den PEak an
%         
        cla(AH5)
        hold(AH5, 'on')
        imagesc(log(abs(L/2550)));
        
        plot(imgOffsetX + Width / 2, imgOffsetY + Height / 2, 'xb', 'MarkerSize', 10)
        axis (AH5, 'image');
        title(AH5, 'Rücktransformiert Magnitude');
        
        text(0, -0.15, sprintf('Verschiebung in X-Richtung: %.f', imgOffsetX), 'FontSize', 20, 'Units', 'normalized', 'Parent', AH5);
        text(0, -0.3, sprintf('Verschiebung in Y-Richtung: %.f', imgOffsetY), 'FontSize', 20, 'Units', 'normalized', 'Parent', AH5);
         
        % Plot 6 - Korrelationskoeffizient
        AH6 = subplot(2, 3, 6);

        plot(AH6, Koeffizienten)
        ylabel(AH6, 'Korrelationskoeffizient')
        ylim(AH6, [str2double(get(UH1, 'String')) ...
                   str2double(get(UH2, 'String'))]);

        % Save
        
        dlmwrite(OutputFileName, [m2xdate(Daten, 0) Koeffizienten], 'delimiter', ',', 'precision', 12)
        
        pause(0);  
        
        % Reagiere auf Buttons
        if GetNewReferenceImage    
            imgRef = getsnapshot(VH);   
            GetNewReferenceImage = false;
        end
         
        if Stop || Restart
            break;    
        end
        
    end

    % Bedingung ist erfüllt, wenn Programm zu Ende ohne Abbruch oder Neustart 
    while ~Restart && ~Stop
        drawnow
    end
    
    if Restart
    	Korrelation
    end
    
    close('all')
    
end

function btnPause_Click(UH, ~)
    set(UH, 'Enable', 'off') 
	pause()
    set(UH, 'Enable', 'on') 
end

function btnDebugPause_Click(~, ~)

    dbstop in Korrelation 80
    
end

function btnGetNewReferenceImage_Click(~, ~)

    global GetNewReferenceImage
    GetNewReferenceImage = true;
    
end

function btnRestart_Click(~, ~)

    global Restart;
    Restart = true;
    
end

function btnStop_Click(~, ~)

    global Stop
    Stop = true;
    
end