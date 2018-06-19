function mf_param = generacjaparametrowtyp2(data,mf_n,mf_type)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%generacjaparametrowtyp2
%   Funkcja tworzy wektor parametrow dla funkcji przynaleznosci danego typu
%   inicjowany podczas ich tworzenia, jako ze domyslna funkcja
%   przynaleznosci jest gaussmftype2 tylko dla niej sa generowane parametry
%   
%     Argumenty:
%     data - zakresy wartosci 
%     mf_n - ilosc funkcji przynaleznosci
%     mf_type - typ funkcji przynaleznosci
%
%     Funkcja zwraca:
%     mf_param - wektor parametrow
%     
%     Uzywane funkcje:
%     ---
%
%     Uzywane zmienne:
%     data_n
%     in_n
%     zak
%     mf_n
%     mf_type
%     i
%     a
%     sa
%     b
%     sb
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

%Funkcja tworzy parametry dla funkcji kiedy sa one generowane po raz
%Poniewaz uzywana jaka pierwsza jest tylko funkcja 


% if length(mf_n) == 1,
%     mf_n = mf_n(ones(1, 1), :);
% end
% for i = 1:mf_n;
%     
%     if strcmp(mf_type, 'gaussmftype2'),
%         a = 0.21*zak(2);
%         sa = zak(1) - 0.08*zak(2)+zak(2)/2*(i-1);
%         b = 0.21*zak(2);
%         sb = zak(1) + 0.08*zak(2)+zak(2)/2*(i-1);
%         mf_param{i,1} = a;
%         mf_param{i,2} = sa;
%         mf_param{i,3} = b;
%         mf_param{i,4} = sb;
%     end
% end


% get dimension info
data_n = size(data,1);
in_n   = size(data,2);
zak  = [min(data)' max(data)'];
% generate mf_n and mf_type of proper sizes
if length(mf_n) == 1,
    mf_n = mf_n(ones(in_n, 1), :);
end
if size(mf_type, 1) == 1, % single mf_type for all IT2MFs
    mf_type = mf_type(ones(in_n, 1), :);
end
% error checking
if length(mf_n) ~= in_n | size(mf_type, 1) ~= in_n,
    error('Wrong sizes of given argument(s)!');
end
%
for i = 1:in_n;

    if strcmp(mf_type, 'gaussmftype2'),
        a = 0.21*zak(2);
        sa = linspace(zak(i,1)-0.08,zak(i,2)-0.08,(mf_n(i)))';
        b = 0.21*zak(2);
        sb = linspace(zak(i,1)+0.08,zak(i,2)+0.08,(mf_n(i)))';
        mf_param{i} = [a(ones(mf_n(i), 1)) sa ...
                       b(ones(mf_n(i), 1)) sb];
    end
end
    %        sa = zak(1) - 0.08*zak(2)+zak(2)/2*(mf_n(i)-1)
%(ones(mf_n(i), 1))
