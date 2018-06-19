function WyjParam = genparammf2mf(WejZak,WejParam,WejTyp,WyjTyp)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%zmianaparammf2mf
%   Funkcja konwertuje funkcjê przynale¿nosci jednego okreslonego typu w
%   funkcje drugiego okreslonego typu przy podanych parametrach funkcji
%   wejsciowej
%   
%     Argumenty:
%     WejParam - wektor parametrow funkcji wejsciowej
%     WejTyp - string okreslajacy typ funkcji wejsciowej
%     WyjTyp - string okreslajacy typ funkcji wyjsciowej
%
%     Funkcja zwraca:
%     WyjParam - wektor parametrow funkcji wyjsciowej
%     
%     Uzywane funkcje:
%     ---
%
%     Uzywane zmienne:
%     a
%     b
%     s
%     d
%     AD
%     SD
%     BD
%     
%     Uwagi:
%     Funkcja wymaga poprawy dzialania niektorych konwersji szczegolnie z
%     gaussmftype2 na wszystkie typu tri...
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
range = WejZak(2) - WejZak(1);
mid = (WejZak(2)+WejZak(1))/2;
if strcmp(WyjTyp,WejTyp)
    WyjParam = WejParam;
elseif strcmp('trisymmftype2',WyjTyp)
    WyjParam = [WejZak(1) mid-(mid-WejZak(1))/2  mid];

elseif strcmp('trimftype2',WyjTyp)
    WyjParam = [WejZak(1) WejZak(1)+range/8 mid+range/8 WejZak(1)+range/4 WejZak(2)-range/8 WejZak(2)]; 
elseif strcmp('tri2mftype2',WyjTyp)
    WyjParam = [WejZak(1) mid WejZak(2) range/10]; 
elseif strcmp('tri3mftype2',WyjTyp)
    WyjParam = [range/8 mid-range/8 range/8 mid+range/8]; 
elseif strcmp('gaussmftype2',WyjTyp)
    WyjParam = [range/8 mid-range/8 range/8 mid+range/8]; 
elseif strcmp('gausssymmftype2',WyjTyp)
    
elseif strcmp('gbellsym1mftype2',WyjTyp) 
     WyjParam = [mid/5 mid*2/5 mid*2/5 mid]; 
elseif strcmp('gbellmftype2',WyjTyp) 
     WyjParam = [abs(WejZak(1))/5 abs(WejZak(1))*2/5 abs(WejZak(1))*2/5 mid];      
elseif strcmp('gbellsym2mftype2',WyjTyp) 

elseif strcmp('gbellsym3mftype2',WyjTyp)
     
elseif strcmp('trapmftype2',WyjTyp) 
     WyjParam = [WejZak(1) WejZak(1)+range/8 WejZak(2)-range/8 WejZak(2) WejZak(1)+range/8 WejZak(1)+range/4 WejZak(2)-range/4 WejZak(2)-range/8]; 
elseif strcmp('zmftype2',WyjTyp) 
     WyjParam = [WejZak(1) mid WejZak(1)+mid/2 1.5*mid]; 
elseif strcmp('smftype2',WyjTyp) 
     WyjParam = [WejZak(1) mid WejZak(1)+mid/2 1.5*mid];     
elseif strcmp('sigmftype2',WyjTyp)
      WyjParam = [WejZak(1) mid WejZak(1)+mid/2 1.5*mid]; 
end
