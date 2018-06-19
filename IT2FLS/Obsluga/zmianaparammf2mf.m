function WyjParam = zmianaparammf2mf(WejParam,WejTyp,WyjTyp)
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

if strcmp('trisymmftype2',WejTyp)
        a = WejParam(1);
        s = WejParam(2);
        b = WejParam(3);
        d = abs([s-b])-abs([s-a]);
    if strcmp('trisymmftype2',WyjTyp)
        WyjParam = WejParam;
    elseif strcmp('trimftype2',WyjTyp)
        if a > s
            [a,s] = swap(a,s);
        end
        if s < b
            [s,b] = swap(s,b);
        end
        if a > b
            [a,b] = swap(a,b);
        end
            AD = a+d;
            SD = s+d;
            BD = b+d;
        if a+d > s+d
            AD = a+d;
            SD = s+d;
            [AD,SD] = swap(AD,SD);
        end
        if s+d > b+d

            [SD,BD] = swap(SD,BD);
        end
        if a+d > b+d

            [AD,BD] = swap(AD,BD);
        end
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = b;
        WyjParam(4) = AD;
        WyjParam(5) = SD;
        WyjParam(6) = BD;
        
    elseif strcmp('tri2mftype2',WyjTyp)
        if a > s
            [a,s] = swap(a,s);
        end
        if s < b
            [s,b] = swap(s,b);
        end
        if a > b
            [a,b] = swap(a,b);
        end

        WyjParam(1) = a;
        WyjParam(2) = b;
        WyjParam(3) = s;
        WyjParam(4) = d;
    elseif strcmp('tri3mftype2',WyjTyp)
        if a > s
            [a,s] = swap(a,s);
        end
        if s < b
            [s,b] = swap(s,b);
        end
        if a > b
            [a,b] = swap(a,b);
        end
        WyjParam(1) = a;
        WyjParam(2) = b;
        WyjParam(3) = s;
        WyjParam(4) = d;
    elseif strcmp('gaussmftype2',WyjTyp)
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = s-a;
        WyjParam(4) = b-s;
    elseif strcmp('gausssymmftype2',WyjTyp)
        WyjParam(1) = d;
        WyjParam(2) = s-d;
        WyjParam(3) = s+d;
    elseif strcmp('gbellsym1mftype2',WyjTyp) 
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = d;
        WyjParam(4) = (a+b+s)/2;
    elseif strcmp('gbellsym2mftype2',WyjTyp) 
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = d;
        WyjParam(4) = (a+b+s)/2;
    elseif strcmp('gbellsym3mftype2',WyjTyp)
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = d;
        WyjParam(4) = (a+b+s)/2;        
    elseif strcmp('trapmftype2',WyjTyp) 
        WyjParam(1) = s-2*d;
        WyjParam(2) = s-d;
        WyjParam(3) = s+d;
        WyjParam(4) = s+2*d;    
        WyjParam(5) = s-1.5*d;
        WyjParam(6) = s-d;
        WyjParam(7) = s+d;
        WyjParam(8) = s+1.5*d;    
    elseif strcmp('zmftype2',WyjTyp) 
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = s;
        WyjParam(4) = b;        
    elseif strcmp('smftype2',WyjTyp) 
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = s;
        WyjParam(4) = b;           
    elseif strcmp('sigmftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = s;
        WyjParam(4) = b;    
    end
elseif strcmp('trimftype2',WejTyp)
        a1 = WejParam(1);
        s1 = WejParam(2);
        b1 = WejParam(3);
        a2 = WejParam(4);
        s2 = WejParam(5);
        b2 = WejParam(6);
        a = mean([a1,a2]);
        b = mean([b1,b2]);
        s = mean([s1,s2]);
        d = abs(s-b)-abs(s-a);
    if strcmp('trisymmftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = b;
    elseif strcmp('trimftype2',WyjTyp)
        WyjParam = WejParam;
    elseif strcmp('tri2mftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = b;
        WyjParam(3) = s;
        WyjParam(4) = d;
    elseif strcmp('tri3mftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = b;
        WyjParam(3) = s;
        WyjParam(4) = d;
    elseif strcmp('gaussmftype2',WyjTyp)
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = s-a;
        WyjParam(4) = b-s;
    elseif strcmp('gausssymmftype2',WyjTyp)
        WyjParam(1) = d;
        WyjParam(2) = s-d;
        WyjParam(3) = s+d;
    elseif strcmp('gbellsym1mftype2',WyjTyp) 
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = d;
        WyjParam(4) = (a+b+s)/2;
    elseif strcmp('gbellsym2mftype2',WyjTyp) 
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = d;
        WyjParam(4) = (a+b+s)/2;
    elseif strcmp('gbellsym3mftype2',WyjTyp) 
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = d;
        WyjParam(4) = (a+b+s)/2;        
    elseif strcmp('trapmftype2',WyjTyp) 
        WyjParam(1) = s-2*d;
        WyjParam(2) = s-d;
        WyjParam(3) = s+d;
        WyjParam(4) = s+2*d;    
        WyjParam(5) = s-1.5*d;
        WyjParam(6) = s-d;
        WyjParam(7) = s+d;
        WyjParam(8) = s+1.5*d;    
    elseif strcmp('zmftype2',WyjTyp) 
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = s;
        WyjParam(4) = b;        
    elseif strcmp('smftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = s;
        WyjParam(4) = b;           
    elseif strcmp('sigmftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = s;
        WyjParam(4) = b;    
    end
elseif strcmp('tri2mftype2',WejTyp)%%%%%%%%%%%%%
        a = WejParam(1);
        b = WejParam(2);
        s = WejParam(3);
        d = WejParam(4);
    if strcmp('trisymmftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = b;
    elseif strcmp('trimftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = b;
        WyjParam(4) = a+d;
        WyjParam(5) = s+d;
        WyjParam(6) = b+d;
    elseif strcmp('tri2mftype2',WyjTyp)%%%%%%%%%%%%%
        WyjParam = WejParam;
    elseif strcmp('tri3mftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = b;
        WyjParam(3) = s;
        WyjParam(4) = d;
    elseif strcmp('gaussmftype2',WyjTyp)
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = s-a;
        WyjParam(4) = b-s;
    elseif strcmp('gausssymmftype2',WyjTyp)
        WyjParam(1) = d;
        WyjParam(2) = s-d;
        WyjParam(3) = s+d;
    elseif strcmp('gbellsym1mftype2',WyjTyp) 
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = d;
        WyjParam(4) = (a+b+s)/2;
    elseif strcmp('gbellsym2mftype2',WyjTyp) 
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = d;
        WyjParam(4) = (a+b+s)/2;
    elseif strcmp('gbellsym3mftype2',WyjTyp) 
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = d;
        WyjParam(4) = (a+b+s)/2;        
    elseif strcmp('trapmftype2',WyjTyp) 
        WyjParam(1) = s-2*d;
        WyjParam(2) = s-d;
        WyjParam(3) = s+d;
        WyjParam(4) = s+2*d;    
        WyjParam(5) = s-1.5*d;
        WyjParam(6) = s-d;
        WyjParam(7) = s+d;
        WyjParam(8) = s+1.5*d;    
    elseif strcmp('zmftype2',WyjTyp) 
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = s;
        WyjParam(4) = b;        
    elseif strcmp('smftype2',WyjTyp) 
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = s;
        WyjParam(4) = b;           
    elseif strcmp('sigmftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = s;
        WyjParam(4) = b;    
    end
elseif strcmp('tri3mftype2',WejTyp)%%%%%%%%%%%%%
        a = WejParam(1);
        b = WejParam(2);
        s = WejParam(3);
        d = WejParam(4);
    if strcmp('trisymmftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = b;
    elseif strcmp('trimftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = b;
        WyjParam(4) = a+d;
        WyjParam(5) = s+d;
        WyjParam(6) = b+d;
    elseif strcmp('tri2mftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = b;
        WyjParam(3) = s;
        WyjParam(4) = d;
    elseif strcmp('tri3mftype2',WyjTyp)%%%%%%%%%%%%%
        WyjParam = WejParam;
    elseif strcmp('gaussmftype2',WyjTyp)
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = s-a;
        WyjParam(4) = b-s;
    elseif strcmp('gausssymmftype2',WyjTyp)
        WyjParam(1) = d;
        WyjParam(2) = s-d;
        WyjParam(3) = s+d;
    elseif strcmp('gbellsym1mftype2',WyjTyp) 
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = d;
        WyjParam(4) = (a+b+s)/2;
    elseif strcmp('gbellsym2mftype2',WyjTyp) 
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = d;
        WyjParam(4) = (a+b+s)/2;
    elseif strcmp('gbellsym3mftype2',WyjTyp) 
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = d;
        WyjParam(4) = (a+b+s)/2;        
    elseif strcmp('trapmftype2',WyjTyp) 
        WyjParam(1) = s-2*d;
        WyjParam(2) = s-d;
        WyjParam(3) = s+d;
        WyjParam(4) = s+2*d;    
        WyjParam(5) = s-1.5*d;
        WyjParam(6) = s-d;
        WyjParam(7) = s+d;
        WyjParam(8) = s+1.5*d;    
    elseif strcmp('zmftype2',WyjTyp) 
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = s;
        WyjParam(4) = b;        
    elseif strcmp('smftype2',WyjTyp) 
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = s;
        WyjParam(4) = b;           
    elseif strcmp('sigmftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = s;
        WyjParam(4) = b;    
    end
elseif strcmp('gaussmftype2',WejTyp)%%%%%%%%%%%%%
        a = WejParam(1);
        b = WejParam(2);
        s = WejParam(3);
        d = WejParam(4);

    if strcmp('trisymmftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = b;
    elseif strcmp('trimftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = b;
        WyjParam(4) = a+d;
        WyjParam(5) = s+d;
        WyjParam(6) = b+d;
    elseif strcmp('tri2mftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = b;
        WyjParam(3) = s;
        WyjParam(4) = d;
    elseif strcmp('tri3mftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = b;
        WyjParam(3) = s;
        WyjParam(4) = d;
    elseif strcmp('gaussmftype2',WyjTyp)%%%%%%%%%%%%
        WyjParam = WejParam;
    elseif strcmp('gausssymmftype2',WyjTyp)
        WyjParam(1) = d;
        WyjParam(2) = s-d;
        WyjParam(3) = s+d;
    elseif strcmp('gbellsym1mftype2',WyjTyp) 
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = d;
        WyjParam(4) = (a+b+s)/2;
    elseif strcmp('gbellsym2mftype2',WyjTyp) 
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = d;
        WyjParam(4) = (a+b+s)/2;
    elseif strcmp('gbellsym3mftype2',WyjTyp) 
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = d;
        WyjParam(4) = (a+b+s)/2;        
    elseif strcmp('trapmftype2',WyjTyp) 
        WyjParam(1) = s-2*d;
        WyjParam(2) = s-d;
        WyjParam(3) = s+d;
        WyjParam(4) = s+2*d;    
        WyjParam(5) = s-1.5*d;
        WyjParam(6) = s-d;
        WyjParam(7) = s+d;
        WyjParam(8) = s+1.5*d;    
    elseif strcmp('zmftype2',WyjTyp) 
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = s;
        WyjParam(4) = b;        
    elseif strcmp('smftype2',WyjTyp) 
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = s;
        WyjParam(4) = b;           
    elseif strcmp('sigmftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = s;
        WyjParam(4) = b;    
    end
elseif strcmp('gausssymmftype2',WejTyp)%%%%%%%%%%%%%
        a = WejParam(1);
        s = WejParam(2);
        sb = WejParam(3);
        b = abs(sb - s);
        s = sb;
        d = abs(s-b)-abs(s-a);
    if strcmp('trisymmftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = b;
    elseif strcmp('trimftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = b;
        WyjParam(4) = a+d;
        WyjParam(5) = s+d;
        WyjParam(6) = b+d;
    elseif strcmp('tri2mftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = b;
        WyjParam(3) = s;
        WyjParam(4) = d;
    elseif strcmp('tri3mftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = b;
        WyjParam(3) = s;
        WyjParam(4) = d;
    elseif strcmp('gaussmftype2',WyjTyp)
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = s-a;
        WyjParam(4) = b-s;

    elseif strcmp('gausssymmftype2',WyjTyp)%%%%%%%%%%%
        WyjParam = WejParam;
    elseif strcmp('gbellsym1mftype2',WyjTyp) 
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = d;
        WyjParam(4) = (a+b+s)/2;
    elseif strcmp('gbellsym2mftype2',WyjTyp) 
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = d;
        WyjParam(4) = (a+b+s)/2;
    elseif strcmp('gbellsym3mftype2',WyjTyp) 
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = d;
        WyjParam(4) = (a+b+s)/2;        
    elseif strcmp('trapmftype2',WyjTyp) 
        WyjParam(1) = s-2*d;
        WyjParam(2) = s-d;
        WyjParam(3) = s+d;
        WyjParam(4) = s+2*d;    
        WyjParam(5) = s-1.5*d;
        WyjParam(6) = s-d;
        WyjParam(7) = s+d;
        WyjParam(8) = s+1.5*d;    
    elseif strcmp('zmftype2',WyjTyp) 
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = s;
        WyjParam(4) = b;        
    elseif strcmp('smftype2',WyjTyp) 
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = s;
        WyjParam(4) = b;           
    elseif strcmp('sigmftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = s;
        WyjParam(4) = b;    
    end
elseif strcmp('gbellsym1mftype2',WejTyp)%%%%%%%%%%%%%
        a1 = WejParam(1);
        a2 = WejParam(2);
        a = WejParam(3);
        s = WejParam(4);
        d = mean([a1 a2]); 
        b = a + s;
    if strcmp('trisymmftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = b;
    elseif strcmp('trimftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = b;
        WyjParam(4) = a+d;
        WyjParam(5) = s+d;
        WyjParam(6) = b+d;
    elseif strcmp('tri2mftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = b;
        WyjParam(3) = s;
        WyjParam(4) = d;
    elseif strcmp('tri3mftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = b;
        WyjParam(3) = s;
        WyjParam(4) = d;
    elseif strcmp('gaussmftype2',WyjTyp)
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = s-a;
        WyjParam(4) = b-s;
    elseif strcmp('gausssymmftype2',WyjTyp)
        WyjParam(1) = d;
        WyjParam(2) = s-d;
        WyjParam(3) = s+d;
    elseif strcmp('gbellsym1mftype2',WyjTyp) %%%%%%%%
        WyjParam = WejParam;
    elseif strcmp('gbellsym2mftype2',WyjTyp) 
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = d;
        WyjParam(4) = (a+b+s)/2;
    elseif strcmp('gbellsym3mftype2',WyjTyp) 
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = d;
        WyjParam(4) = (a+b+s)/2;        
    elseif strcmp('trapmftype2',WyjTyp) 
        WyjParam(1) = s-2*d;
        WyjParam(2) = s-d;
        WyjParam(3) = s+d;
        WyjParam(4) = s+2*d;    
        WyjParam(5) = s-1.5*d;
        WyjParam(6) = s-d;
        WyjParam(7) = s+d;
        WyjParam(8) = s+1.5*d;    
    elseif strcmp('zmftype2',WyjTyp) 
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = s;
        WyjParam(4) = b;        
    elseif strcmp('smftype2',WyjTyp) 
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = s;
        WyjParam(4) = b;           
    elseif strcmp('sigmftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = s;
        WyjParam(4) = b;    
    end
elseif strcmp('gbellsym2mftype2',WejTyp)%%%%%%%%%%%%%
        a1 = WejParam(1);
        a2 = WejParam(2);
        a = WejParam(3);
        s = WejParam(4);
        d = mean([a1 a2]); 
        b = a + s;
    if strcmp('trisymmftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = b;
    elseif strcmp('trimftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = b;
        WyjParam(4) = a+d;
        WyjParam(5) = s+d;
        WyjParam(6) = b+d;
    elseif strcmp('tri2mftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = b;
        WyjParam(3) = s;
        WyjParam(4) = d;
    elseif strcmp('tri3mftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = b;
        WyjParam(3) = s;
        WyjParam(4) = d;
    elseif strcmp('gaussmftype2',WyjTyp)
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = s-a;
        WyjParam(4) = b-s;
    elseif strcmp('gausssymmftype2',WyjTyp)
        WyjParam(1) = d;
        WyjParam(2) = s-d;
        WyjParam(3) = s+d;
    elseif strcmp('gbellsym1mftype2',WyjTyp)
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = d;
        WyjParam(4) = (a+b+s)/2;
    elseif strcmp('gbellsym2mftype2',WyjTyp) %%%%%%%%
        WyjParam = WejParam;
    elseif strcmp('gbellsym3mftype2',WyjTyp) 
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = d;
        WyjParam(4) = (a+b+s)/2;        
    elseif strcmp('trapmftype2',WyjTyp) 
        WyjParam(1) = s-2*d;
        WyjParam(2) = s-d;
        WyjParam(3) = s+d;
        WyjParam(4) = s+2*d;    
        WyjParam(5) = s-1.5*d;
        WyjParam(6) = s-d;
        WyjParam(7) = s+d;
        WyjParam(8) = s+1.5*d;    
    elseif strcmp('zmftype2',WyjTyp) 
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = s;
        WyjParam(4) = b;        
    elseif strcmp('smftype2',WyjTyp) 
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = s;
        WyjParam(4) = b;           
    elseif strcmp('sigmftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = s;
        WyjParam(4) = b;    
    end
elseif strcmp('gbellsym3mftype2',WejTyp)%%%%%%%%%%%%%
        a1 = WejParam(1);
        a2 = WejParam(2);
        a = WejParam(3);
        s = WejParam(4);
        d = mean([a1 a2]); 
        b = a + s;
    if strcmp('trisymmftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = b;
    elseif strcmp('trimftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = b;
        WyjParam(4) = a+d;
        WyjParam(5) = s+d;
        WyjParam(6) = b+d;
    elseif strcmp('tri2mftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = b;
        WyjParam(3) = s;
        WyjParam(4) = d;
    elseif strcmp('tri3mftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = b;
        WyjParam(3) = s;
        WyjParam(4) = d;
    elseif strcmp('gaussmftype2',WyjTyp)
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = s-a;
        WyjParam(4) = b-s;
    elseif strcmp('gausssymmftype2',WyjTyp)
        WyjParam(1) = d;
        WyjParam(2) = s-d;
        WyjParam(3) = s+d;
    elseif strcmp('gbellsym1mftype2',WyjTyp)
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = d;
        WyjParam(4) = (a+b+s)/2;
    elseif strcmp('gbellsym2mftype2',WyjTyp) 
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = d;
        WyjParam(4) = (a+b+s)/2;
    elseif strcmp('gbellsym3mftype2',WyjTyp) %%%%%%%%
        WyjParam = WejParam;       
    elseif strcmp('trapmftype2',WyjTyp) 
        WyjParam(1) = s-2*d;
        WyjParam(2) = s-d;
        WyjParam(3) = s+d;
        WyjParam(4) = s+2*d;    
        WyjParam(5) = s-1.5*d;
        WyjParam(6) = s-d;
        WyjParam(7) = s+d;
        WyjParam(8) = s+1.5*d;    
    elseif strcmp('zmftype2',WyjTyp) 
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = s;
        WyjParam(4) = b;        
    elseif strcmp('smftype2',WyjTyp) 
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = s;
        WyjParam(4) = b;           
    elseif strcmp('sigmftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = s;
        WyjParam(4) = b;    
    end
elseif strcmp('trapmftype2',WejTyp)%%%%%%%%%%%%%
        a1 = WejParam(1);
        b1 = WejParam(2);
        c1 = WejParam(3);
        d1 = WejParam(4);
        a2 = WejParam(5);
        b2 = WejParam(6);
        c2 = WejParam(7);
        d2 = WejParam(8);
        
        a = mean([a1 a2]);
        b = mean([b1 b2]);
        s = mean([b1 b2 c1 c2]);
        d = abs(b-s);
    if strcmp('trisymmftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = b;
    elseif strcmp('trimftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = b;
        WyjParam(4) = a+d;
        WyjParam(5) = s+d;
        WyjParam(6) = b+d;
    elseif strcmp('tri2mftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = b;
        WyjParam(3) = s;
        WyjParam(4) = d;
    elseif strcmp('tri3mftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = b;
        WyjParam(3) = s;
        WyjParam(4) = d;
    elseif strcmp('gaussmftype2',WyjTyp)
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = s-a;
        WyjParam(4) = b-s;
    elseif strcmp('gausssymmftype2',WyjTyp)
        WyjParam(1) = d;
        WyjParam(2) = s-d;
        WyjParam(3) = s+d;
    elseif strcmp('gbellsym1mftype2',WyjTyp)
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = d;
        WyjParam(4) = (a+b+s)/2;
    elseif strcmp('gbellsym2mftype2',WyjTyp) 
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = d;
        WyjParam(4) = (a+b+s)/2;
    elseif strcmp('gbellsym3mftype2',WyjTyp)
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = d;
        WyjParam(4) = (a+b+s)/2;       
    elseif strcmp('trapmftype2',WyjTyp) %%%%%%%%
        WyjParam = WejParam;    
    elseif strcmp('zmftype2',WyjTyp) 
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = s;
        WyjParam(4) = b;        
    elseif strcmp('smftype2',WyjTyp) 
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = s;
        WyjParam(4) = b;           
    elseif strcmp('sigmftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = s;
        WyjParam(4) = b;    
    end
elseif strcmp('zmftype2',WejTyp) || strcmp('smftype2',WejTyp) || strcmp('sigmftype2',WejTyp)%%%%%%%%%%%%%
        a1 = WejParam(1);
        b1 = WejParam(2);
        a2 = WejParam(3);
        b2 = WejParam(4);

        a = a1;
        b = a2;
        s = mean([b1 a2]);
        d = abs(s-b)-abs(s-a);
    if strcmp('trisymmftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = b;
    elseif strcmp('trimftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = s;
        WyjParam(3) = b;
        WyjParam(4) = a+d;
        WyjParam(5) = s+d;
        WyjParam(6) = b+d;
    elseif strcmp('tri2mftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = b;
        WyjParam(3) = s;
        WyjParam(4) = d;
    elseif strcmp('tri3mftype2',WyjTyp)
        WyjParam(1) = a;
        WyjParam(2) = b;
        WyjParam(3) = s;
        WyjParam(4) = d;
    elseif strcmp('gaussmftype2',WyjTyp)
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = s-a;
        WyjParam(4) = b-s;
    elseif strcmp('gausssymmftype2',WyjTyp)
        WyjParam(1) = d;
        WyjParam(2) = s-d;
        WyjParam(3) = s+d;
    elseif strcmp('gbellsym1mftype2',WyjTyp)
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = d;
        WyjParam(4) = (a+b+s)/2;
    elseif strcmp('gbellsym2mftype2',WyjTyp) 
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = d;
        WyjParam(4) = (a+b+s)/2;
    elseif strcmp('gbellsym3mftype2',WyjTyp)
        WyjParam(1) = s-d;
        WyjParam(2) = s+d;
        WyjParam(3) = d;
        WyjParam(4) = (a+b+s)/2;       
    elseif strcmp('trapmftype2',WyjTyp) 
        WyjParam(1) = s-2*d;
        WyjParam(2) = s-d;
        WyjParam(3) = s+d;
        WyjParam(4) = s+2*d;    
        WyjParam(5) = s-1.5*d;
        WyjParam(6) = s-d;
        WyjParam(7) = s+d;
        WyjParam(8) = s+1.5*d;   
    elseif strcmp('zmftype2',WyjTyp) %%%%%%%%
        WyjParam = WejParam;       
    elseif strcmp('smftype2',WyjTyp) 
        WyjParam = WejParam;          
    elseif strcmp('sigmftype2',WyjTyp)
        WyjParam = WejParam;  
    end
end