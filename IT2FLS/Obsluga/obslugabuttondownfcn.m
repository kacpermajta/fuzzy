function obslugabuttondownfcn(akcja)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%obslugabuttondownfcn
%   Funkcja obsluhuje uzycie klawisza
%   
%     Argumenty:
%
%     Funkcja zwraca: typ akcji
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
switch akcja
    case 'baza'
handles = guidata(hObject);
        persistent chkBaza

        if isempty(chkBaza)
            chkBaza = 1;
            pause(0.3); 
            if chkBaza == 1
            set(gcbo,'LineWidth',3 - get(gcbo,'LineWidth'));
            pause(1);
            set(gcbo,'LineWidth',3 - get(gcbo,'LineWidth'));
            chkBaza = [];
        end
        else
            chkBaza = [];
            
            set(gcbo,'LineWidth',3 - get(gcbo,'LineWidth'));
            IT2FLS;
            Baza_regul;
            pause(1);
            set(gcbo,'LineWidth',3 - get(gcbo,'LineWidth'));
            
            
        end

    case 'wejscie'
        persistent chkWej

        if isempty(chkWej)
            chkWej = 1; %pojedyncze klikniecie
            pause(0.3); 
            if chkWej == 1
            set(gcbo,'LineWidth',3 - get(gcbo,'LineWidth'));
            pause(1);
            set(gcbo,'LineWidth',3 - get(gcbo,'LineWidth'));
            chkWej = [];
        end
        else
            chkWej = []; %podwojne klikniecie
            
            set(gcbo,'LineWidth',3 - get(gcbo,'LineWidth'));
            IT2FLS;
            Wej_ed;
            pause(1);
            set(gcbo,'LineWidth',3 - get(gcbo,'LineWidth'));
            
        end
    case 'wyjscie'
        persistent chkWyj

        if isempty(chkWyj)
            chkWyj = 1; %pojedyncze klikniecie
            pause(0.3); 
            if chkWyj == 1
            set(gcbo,'LineWidth',3 - get(gcbo,'LineWidth'));
            pause(1);
            set(gcbo,'LineWidth',3 - get(gcbo,'LineWidth'));
            chkWyj = [];
        end
        else
            chkWyj = []; %podwojne klikniecie
            
            set(gcbo,'LineWidth',3 - get(gcbo,'LineWidth'));
            IT2FLS;
            Wej_ed;
            pause(1);
            set(gcbo,'LineWidth',3 - get(gcbo,'LineWidth'));
        end
    case 'podglad'
                persistent chkPod

        if isempty(chkPod)
            chkPod = 1; %pojedyncze klikniecie
            pause(0.3); 
            if chkPod == 1
            set(gcbo,'LineWidth',3 - get(gcbo,'LineWidth'));
            pause(1);
            set(gcbo,'LineWidth',3 - get(gcbo,'LineWidth'));
            chkWyj = [];
        end
        else
            chkWyj = []; %podwojne klikniecie
            
            set(gcbo,'LineWidth',3 - get(gcbo,'LineWidth'));
            IT2FLS;
            Pod_reg;
            pause(1);
            set(gcbo,'LineWidth',3 - get(gcbo,'LineWidth'));
        end
  %case 'axes'
            %guidata(figure1.wejPtch);
            %set(gcbo,'LineWidth',1);
            %set(gcbo,'LineWidth',1);
            %set(gcbo,'LineWidth',1);
       
end