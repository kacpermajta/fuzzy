function [A,B] = swap(A,B)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%swap
%   Funkcja zamienia A z B
%   
%     Argumenty:
%     A- wartosc 1 
%     B - wartosc 2
%
%     Funkcja zwraca:
%     A,B - zamienione wartosci
%     
%     Uzywane funkcje:
%     ---
%
%     Uzywane zmienne:
%     temp
%     
%     Uwagi:
%     brak
%     
%     Autor:
%     Marcin Mik³as
%     rok 5
%     Kierunek: Automatyka i Robotyka
%     specjalnosc: Automatyka i Metrologia
%     Praca magisterska
%     temat: "Implementacja oprogramowania s³u¿¹cego do badan nad regulatorami rozmytymi typu 2 "
%     Promotor:
%     dr inz. Ireneusz Dominik
% 
%     Ostatnia modyfikacja:
%     14.07.2014r.
%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    temp = A;
     A = B;
     B = temp;
    