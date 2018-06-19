function wyj=dodajmftypu2(fis,typZmiennej,indeksZmiennej,nazwa,typ,parametry)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%nowyflstypu2
%   Funkcja generuje nowy fis. Wszystkie zmienne mog¹ zostac dostosowane. W
%   nie wpisania argumentow oprocz nazwy fis, generowana jest ona z
%   domyslnymi wartosciami argumentów.
%   
%     Argumenty:
%     fisName - nazwa fis
%     fisType - typ fis (tylko mamdami)
%     andMethod - metoda sumowania zbiorow
%     orMethod - metoda iloczynu zbiorow
%     impMethod - metoda implikacji zbioru uogolnionego
%     aggMethod - metoda agregacji zbioru uogolnionego
%     defuzzMethod - sposob defuzyfikacji
%
%     Funkcja zwraca:
%     wyj - strukture bedaca nowym fis
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


numInputs=length(fis.input);
numOutputs=length(fis.output);

wyj=fis;
if ~isempty(fis.input)
  if strcmp(typZmiennej,'input'),   
    indeks=length(fis.input(indeksZmiennej).mf)+1;
    wyj.input(indeksZmiennej).mf(indeks).name=nazwa;
    wyj.input(indeksZmiennej).mf(indeks).type=typ;
    wyj.input(indeksZmiennej).mf(indeks).params=parametry;
    
  elseif strcmp(typZmiennej,'output'),    
    indeks=length(fis.output(indeksZmiennej).mf)+1;  
    wyj.output(indeksZmiennej).mf(indeks).name=nazwa;
    wyj.output(indeksZmiennej).mf(indeks).type=typ;
    wyj.output(indeksZmiennej).mf(indeks).params=parametry;
    
  end
else
 disp('Nie ma wejsc');
end
