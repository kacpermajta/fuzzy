function out=dodajzmiennatypu2(fis,varType,varName,varRange)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%dodajzmiennatypu2
%   Dodaje zmienna typu 2 do IT2FIS
%   
%     Argumenty:
%     fis - nazwa fis
%     varType - typ zmiennej (wejscie/wyjscie)
%     varName - nazwa zmiennej
%     varRange - zakres zmiennej
%
%     Funkcja zwraca:
%     out - strukture nowej zmiennej
%     
%     Uzywane funkcje:
%     ---
%
%     Uzywane zmienne:
%     ux
%     uy
%     id
%     da
%     numRules
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

out=fis;
numRules=length(fis.rule);
ux = linspace(varRange(1),varRange(2),50)';
uy = linspace(varRange(1),varRange(2),50)';

da = 0;  % mala inkrementacja do tworzenia parametrow

if strcmp(lower(varType),'input'),
    % Sprawdz czy istnieje pole wejsc
    if isfield(fis,'input')
        index = length(fis.input) + 1;
    else
        index = 1;
    end
    
    if index == 1
        out.input = struct('name',[],...
            'range',[],...
            'mf',[]);
    else
        out.input(index) = struct('name',[],...
            'range',[],...
            'mf',[]);
    end
    
    out.input(index).name =varName;
    out.input(index).range=varRange;
   % index = index;
    
    if nargin == 4 & isempty(out.input(index).mf)  % **
       % Tworzenie domyslnej funkcji wejsciowej IT2FIS
       
       out.input(index).mf = struct('name',cell(1,3),'type','gaussmftype2','params',[]);
       MfParams = generacjaparametrowtyp2(ux,3,'gaussmftype2');
       for id = 1:3

           out.input(index).mf(id).name   = sprintf('mf%i',id);
           out.input(index).mf(id).params = MfParams{1}(id,:);
       end        
    end
    
   % Wstawianie kolumny do listy regul
    if numRules
     
        for i=1:numRules
            out.rule(i).antecedent(index)=0;
        end
    end
    
elseif strcmp(lower(varType),'output'),
    % sprawdzenie isnitnie pola output
    if isfield(fis,'output')
        index = length(fis.output)+1;
    else
        index = 1;
    end
    
    if index == 1
        out.output = struct('name',[],...
            'range',[],...
            'mf',[]);
    else
        out.output(index) = struct('name',[],...
            'range',[],...
            'mf',[]);
    end
    
    out.output(index).name=varName;
    out.output(index).range=varRange;
    
   if nargin == 4 & isempty(out.output(index).mf) 
       if strcmp(fis.type,'mamdani')
           % Tworzenie domyslnej funkcji mamdami
           out.output(index).mf = struct('name',cell(1,3),'type','gaussmftype2','params',[]);
           MfParams = generacjaparametrowtyp2(uy,3,'gaussmftype2');          
           for id = 1:3
            out.output(index).mf(id).name   = sprintf('mf%i',id);
            out.output(index).mf(id).params = MfParams{1}(id,:);
           end
       else 
%           nowa wersja
        out.output(index).mf = struct('name',cell(1),'type','linear','params',[]);
        out.output(index).mf(1).name   = 'mf0';
        out.output(index).mf(1).params = [0 0 0 0 0];
            %fis = addmf(fis,'output',index,'mf0','linear',0);


%            stara wersja
%             out.output(index).mf = struct('name',cell(1,3),'type','constant','params',[]);
%             for id = 1:3
%                out.output(index).mf(id).name   = sprintf('mf%i',id);
%                out.output(index).mf(id).params = [da da]; % **
%                da = da + 0.5;
%             end
       end
   end
   % Wstawianie kolumny do listy regul
    if numRules
           
        for i=1:numRules
            out.rule(i).consequent(index)=0;
        end
    end   
    
end
