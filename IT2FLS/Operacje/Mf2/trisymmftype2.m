function [dolna, gorna] = trisymmftype2(x,parametry)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%tri2mftype2
%   Funkcja generuj�ca doln� i gorna funkcje przynaleznosci typu
%   trojkatnego 
%   
%     Argumenty:
%     x - wektor wartosci x
%     parametry -  funkcji przynaleznosci
%
%     Funkcja zwraca:
%     dolna - dolna funkcji przynaleznosci przedzialowych funkcji typu 2
%     gorna - gorna funkcji przynaleznosci przedzialowych funkcji typu 2
%     
%     Uzywane funkcje:
%     ewaluacjamf2
%
%     Uzywane zmienne:
%     dolna 
%     gorna
%     x
%     parametry
%     
%     Uwagi:
%     Funkcja ta powstala w celu latwego wyboru wymaganej do wykreslenia
%     funkcji przynaleznosci typu 2
%     
%     Autor:
%     Marcin Mik�as
%     rok 4
%     specjalnosc: Automatyka i Robotyka
%     Praca in�ynierska
%     temat: "Praktyczna implementacja regulatora rozmytego typu 2 w oprogramowaniu Matlab"
%     Promotor:
%     dr inz. Ireneusz Dominik
% 
%     Ostatnia modyfikacja:
%     03.01.2013r.
%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [dolna, gorna] = ewaluacjamf2(x,parametry,'trisymmftype2');
%     plot(x,dolna,x, gorna);
%     hold on;