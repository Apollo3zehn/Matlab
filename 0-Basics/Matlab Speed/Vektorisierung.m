clc
clear

%% Beispiel
display('Vectorizing:');

% Erstelle einen 100000000 x 1 Spaltenvektor mit Zufallszahlen zwischen 0 und
% 5500 kW
Power       = rand(100000000, 1) * 5500;

% Erstelle einen zugehörigen Zeitstempel Vektor (mit unrealistischen Daten)
% und transponiere ihn, damit es auch ein Spaltenvektor ist
DateTimes   = (now : now + 100000000)';

tic

% Entferne Leistungswerte über 5000 kW und setze sie auf NaN (Not a number)
Power(Power > 5000) = NaN;

% Zähle die Anzahl der auf NaN gesetzen Werte
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
% Power > 5000 führt eine binäre Operation aus und gibt keinen skalaren 
% boolschen Wert zurück, sondern einen VEKTOR von boolschen Werten 
% (Stichwort: Vektorisierung). Man sieht, dass die Variable "Indices" 
% nur aus 0 und 1 besteht. Es kommt immer eine 1, wenn die Bedingungen
% Power > 5000 erfüllt ist.
%
% Im nächsten Schritt möchte man alle Wert von "Power" mit NaN's
% überschreiben, die über 5000 kW liegen. Dazu nimmt man den logical Vektor 
% "Indices" und übergibt ihn als Argument an die Variable Power:
Power(Indices) = NaN;

% Diese beiden Schritte gehen auch kürzer mit der ganz oben gezeigten
% Möglichkeit:
Power(Power > 5000) = NaN;

% Wenn man alle Werte über 5000 kW ganz entfernen möchte, ohne sie zu
% überschreiben, so würde das so gehen:
Power = Power(Power <= 5000);
% Das Ergebnis ist ein Vektor der kürzer ist als der Originalvektor, wenn
% es Leistungswerte über 5000 kW gibt.

% Manchmal braucht man aber den logical Vektor, daher ist es gut zu wissen, 
% was die Operation "Power > 5000" für ein Ergebnis liefert. Wenn man 
% nämlich jetzt auch noch den dazugehörigen Zeitstempel filtern möchte, 
% so könnte man folgendes Schreiben:
DateTimes(Indices) = NaN;
% Oder wenn man die Daten löschen möchte:
DateTimes = DateTimes(Power <= 5000);
% Das funktioniert aber nur, wenn der Power Vektor und der DateTimes Vektor
% gleich groß sind, damit auch der resultierende logical Vektor die
% richtige Größe hat. Dies ist ja der Fall, wenn beide zusammen gemessen 
% wurden.Einen Vektor oder eine Matrix über logical zu adressieren nennt 
% sich logische Indizierung und ist eine der Stärken von Matlab.










%% Neuer Abschnitt

% Der falsche Weg ist das gleiche Ziel mit for Schleifen zu erreichen:

display(' ');
display('For loops:');

% Erstelle einen 100000000 x 1 Spaltenvektor mit Zufallszahlen zwischen 0 und
% 5500 kW
Power       = rand(100000000, 1) * 5500;

% Erstelle einen zugehörigen Zeitstempel Vektor (mit unrealistischen Daten)
% und transponiere ihn, damit es auch ein Spaltenvektor ist
DateTimes   = (now : now + 100000000)';

tic

% Entferne Leistungswerte über 5000 kW und setze sie auf NaN (Not a number)
for i = 1 : length(Power)
    if Power(i) > 5000
        Power(i) = NaN; 
    end
end

% Zähle die Anzahl der auf NaN gesetzen Werte
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
% sobald man mit sehr großen Matrizen arbeitet, kann der 
% Geschwindigkeitsvorteil auch mal den Faktor 100 oder mehr erreichen. Ich
% finde die logische Indizierung zusätzlich auch viel übersichtlicher als
% for Schleifen. Die kürzeste Version für das Beispiel, um die Anzahl der
% Werte über 5000 kW zu errechnen wäre wohl:
InvalidValuesCount = sum(Power > 5000);

% sum summiert einfach alle 1 in dem logical Vektor und ist damit eine
% einfache Methode um zu zählen, wieviele Elemente die Bedingung erfüllen.
% Bei Matrizen ist zu beachten, dass Befehle wie sum oder mean zuerst alle
% Spalten berechnen und einen Vektor zurück geben. Das heißt man muss bei
% Matritzen sum und mean doppelt anwenden, um aus dem Vektor einen Skalar
% zu machen, wenn das am Ende gewünscht ist.

