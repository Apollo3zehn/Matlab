clc
clear

%% Beispiel
display('Vectorizing:');

% Erstelle einen 100000000 x 1 Spaltenvektor mit Zufallszahlen zwischen 0 und
% 5500 kW
Power       = rand(100000000, 1) * 5500;

% Erstelle einen zugeh�rigen Zeitstempel Vektor (mit unrealistischen Daten)
% und transponiere ihn, damit es auch ein Spaltenvektor ist
DateTimes   = (now : now + 100000000)';

tic

% Entferne Leistungswerte �ber 5000 kW und setze sie auf NaN (Not a number)
Power(Power > 5000) = NaN;

% Z�hle die Anzahl der auf NaN gesetzen Werte
InvalidValuesCount = sum(isnan(Power));

% Schreibe das Ergebnis in das Command Window
display(sprintf('Number of invalid values: %d', InvalidValuesCount));

toc

%% Beispiel Ende









% Wie funktioniert das Ganze?
% 
% Am Beispiel des folgenden Befehls:
Indices = Power > 5000;
% Das Ergebnis ist ein 100000000 x 1 logical (zu sehen als Workspace 
% Variable "Indices")
% Power > 5000 f�hrt eine bin�re Operation aus und gibt keinen skalaren 
% boolschen Wert zur�ck, sondern einen VEKTOR von boolschen Werten 
% (Stichwort: Vektorisierung). Man sieht, dass die Variable "Indices" 
% nur aus 0 und 1 besteht. Es kommt immer eine 1, wenn die Bedingungen
% Power > 5000 erf�llt ist.
%
% Im n�chsten Schritt m�chte man alle Wert von "Power" mit NaN's
% �berschreiben, die �ber 5000 kW liegen. Dazu nimmt man den logical Vektor 
% "Indices" und �bergibt ihn als Argument an die Variable Power:
Power(Indices) = NaN;

% Diese beiden Schritte gehen auch k�rzer mit der ganz oben gezeigten
% M�glichkeit:
Power(Power > 5000) = NaN;

% Wenn man alle Werte �ber 5000 kW ganz entfernen m�chte, ohne sie zu
% �berschreiben, so w�rde das so gehen:
Power = Power(Power <= 5000);
% Das Ergebnis ist ein Vektor der k�rzer ist als der Originalvektor, wenn
% es Leistungswerte �ber 5000 kW gibt.

% Manchmal braucht man aber den logical Vektor, daher ist es gut zu wissen, 
% was die Operation "Power > 5000" f�r ein Ergebnis liefert. Wenn man 
% n�mlich jetzt auch noch den dazugeh�rigen Zeitstempel filtern m�chte, 
% so k�nnte man folgendes Schreiben:
DateTimes(Indices) = NaN;
% Oder wenn man die Daten l�schen m�chte:
DateTimes = DateTimes(Power <= 5000);
% Das funktioniert aber nur, wenn der Power Vektor und der DateTimes Vektor
% gleich gro� sind, damit auch der resultierende logical Vektor die
% richtige Gr��e hat. Dies ist ja der Fall, wenn beide zusammen gemessen 
% wurden.Einen Vektor oder eine Matrix �ber logical zu adressieren nennt 
% sich logische Indizierung und ist eine der St�rken von Matlab.










%% Neuer Abschnitt

% Der falsche Weg ist das gleiche Ziel mit for Schleifen zu erreichen:

display(' ');
display('For loops:');

% Erstelle einen 100000000 x 1 Spaltenvektor mit Zufallszahlen zwischen 0 und
% 5500 kW
Power       = rand(100000000, 1) * 5500;

% Erstelle einen zugeh�rigen Zeitstempel Vektor (mit unrealistischen Daten)
% und transponiere ihn, damit es auch ein Spaltenvektor ist
DateTimes   = (now : now + 100000000)';

tic

% Entferne Leistungswerte �ber 5000 kW und setze sie auf NaN (Not a number)
for i = 1 : length(Power)
    if Power(i) > 5000
        Power(i) = NaN; 
    end
end

% Z�hle die Anzahl der auf NaN gesetzen Werte
InvalidValuesCount = 0;

for i = 1 : length(Power)
    if isnan(Power(i))
        InvalidValuesCount = InvalidValuesCount + 1;
    end
end

% Schreibe das Ergebnis in das Command Window
display(sprintf('Number of invalid values: %d', InvalidValuesCount));

toc

%% Neuer Abschnitt

% Man sieht eine Zeitdifferenz von einem Faktor ~10 (an meinem Rechner),
% sobald man mit sehr gro�en Matrizen arbeitet, kann der 
% Geschwindigkeitsvorteil auch mal den Faktor 100 oder mehr erreichen. Ich
% finde die logische Indizierung zus�tzlich auch viel �bersichtlicher als
% for Schleifen. Die k�rzeste Version f�r das Beispiel, um die Anzahl der
% Werte �ber 5000 kW zu errechnen w�re wohl:
InvalidValuesCount = sum(Power > 5000);

% sum summiert einfach alle 1 in dem logical Vektor und ist damit eine
% einfache Methode um zu z�hlen, wieviele Elemente die Bedingung erf�llen.
% Bei Matrizen ist zu beachten, dass Befehle wie sum oder mean zuerst alle
% Spalten berechnen und einen Vektor zur�ck geben. Das hei�t man muss bei
% Matritzen sum und mean doppelt anwenden, um aus dem Vektor einen Skalar
% zu machen, wenn das am Ende gew�nscht ist.

