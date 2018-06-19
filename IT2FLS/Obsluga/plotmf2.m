function [X,Y,Col] = plotmf2(x, dolna, gorna)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plotmf2
%   Funkcja tworzy wektory ktore nalezy uzyc w celu narysowania patch'a
%   funkcji przynaleznosci typu 2
%   
%     Argumenty:
%     x - wektor wartosci x
%     dolna - wektor wartosci dolnej funkcji przynaleznosci
%     gorna - wektor wartosci gornej funkcji przynaleznosci
%
%     Funkcja zwraca:
%     X - funkcja wartosci x po modyfikacjach
%     Y - funkcja wartosci dolna i gorna po przepisaniu w wektor
%     Col - wektor wartosci kolorow
%     
%     Uzywane funkcje:
%     ---
%
%     Uzywane zmienne:
%     ---
%     
%     Uwagi:
%     Brak
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


X = [x fliplr(x)];
Y = [dolna fliplr(gorna)];

Col = [rand(1) rand(1) rand(1)];
end