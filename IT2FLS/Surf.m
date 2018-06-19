function varargout = Surf(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Surf
%   Funkcja sluzy do wywolywania plaszczyzny sterowania typu 2 dla danych
%   zdefiniowanych w oknach powiazanych
%   
%     Argumenty:
%     varargin - nazwa obecnego fis
%
%     Funkcja zwraca:
%     varargout
%     jest to nazwa obecnego fis
%     
%     Uzywane funkcje:
%     IT2FLS
%     centroid_tr
%     cos_tr
%     min_and
%     prod_and
%     max_agg
%     and_plot_bs
%     rysuj
%     + funkcje wbudowane w program Matlab
%
%     Uzywane zmienne:
%     nazwa - nazwa aktualnego fis
%     nowyFls - pomocniczy arg. do utworzenia nowego fis
%     (I)varargin - argument wejsciowy
%     (O)vargout - argument wyjsciowy
%     temp - pomocnicza wartosc 
%     obPos - pozycja GUI
%     obUnits - jednostka rozmiaru okna GUI
%     axPos - pozycja glownego axes (wykresu)
%     axCol - kolor glownego axes
%     axHndl - struktura przechowujaca wartosci konfiguracyjne axes
%     ges_x - gestosc siatki wykresu x
%     ges_y - gestosc siatki wykresu y
%     rang_x - zakres x 
%     rang_y - zakres y
%     rang_z - zakres z
%     skok_x - skok wykresu przy danym ges_x i rang_x
%     skok_y - skok wykresu przy danym ges_y i rang_y
%     grid_x - wektor wartosci w zakresie rang_x i skoku skok_x 
%     grid_y - wektor wartosci w zakresie rang_y i skoku skok_y 
%     wart_z - wektor wartosci w zakresie rang_z i danej ilosci krokow
%     X - macierz wartosci do stworzenia mesha do wykresu 3D
%     Y - macierz wartosci do stworzenia mesha do wykresu 3D
%     we1x - wektor pomocniczy = grid_x
%     we2x - wektor pomocniczy = grid_y
%     we1y - wektor pomocniczy = wart_z
%     out - macierz wartosci wyjsciowych obrazowana na wykresie 3D
%     IleReg - wartosc regul w bazie regul - steruje petla
%     i,j,k - wartosci sterujace petlami
%     we1 - numer wykorzystywanej funkcji przynaleznosci wejscia 1
%     we2 - numer wykorzystywanej funkcji przynaleznosci wejscia 2
%     wy1 - numer wykorzystywanej funkcji przynaleznosci wyjscia 1
%     typ - typ funkcji przynaleznosci
%     parametr - parametry opisujace dana funkcje przynaleznosci
%     dolna - wartosci dolnej funkcji przynaleznosci
%     gorna - wartosci gornej funkcji przynaleznosci
%     min_gorna - minimalne wartosci uzywane w metodzie min dla gornej mf
%     min_dolna - jak wyzej odnoscnie dolnej mf
%     prod_dolna - wartosci iloczynu uzywane w metodzie prod dla dolnej mf
%     prod_gorna - jak wyzej odnosnie gornej mf
%     mf_dolna1, mf_dolna2, mf_dolna_wyj - macierz wartosci dolnych mf dla wy/we
%     mf_gorna1, mf_gorna2, mf_gorna_wyj - macierz wartosci gornych mf dla wy/we
%     z - wektor wejsciowy do funkcji centroid_tr
%     delta - wektor wejsciowy do funkcji centroid_tr
%     w - wektor wejsciowy do funkcji centroid_tr
%     y_do_wyj - wartosci osi rzednych dla wyliczonej funkcji uogolnionej
%     x_do_wyj - wartosci osi odcietych dla wyliczonej funkcji uogolnionej
%     len_y - dlugosc wektora y
%     l_out - wartosc wyjscowa funkcji centroid_tr - lewa
%     r_out - wartosc wyjsciowa funkcji centroid_tr - prawa   
%     fls - zmienna w ktorej zapisany jest aktualny fis
%     klaw - arg. w ktorym zapisywany jest aktualnie wcisniety klawisz
%     plik - nazwa zapisywanego pliku
%     sciezka - sciezka dostepu do arg. plik
%     hObject - aktualny obiekt
%     eventdata - nie uzywane
%     handles - struktura zawierajaca wszystkie obiekty i ich zmienne
%     Wszystkie wywolania (Callback) do listbox, textbox, popup etc.
%     ktore pomimo ze sa zapisane w tym pliku jako osobne funkcje stanowia
%     integralna czesc tej funkcji poprzez plik IT2FLS.fig
%     
%     Uwagi:
%     Plik/funkcja mocno powiazana z plikiem Surf.fig - w nim zapisana jest 
%     konfiguracja graficzna wygladu GUI a takze powiazanie wszystkich funkcji callback
%     z ta funkcja.
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
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Surf_OpeningFcn, ...
                   'gui_OutputFcn',  @Surf_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Surf is made visible.
function Surf_OpeningFcn(hObject, eventdata, handles, varargin)

if isempty(varargin)
    fls = readfis('bez_nazwy');
    handles.nazwa = 'bez_nazwy';
    %nazwa = handles.nazwa;
else
    
    nazwa = char(varargin);
    fls = readfis(nazwa);
    handles.nazwa = nazwa;

end

  %wczytanie z workspace zslice
  zslices_num = evalin('base','zslices');
  %ustalenie czy zslices_str i zslice_slider jest enable
  if zslices_num ~= 0

  else

  end

    handles.zslices = zslices_num;         


handles.output = hObject;

%%%%%Wypisanie w polach - wejscie i wyjscie
if length(fls.input) > 2    
    for i = 1: length(fls.input) 
        wejsciaTxt(i,1) = cellstr(fls.input(i).name);
    end
        set(handles.wejscie_1_wybor,'String',wejsciaTxt);
        set(handles.wejscie_2_wybor,'String',wejsciaTxt);
end   
if length(fls.output) > 1
    for i = 1: length(fls.output) 
        wyjsciaTxt(i,1) = cellstr(fls.output(i).name);
    end
        set(handles.wyjscie_wybor,'String',wyjsciaTxt);
end
   
    set(handles.ges_siat_x,'String','15');
    set(handles.ges_siat_y,'String','15');
    guidata(hObject, handles);
    rysuj(hObject,eventdata,handles);
% Update handles structure



function rysuj(hObject,eventdata,handles)
% Choose default command line output for Surf
handles.output = hObject;
nazwa = handles.nazwa;
fls = readfis(nazwa);
zslices_num = handles.zslices; 
if ~isempty(fls.rule)
 %%%%%%Tworzenie g³ównego AXES 
    
 %obPos = get(gcf,'Position');
 obUnits = get(gcf,'Units');
 
    axPos=[32 13 45 20];
    axCol= 0.95*[1 1 1];
    
    delete(gca);
    axHndl=axes( ...
        'Box','on', ...
        'Units',obUnits, ...
        'Position',axPos, ...
        'Tag','mainaxes', ...
        'Visible','on', ...
        'Color', axCol );
    
        
        IleWejsc = length(fls.input);
        IleWyjsc = length(fls.output);
        KtWejscie1 = get(handles.wejscie_1_wybor,'Value');
        KtWejscie2 = get(handles.wejscie_2_wybor,'Value');    
        KtWyjscie = get(handles.wyjscie_wybor,'Value');
%%%%%Parametry figure
set(gcf,'Color',[0.73 0.83 0.96]);

 %%%%%Tworzenie wypelnienia glownego AXES
 %%%%%usuwanie wszystkich obecnych AXES
%     axesList=findobj(gcf,'Type','axes');
%     mainAxes=findobj(gcf,'Type','axes','Tag','mainaxes');
%     axesList(find(axesList==mainAxes))=[];
%     delete(axesList); 
end
    %wczytanie nazw do okienek
    
    if (IleWejsc == 1) && (IleWyjsc == 1)
        
        set(handles.x_wej_naz,'String',fls.input(1).name);
        %set(handles.y_wej_naz,'String',fls.input(2).name);
        set(handles.z_wyj_naz,'String',fls.output(1).name);
        set(handles.y_wej_naz,'Enable','Off'); 
        %zmienna okreslajaca ktory wykres generujemy
        OpcjaGen = 1;
    
    elseif IleWejsc == 2 && (IleWyjsc == 1)
        set(handles.x_wej_naz,'String',fls.input(1).name);
        set(handles.y_wej_naz,'String',fls.input(2).name);
        set(handles.z_wyj_naz,'String',fls.output(1).name);
        set(handles.y_wej_naz,'Enable','On');
        OpcjaGen = 2;
        elseif IleWejsc > 2 && (IleWyjsc == 1)
        set(handles.x_wej_naz,'String',fls.input(KtWejscie1).name);
        set(handles.y_wej_naz,'String',fls.input(KtWejscie2).name);
        set(handles.z_wyj_naz,'String',fls.output(1).name);
        set(handles.y_wej_naz,'Enable','Off'); 
        OpcjaGen = 3;
        elseif (IleWejsc == 1) && (IleWyjsc == 2)
        
        set(handles.x_wej_naz,'String',fls.input(1).name);
        %set(handles.y_wej_naz,'String',fls.input(2).name);
        set(handles.z_wyj_naz,'String',fls.output(KtWyjscie).name);
        set(handles.y_wej_naz,'Enable','Off'); 
    OpcjaGen = 4;
        elseif IleWejsc == 2 && (IleWyjsc == 2)
        set(handles.x_wej_naz,'String',fls.input(1).name);
        set(handles.y_wej_naz,'String',fls.input(2).name);
        set(handles.z_wyj_naz,'String',fls.output(KtWyjscie).name);
        set(handles.y_wej_naz,'Enable','On');
        OpcjaGen = 5;
        elseif IleWejsc > 2 && (IleWyjsc == 2)
        set(handles.x_wej_naz,'String',fls.input(KtWejscie1).name);
        set(handles.y_wej_naz,'String',fls.input(KtWejscie2).name);
        set(handles.z_wyj_naz,'String',fls.output(KtWyjscie).name);
        set(handles.y_wej_naz,'Enable','Off');
        OpcjaGen = 6;
    end
    
    
    %odczytanie i zapis do ges_siat
    ges_x = get(handles.ges_siat_x,'String');  
    ges_y = get(handles.ges_siat_y,'String');
    set(handles.ges_siat_x,'String',ges_x);
    set(handles.ges_siat_y,'String',ges_y);
    

    if ~isempty(fls.rule)
    %wartosci potrzebne do utworzenia wykresu
    switch OpcjaGen
            case 1 %wyjkres plaski 1we 1wy
                rang_x = fls.input(1).range;
                %rang_y = fls.input(2).range;
                rang_z = fls.output(1).range;
            case 2  
                 rang_x = fls.input(1).range;
                rang_y = fls.input(2).range;
                rang_z = fls.output(1).range;
            case 3
                rang_x = fls.input(KtWejscie1).range;
                rang_y = fls.input(KtWejscie2).range;
                rang_z = fls.output(1).range;
            case 4 %wykres plaski
                rang_x = fls.input(1).range;
                %rang_y = fls.input(2).range;
                rang_z = fls.output(KtWyjscie).range;
            case 5
                rang_x = fls.input(1).range;
                rang_y = fls.input(2).range;
                rang_z = fls.output(KtWyjscie).range;
            case 6
                rang_x = fls.input(KtWejscie1).range;
                rang_y = fls.input(KtWejscie2).range;
                rang_z = fls.output(KtWyjscie).range;
    end
    %obliczanie skoku wykresu
    skok_x = get(handles.ges_siat_x,'String');
    skok_y = get(handles.ges_siat_y,'String');
    skok_x = str2double(skok_x);
    skok_y = str2double(skok_y);
    
    switch OpcjaGen
        case {1,4}
            
    grid_x = linspace(rang_x(1),rang_x(2),skok_x);
    %wart_z = linspace(rang_z(1),rang_z(2));
    grid_y = grid_x;

    
        case {2,3,5,6}
            
            
    grid_x = linspace(rang_x(1),rang_x(2),skok_x);
    grid_y = linspace(rang_y(1),rang_y(2),skok_y);
    wart_z = linspace(rang_z(1),rang_z(2));
    [X,Y] = meshgrid(grid_x,grid_y);
    
    end
    %%%%%%%Obliczenia wartosci wyjsciowych czyli Z
       %wspolrzedne okienek
        
       rang_out = fls.output(KtWyjscie).range;
      
       
        we1x = grid_x;
        %mid1 = mean(min(we1x),max(we1x));
        we2x = grid_y;
        %mid2 = mean(min(we2x),max(we2x));
        %wy1x = grid_x;
        wy1x = grid_x;
        %mid3 = mean(min(wy1x),max(wy1x));
        %prealokacja zmiennej
        out = zeros(length(grid_y),length(grid_x));
        
        IleReg = length(fls.rule);
       
        
        defuzz_met = fls.defuzzMethod;
                        % przystosowane do dodawanych metod defuzyfikacji
        path = which('IT2FLS','-all');
        path_c = char(path);
        path_u = uint8(path_c);
        path_u = path_u(1:end-8);
        path_c = char(path_u);
        cd(path_c);
        %%%przeskanowac folder metody
        lista_metod = ls('Metody');
        lista_metod=cellstr(lista_metod);
         lista_metod = char(lista_metod(3:end));
                                 %%usunac niepotrzebna koncowke _tr.m
                            for i = 1:size(lista_metod)

                                for j = 1:length(lista_metod)
                                   if lista_metod(i,j) == '.'
                                       lista_metod2(i,j-3:end) = ' ';
                                    break;
                                    else
                                       lista_metod2(i,j) = lista_metod(i,j);
                                    end
                                end
                            end
                            lista_metod = cellstr(lista_metod2);       
        %okreslenie metody defuzyfikacji
           for i=1:length(lista_metod)
                if strcmp(cellstr(defuzz_met),lista_metod(i))
%                     defuzz_met_c = fls.defuzzMethod;
%                     defuzz_met_u = uint8(defuzz_met_c);
%                     defuzz_met_u =defuzz_met_u(1:end-2);
%                     defuzz_met_c = char(defuzz_met_u);
%                     point_fcn = str2func(defuzz_met_c);
                                    defuzz_met_c = fls.defuzzMethod;
                                    %defuzz_met_u = uint8(defuzz_met_c)
                                    %defuzz_met_u =defuzz_met_u(1:end)
                                    defuzz_met_c = char([defuzz_met_c '_tr']);
                                    point_fcn = str2func(defuzz_met_c);
                                    %[l_out, r_out] = feval(point_fcn,z,w,delta)
                                   % out = mean([l_out r_out]);                    
                break;
                end
           end  
        
            
           
        for j = 1:length(grid_x)
             for k = 1:length(grid_y)   
                  if zslices_num == 0  
                      
                       for i = 1:IleReg
                     
                            
                                we1 = fls.rule(i).antecedent(KtWejscie1);
                                typ = fls.input(KtWejscie1).mf(we1).type;

                                           %funkcja przynaleznosci - rys
                                           parametr = fls.input(KtWejscie1).mf(we1).params;
                                       [dolna,gorna] = feval(typ,we1x,parametr);
                                            %wartosci potrzebne do obliczen
                                            mf_dolna1(i,:) = dolna;

                                            mf_gorna1(i,:) = gorna;



                                we2 = fls.rule(i).antecedent(KtWejscie2);
                                typ = fls.input(KtWejscie2).mf(we2).type;

                                      %funkcja przynaleznosci - rys          
                                       parametr = fls.input(KtWejscie2).mf(we2).params;
                                       [dolna,gorna] = feval(typ,we2x,parametr);

                                            %wartosci potrzebne do obliczen
                                            mf_dolna2(i,:) = dolna;

                                            mf_gorna2(i,:) = gorna;


                                wy1 = fls.rule(i).consequent(KtWyjscie);
                                typ = fls.output(KtWyjscie).mf(wy1).type;

                                           %funkcja przynaleznosci - rys          
                                           parametr = fls.output(KtWyjscie).mf(wy1).params;

                                           [dolna,gorna] = feval(typ,wy1x,parametr);
                                           mf_dolna_wyj(i,:) = dolna;
                                           mf_gorna_wyj(i,:) = gorna;

                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%POPRAWIONE 
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        %Obliczenia fls2


                                %warunki wybierajace odpowiednie pliki obliczajace
                                if strcmp(fls.andMethod,'min')
                                    [min_dolna(i,:), min_gorna(i,:)] = min_and(j,k,mf_dolna1(i,:),mf_gorna1(i,:),mf_dolna2(i,:),mf_gorna2(i,:));
                                        if min_dolna > min_gorna
                                            temp = min_dolna;
                                            min_dolna = min_gorna;
                                            min_gorna = temp;
                                        end
                                    [X_ob(i,:), Y_ob(i,:)] = and_plot_bs(grid_x, min_dolna(i,:), min_gorna(i,:),mf_dolna_wyj(i,:),mf_gorna_wyj(i,:));


                                    %wpisanie do macierzy wynikow przed skalowaniem




                                elseif strcmp(fls.andMethod,'prod')
                                    [prod_dolna(i,:), prod_gorna(i,:)] =   prod_and(j,k,mf_dolna1(i,:),mf_gorna1(i,:),mf_dolna2(i,:),mf_gorna2(i,:));
                                        if prod_dolna > prod_gorna
                                                temp = prod_dolna;
                                                prod_dolna = prod_gorna;
                                                prod_gorna = temp;
                                        end
                                    [X_ob(i,:), Y_ob(i,:)] = and_plot_bs(grid_x, prod_dolna(i,:), prod_gorna(i,:),mf_dolna_wyj(i,:),mf_gorna_wyj(i,:));



                                end %koniec andmethod == min 
                    end
                            if strcmp(fls.aggMethod,'max')
                                if IleReg == 1
                                    x_do_wyj = X_ob;
                                    y_do_wyj = Y_ob;
                                else
                                    [Xagg_ob, Yagg_ob] = max_agg(X_ob,Y_ob);
                                    x_do_wyj = Xagg_ob;
                                    y_do_wyj = Yagg_ob;
                                end
                            elseif strcmp(fls.aggMethod,'probor')
                                 if IleReg == 1
                                    x_do_wyj = X_ob;
                                    y_do_wyj = Y_ob;
                                else
                                    [Xagg_ob, Yagg_ob] = probor_agg(X_ob,Y_ob);
                                    x_do_wyj = Xagg_ob;
                                    y_do_wyj = Yagg_ob;
                                end
                            end

                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                            %wybor metody defuzzyfikacji
                            %pobranie wart. wyboru  DOEDYCJI
                            %tworzenie danych potrzebnych do defuzzyfikacji

                            %z = x_do_wyj(1:length(x_do_wyj)/2);
                            %z = z';
                            z = linspace(rang_z(1),rang_z(2),length(x_do_wyj)/2);
                            y_do_wyj = y_do_wyj';
                            len_y = length(y_do_wyj);
                            %centra (srednia obliczanych wartosci) = w i rozrzut
                            %(spread) = delta
                            %for l = 1:length(z)
                                w(1,:) = y_do_wyj(1:len_y/2);
                                w(2,:) = y_do_wyj(len_y/2+1:end) ;   
                            %end
                            w(2,:) = fliplr(w(2,:));
                            w = mean(w,1);


                            delta = w(1,:)' - y_do_wyj(1:length(z)); 

                            delta = delta';


                                %okreslenei wartosci

                                        [l_out, r_out] = feval(point_fcn,z,w,delta);

                                    %zapewnienie warunku ze przy niektorych
                                    %danych wartosc out zawsze jest srodkowa
                                    %wartoscia 0.5
                                        if isnan(l_out) || isnan(r_out) 
                                            out(k,j) = mean(rang_out);
                                        else
                                            out(k,j) = mean([l_out r_out]);
                                        end


                               
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ZSLICES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
                        else %else zslices == 0
                           for m = 1:zslices_num
                                for i = 1:IleReg

                                we1 = fls.rule(i).antecedent(KtWejscie1);
                                typ = fls.input(KtWejscie1).mf(we1).type;

                                           %funkcja przynaleznosci - rys
                                           parametr = fls.input(KtWejscie1).mf(we1).params;
                                           [dolnaz,gornaz] = feval(typ,we2x,parametr);
                            %generowanie gornego i dolnego przebiegu
                            %zslices                           
                                             dolna = mean([dolnaz; gornaz],1)+(mean([dolnaz; gornaz],1)-dolnaz)*1/zslices_num*(zslices_num-m);
                                             gorna = mean([dolnaz; gornaz],1)-(gornaz - mean([dolnaz; gornaz],1))*1/zslices_num*(zslices_num-m);
                                            %wartosci potrzebne do obliczen
                                            mf_dolna1(i,:) = dolna;

                                            mf_gorna1(i,:) = gorna;
                                            
                            


                                we2 = fls.rule(i).antecedent(KtWejscie2);
                                typ = fls.input(KtWejscie2).mf(we2).type;

                                      %funkcja przynaleznosci - rys          
                                       parametr = fls.input(KtWejscie2).mf(we2).params;
                                       [dolnaz,gornaz] = feval(typ,we2x,parametr);
                            %generowanie gornego i dolnego przebiegu
                            %zslices                               
                                             dolna = mean([dolnaz; gornaz],1)+(mean([dolnaz; gornaz],1)-dolnaz)*1/zslices_num*(zslices_num-m);
                                             gorna = mean([dolnaz; gornaz],1)-(gornaz - mean([dolnaz; gornaz],1))*1/zslices_num*(zslices_num-m);
                                            %wartosci potrzebne do obliczen
                                            mf_dolna2(i,:) = dolna;

                                            mf_gorna2(i,:) = gorna;
                                            



                                wy1 = fls.rule(i).consequent(KtWyjscie);
                                typ = fls.output(KtWyjscie).mf(wy1).type;

                                           %funkcja przynaleznosci - rys          
                                           parametr = fls.output(KtWyjscie).mf(wy1).params;

                                           [dolna,gorna] = feval(typ,wy1x,parametr);

                            %generowanie gornego i dolnego przebiegu
                            %zslices                               
                                             dolna = mean([dolnaz; gornaz],1)+(mean([dolnaz; gornaz],1)-dolnaz)*1/zslices_num*(zslices_num-m);
                                             gorna = mean([dolnaz; gornaz],1)-(gornaz - mean([dolnaz; gornaz],1))*1/zslices_num*(zslices_num-m);

                                             mf_dolna_wyj(i,:) = dolna;
                                           mf_gorna_wyj(i,:) = gorna;

                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%POPRAWIONE 
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        %Obliczenia fls2


                                %warunki wybierajace odpowiednie pliki obliczajace
                                if strcmp(fls.andMethod,'min')
                                    [min_dolna(i,:), min_gorna(i,:)] = min_and(j,k,mf_dolna1(i,:),mf_gorna1(i,:),mf_dolna2(i,:),mf_gorna2(i,:));
                                        if min_dolna > min_gorna
                                            temp = min_dolna;
                                            min_dolna = min_gorna;
                                            min_gorna = temp;
                                        end
                                    [X_ob(i,:), Y_ob(i,:)] = and_plot_bs(grid_x, min_dolna(i,:), min_gorna(i,:),mf_dolna_wyj(i,:),mf_gorna_wyj(i,:));


                                    %wpisanie do macierzy wynikow przed skalowaniem




                                elseif strcmp(fls.andMethod,'prod')
                                    [prod_dolna(i,:), prod_gorna(i,:)] = prod_and(j,k,mf_dolna1(i,:),mf_gorna1(i,:),mf_dolna2(i,:),mf_gorna2(i,:));
                                        if prod_dolna > prod_gorna
                                                temp = prod_dolna;
                                                prod_dolna = prod_gorna;
                                                prod_gorna = temp;
                                        end
                                    [X_ob(i,:), Y_ob(i,:)] = and_plot_bs(grid_x, min_dolna(i,:), min_gorna(i,:),mf_dolna_wyj(i,:),mf_gorna_wyj(i,:));

                                end
                            
                            
                            end %ilereg
                            



                            if strcmp(fls.aggMethod,'max')
                                if IleReg == 1
                                    x_do_wyj = X_ob;
                                    y_do_wyj = Y_ob;
                                else
                                    [Xagg_ob, Yagg_ob] = max_agg(X_ob,Y_ob);
                                    x_do_wyj = Xagg_ob;
                                    y_do_wyj = Yagg_ob;
                                end
                            elseif strcmp(fls.aggMethod,'prod')
                                 if IleReg == 1
                                    x_do_wyj = X_ob;
                                    y_do_wyj = Y_ob;
                                else
                                    [Xagg_ob, Yagg_ob] = prod_agg(X_ob,Y_ob);
                                    x_do_wyj = Xagg_ob;
                                    y_do_wyj = Yagg_ob;
                                end
                            end

                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                            %wybor metody defuzzyfikacji
                            %pobranie wart. wyboru  DOEDYCJI
                            %tworzenie danych potrzebnych do defuzzyfikacji

                            %z = x_do_wyj(1:length(x_do_wyj)/2);
                            %z = z';
                            z = linspace(rang_z(1),rang_z(2),length(x_do_wyj)/2);

                            y_do_wyj = y_do_wyj';
                            len_y = length(y_do_wyj);
                            %centra (srednia obliczanych wartosci) = w i rozrzut
                            %(spread) = delta
                            %for l = 1:length(z)
                                w(1,:) = y_do_wyj(1:len_y/2);
                                w(2,:) = y_do_wyj(len_y/2+1:end) ; 
                             
                            %end
                            w(2,:) = fliplr(w(2,:));
                            w = mean(w,1);
                   
                            delta = w(1,:)' - y_do_wyj(1:length(z)); 

                            delta = delta';


                                %okreslenei wartosci

                                        [l_out, r_out] = feval(point_fcn,z,w,delta);

                                    %zapewnienie warunku ze przy niektorych
                                    %danych wartosc out zawsze jest srodkowa
                                    %wartoscia 0.5
                                        if isnan(l_out) || isnan(r_out) 
                                            out(k,j,m) = mean(rang_out);
                                        else
                                            if IleWejsc == 4
                                            out(k,j,m) = mean([l_out r_out])/2;
                                            else 
                                                out(k,j,m) = mean([l_out r_out]);
                                            end
                                        end
                    
                        end %koniec zslices == 0
                        %srednia z out w 3 wymiarze - tak jakby
                        %sp³aszczenie macierzy



%                             switch defuzz_met
%                                 case 'centroid'
%                                 [l_out, r_out] = centroid_tr(z,w,delta);
%                                 out(k,j) = mean([l_out r_out]);
%                                 case 'œrodek sum'
%                                 [l_out, r_out] = cos_tr(z,w,delta);
%                                 out(k,j) = mean([l_out r_out]);
%                             end
                       
                  end   
                  
             end
        end
        %dodanie operacji wyliczania ostrego wyjscia dla przypadku uzycia
        %zslices
        if (zslices_num~=0)
                 out = mean(out,3);   
        end 
                 
                 reset(gca);
                 surf(X,Y,out);
                 handles.x_eksport = X;
                 handles.y_eksport = Y;
                 handles.out_eksport = out;

%                  surf(X,Y,out,'FaceColor','interp',...
%                 'EdgeColor','none',...
%                 'FaceLighting','phong');
                 xlabel(fls.input(KtWejscie1).name,'FontSize',12);
                 ylabel(fls.input(KtWejscie2).name,'FontSize',12);
                 
                guidata(hObject, handles);
                handles.output = hObject; 
                rotate3d on
                 %axis equal
             end



% --- Outputs from this function are returned to the command line.
function varargout = Surf_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function ges_siat_x_Callback(hObject, eventdata, handles)
klaw = get(gcf, 'CurrentKey');
     
if strcmp(klaw,'return')
    delete(gca);
         %warunek zeby gestosc byla <3,100>
    ges_x = get(handles.ges_siat_x,'String');
    ges_x = str2num(ges_x);
    if ges_x > 100
        ges_x = 100;    
    elseif ges_x < 3
        ges_x = 3; 
    end
    ges_x = num2str(ges_x);
    set(handles.ges_siat_x,'String',ges_x);
    
       
       rysuj(hObject, eventdata, handles);

else
    return;
end


% --- Executes during object creation, after setting all properties.
function ges_siat_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ges_siat_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ges_siat_y_Callback(hObject, eventdata, handles)
 klaw = get(gcf, 'CurrentKey');
     
if strcmp(klaw,'return')
       delete(gca);

                %warunek zeby gestosc byla <3,100>
    ges_y = get(handles.ges_siat_y,'String');
    ges_y = str2num(ges_y);    
    if ges_y > 100
        ges_y = 100;
    elseif ges_y < 3
        ges_y = 3; 
    end
    ges_y = num2str(ges_y);
    set(handles.ges_siat_y,'String',ges_y);
       
       rysuj(hObject, eventdata, handles);

else
    return;
end


% --- Executes during object creation, after setting all properties.
function ges_siat_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ges_siat_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close pow.
function pow_CloseRequestFcn(hObject, eventdata, handles)
nazwa = handles.nazwa;
fls = readfis(nazwa);
figHandles = findobj('Type','figure');
if numel(figHandles) == 1
    selection = questdlg('Czy chcesz zapisaæ przebieg pracy?','Close Request Function','Tak','Nie','Anuluj','Anuluj');
    nazwa = fls.name;
    switch selection
        case 'Tak'

            fls = readfis(nazwa);
            assignin('base','fls',fls);
            [plik,sciezka] = uiputfile('*.mat','Zapisz jako');

            save(plik,'fls');
    if isequal(plik,0) || isequal(sciezka,0)
       disp('Anulowano')
    else
       disp(['Wybrano ', fullfile(plik, sciezka)])
       delete(gcf);
    end

        case 'Nie'
            delete(gcf);
        case 'Anuluj'
            return;
    end
    
    
else
delete(gcf);
end


% --- Executes on selection change in wejscie_1_wybor.
function wejscie_1_wybor_Callback(hObject, eventdata, handles)
handles.output = hObject;
nazwa = handles.nazwa;
fls = readfis(nazwa);

    rysuj(hObject,eventdata,handles);


% --- Executes during object creation, after setting all properties.
function wejscie_1_wybor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wejscie_1_wybor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in wyjscie_wybor.
function wyjscie_wybor_Callback(hObject, eventdata, handles)
handles.output = hObject;
nazwa = handles.nazwa;
fls = readfis(nazwa);

    rysuj(hObject,eventdata,handles);


% --- Executes during object creation, after setting all properties.
function wyjscie_wybor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wyjscie_wybor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in wejscie_2_wybor.
function wejscie_2_wybor_Callback(hObject, eventdata, handles)
handles.output = hObject;
nazwa = handles.nazwa;
fls = readfis(nazwa);
cla;
    rysuj(hObject,eventdata,handles);


% --- Executes during object creation, after setting all properties.
function wejscie_2_wybor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wejscie_2_wybor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Plik_Callback(hObject, eventdata, handles)
% hObject    handle to Plik (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function do_workspace_Callback(hObject, eventdata, handles)
    %fls = readfis(handles.nazwa);
        handles.output = hObject;
        handles = guidata(gcf); 
%save('fls');
    assignin('base','mesh_X',handles.x_eksport);
    assignin('base','mesh_Y',handles.y_eksport);
    assignin('base','out',handles.out_eksport);
