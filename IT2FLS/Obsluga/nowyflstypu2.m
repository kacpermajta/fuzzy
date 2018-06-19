function wyj=nowyflstypu2(fisName,fisType,andMethod,orMethod,impMethod,aggMethod,defuzzMethod)
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
if (nargin>=1), 
    nazwa=fisName; 
end
if (nargin<2), 
    fisType='mamdani'; 
else, 
    fisType = fisType; 
end
if strcmp(fisType,'mamdani'),
    if (nargin<3), 
        andMethod='min'; 
    end
    if (nargin<4), orMethod='max'; 
    end
    if (nargin<7), defuzzMethod='centroid';
    end
end
%
if (nargin<5), impMethod='min'; 
end
if (nargin<6), aggMethod='max'; 
end
%
if strcmp(fisType,'mamdani'),
    if strcmp(defuzzMethod, 'centroid'),     % Centroid type-reduction
        aggMethod='max';
    elseif strcmp(defuzzMethod, 'csums'),    % Center-of-sums type-reduction
        aggMethod='sum';
    elseif strcmp(defuzzMethod, 'height'),   % Height type-reduction
        aggMethod='sum';
    elseif strcmp(defuzzMethod, 'mdheight'), % Modified height type-reduction
        aggMethod='sum';
    elseif strcmp(defuzzMethod, 'cos'),      % Center-of-sets type-reduction
        aggMethod='sum';
    else
        error('Nieznana redukcja typu!');
    end
elseif strcmp(fisType,'sugeno'),
   
    error('Sugeno w trakcie opracowania');
else
    error('Niezany format FLS!');
end 
%
wyj.name=nazwa;
wyj.type=fisType;
wyj.andMethod=andMethod;
wyj.orMethod=orMethod;
wyj.defuzzMethod=defuzzMethod;
wyj.impMethod=impMethod;
wyj.aggMethod=aggMethod;

wyj.in=[];
wyj.out=[];
wyj.rule=[];
