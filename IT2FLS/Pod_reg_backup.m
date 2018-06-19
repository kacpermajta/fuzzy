function varargout = Pod_reg(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Pod_reg
%   Funkcja sluzy do wywolywania wykresow funkcji przynaleznosci
%   przy zadanej ilosci i konfiguracji regul
%   
%     Argumenty:
%     (I)varargin - argument wejsciowy
%     (O)vargout - argument wyjsciowy
%
%     Funkcja zwraca:
%     varargout
%     jest to nazwa obecnego fis
%     
%     Uzywane funkcje:
%     Przerysuj
%     Przerysuj_linie
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
%     X - wektor wartosci wykresu funkcji przynaleznosci
%     Y - wektor wartosci wykresu funkcji przynaleznosci
%     we1x - wektor pomocniczy
%     we2x - wektor pomocniczy
%     we1y - wektor pomocniczy
%     we1xx,we2xx,wy1xx - jw.
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
%     krL1,krL2,krL3,krP1,krP2,krP3,krD,krG,lin1X,lin1Yg,lin1Yd -
%     wspolrzedne polozenia
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
%     Plik/funkcja mocno powiazana z plikiem Pod_reg.fig - w nim zapisana jest 
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
                   'gui_OpeningFcn', @Pod_reg_OpeningFcn, ...
                   'gui_OutputFcn',  @Pod_reg_OutputFcn, ...
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


% --- Executes just before Pod_reg is made visible.
function Pod_reg_OpeningFcn(hObject, eventdata, handles, varargin)

if isempty(varargin)
    fls = readfis('bez_nazwy');
    handles.nazwa = 'bez_nazwy';
    nazwa = handles.nazwa;
else
    
    nazwa = char(varargin)
    fls = readfis(nazwa);
    handles.nazwa = nazwa;

end

if ~isempty(fls.rule)
 %%%%%%Tworzenie g³ównego AXES 
    
 obPos = get(gcf,'Position');
 obUnits = get(gcf,'Units');
 
    axPos=[0 10 obPos(3)+1.7 obPos(4)-9.3];
    axCol= 0.95*[1 1 1];
    axHndl=axes( ...
        'Box','on', ...
        'Units',obUnits, ...
        'Position',axPos, ...
        'Tag','mainaxes', ...
        'Visible','on', ...
        'Color', axCol );

%%%%%Parametry figure
set(gcf,'Color',[0.73 0.83 0.96]);

 %%%%%Tworzenie wypelnienia glownego AXES
 %%%%%usuwanie wszystkich obecnych AXES
%     axesList=findobj(gcf,'Type','axes');
%     mainAxes=findobj(gcf,'Type','axes','Tag','mainaxes');
%     axesList(find(axesList==mainAxes))=[];
%     delete(axesList);
    
   

 %%%%%Ustawianie podzia³ki x oraz y wykresu
    x = 0:0.25:100;

    %y = 0.25:0.25:101;
    %h = plot(x,zeros(length(x)));
    hold on;
    axesPtch = patch([0 0 100 100],[0 100 100 0],axCol);
    axis off;
    


%%%%%rysowanie po raz pierwszy
    %tworzenie zimennej potrzebnej do pozycjonowania obiektow
    handles.gora = 0;
    handles.dol = 0;
    handles.lewa = 0;
    handles.prawa = 0;
    
    %zapis
    guidata(hObject,handles);
    
    %tworzenie okienek regul i zmiennych
        %ile regul
        IleReg = length(fls.rule);

      
        
        
        
        %ustawienie slidero
        set(handles.wej1_wart,'Min',0,'Max',1);
        set(handles.wej2_wart,'Min',0,'Max',1);
        
        
        %wspolrzedne okienek
        krL1 = 4.5;
        krP1 = 29.5;
        krL2 = 37.5;
        krP2 = 62.5;
        krL3 = 70.5;
        krP3 = 95.5;
        krD = 78;
        krG = 90;
        skok = 15;

        wejCol = 1/255*[238 233 191];
        wyjCol = 1/255*[255 231 186];
        
        
        we1x = x;
        %mid1 = mean(min(we1x),max(we1x));
        we2x = x;
        %mid2 = mean(min(we2x),max(we2x));
        wy1x = x;
        %mid3 = mean(min(wy1x),max(wy1x));
        we1xx = 4.5:0.25:29.5;
        we2xx = 37.5:0.25:62.5;
        wy1xx = 70.5:0.25:95.5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%stworzyc zmienne przenoszace wartosc n odpowiadajaca lin1 i lin2 wywolac
%funkcje obliczajaca i sprawdzic jak znajduje to minimum
%potem narysowac wykres na oknach wyjsc :D
        

        
        
        %%%%%%%%%%%%%%
        
%%
%ZMIENNE ODPOWIEDZIALNE ZA WE I WY
        for i = 1:IleReg
            we1 = fls.rule(i).antecedent(1);
            we2 = fls.rule(i).antecedent(2);
            wy1 = fls.rule(i).consequent(1);
            if (krD-skok*(i-1)) > 0 
                if (krG-skok*(i-1)) < 100 
                    %okna wejsc 1
                    
               patch([krL1 krL1 krP1 krP1],[krD-skok*(i-1) ...
                   krG-skok*(i-1) krG-skok*(i-1) krD-skok*(i-1)],wejCol); 
               %funkcja przynaleznosci - rys
              
               parametr = fls.input(1).mf(we1).params*100;
               typ = fls.input(1).mf(we1).type;

               [dolna,gorna] = feval(typ,we1x,parametr);
               mf_dolna1 = dolna;
               mf_dolna1 = downsample(mf_dolna1,4);
               mf_gorna1 = gorna;
               mf_gorna1 = downsample(mf_gorna1,4);
                dolna = dolna*12+krD-(i-1)*skok;
                dolna = downsample(dolna,4);

                gorna = gorna*12+krD-(i-1)*skok;             
                gorna = downsample(gorna,4);

                %wspolrzedna srodka podpisu funkcji
                
               % text(mid1,nazwa,'FontSize',8);
                [X,Y,Col] = plotmf2(we1xx,dolna,gorna);
                Col = [0.4 0.99 0.8];
                patch(X,Y,Col,'EdgeLighting','gouraud','LineWidth',1);
                hold on;
               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %okna wejsc 2
                patch([krL2 krL2 krP2 krP2],[krD-skok*(i-1) ...
                    krG-skok*(i-1) krG-skok*(i-1) krD-skok*(i-1)],wejCol); 
                              %funkcja przynaleznosci - rys          
                parametr = fls.input(2).mf(we2).params*100;
                typ = fls.input(2).mf(we2).type;
               
                [dolna,gorna] = feval(typ,we2x,parametr);
                mf_dolna2 = dolna;
                mf_dolna2 = downsample(mf_dolna2,4);
                mf_gorna2 = gorna;
                mf_gorna2 = downsample(mf_gorna2,4);
                dolna = dolna*12+krD-(i-1)*skok;
                dolna = downsample(dolna,4);
                
                gorna = gorna*12+krD-(i-1)*skok;             
                gorna = downsample(gorna,4);
                
                %wspolrzedna srodka podpisu funkcji
                
               % text(mid1,nazwa,'FontSize',8);
                [X,Y,Col] = plotmf2(we2xx,dolna,gorna);
                Col = [0.4 0.99 0.8];
                patch(X,Y,Col,'EdgeLighting','gouraud','LineWidth',1);
                hold on;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %okna wyjsc
                patch([krL3 krL3 krP3 krP3],[krD-skok*(i-1) ...
                   krG-skok*(i-1) krG-skok*(i-1) krD-skok*(i-1)],wyjCol); 
               
               %funkcja przynaleznosci - rys          
                parametr = fls.output(1).mf(wy1).params*100;
                typ = fls.output(1).mf(wy1).type;
               
                [dolna,gorna] = feval(typ,wy1x,parametr);
                mf_dolna_wyj = dolna;
                mf_gorna_wyj = gorna;
                dolna = dolna*12+krD-(i-1)*skok;
                dolna = downsample(dolna,4);
                gorna = gorna*12+krD-(i-1)*skok;             
                gorna = downsample(gorna,4);
                %wspolrzedna srodka podpisu funkcji
                
               % text(mid1,nazwa,'FontSize',8);
                [X,Y,Col] = plotmf2(wy1xx,dolna,gorna);
                Col = [0.99 0.5 0.8];
                patch(X,Y,Col,'EdgeLighting','gouraud','LineWidth',1);
                hold on;
               
                lin1Yd = krD-skok*(i-1);
                
     
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %Obliczenia fls2
                        n_lin1x = get(handles.wej1_wart,'Value')*100+1;
                        n_lin2x = get(handles.wej2_wart,'Value')*100+1;
                        %warunki wybierajace odpowiednie pliki obliczajace
                        if strcmp(fls.andMethod,'min')
                        [min_dolna, min_gorna] = min_and(n_lin1x,n_lin2x,mf_dolna1,mf_gorna1,mf_dolna2,mf_gorna2);
                        if min_dolna>min_gorna
                            temp = min_dolna;
                            min_dolna = min_gorna;
                            min_gorna = temp;
                        end
                        [X_ob, Y_ob] = and_plot_bs(wy1x, min_dolna, min_gorna,mf_dolna_wyj,mf_gorna_wyj);

                        x1 =X_ob(50);
                        X_ob = X_ob*0.25+70.5;
                        X_ob = downsample(X_ob,8);
                        x2=X_ob(50);

                        Y_ob = Y_ob*12+krD-(i-1)*skok;
                        Y_ob = downsample(Y_ob,8);
                        
                        patch(X_ob,Y_ob,'b');
                        hold on
                        elseif strcmp(fls.andMethod,'prod')
                        % prod_and(n_lin1x,n_lin2x,mf_dolna,mf_gorna);
                        end
                        
                           %ustawienie pomocniczych handles
                handles.lin1Yd = lin1Yd;
                handles.lin1Yg = 95;
                guidata(hObject,handles);
                
                
                
                end
            end

        end
       
        %rysowanie linii wejœæ
        %wejœcia domyœlnie na srodku
        %1 punkt
        lin1X = mean(we1xx);
        lin1Yg = 95;
        lin1Yd = lin1Yd - 5;
        line1 = line([lin1X lin1X],[lin1Yd lin1Yg],'Color','r');
        lin2X = mean(we2xx);
        lin2 = line([lin2X lin2X],[lin1Yd lin1Yg],'Color','r');

        %wpisanie w okno wartosci wejsc
        lin1X = floor(lin1X - 5)*100/24;
        lin2X = floor(lin2X - 38)*100/24;
        wej_wart = [lin1X lin2X]./100;
        wej_wart = num2str(wej_wart);
        wej_wart = [' [' wej_wart '] '];
        set(handles.wej_ed,'String',wej_wart);
        lin1X = lin1X/100;
        lin2X = lin2X/100;
        set(handles.wej1_wart,'Value',lin1X);
        set(handles.wej2_wart,'Value',lin2X);
        
        Przerysuj(hObject,eventdata,handles);
end
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Pod_reg wait for user response (see UIRESUME)
% uiwait(handles.pod);
function Przerysuj_linie(hObject,eventdata,handles)


handles = guidata(hObject);
nazwa = handles.nazwa;
gora = handles.gora;
dol = handles.dol;
lewa = handles.lewa;
prawa = handles.prawa;

%         krL1 = 4.5;
%         krP1 = 29.5;
%         krL2 = 37.5;
%         krP2 = 62.5;
%         krL3 = 70.5;
%         krP3 = 95.5;
%         krD = 78;
%         krG = 90;
         lin1Yd = handles.lin1Yd;
         lin1Yg = handles.lin1Yg;
         dlin = eventdata;

         %przeskalowanie wspolrzednej x linii 1 
         dlin1 = dlin(1)*25+4.5;

         %przeskalowanie wspolrzednej x linii 2
         dlin2 = dlin(2)*25+37.5;


%rysowanie linii wejœæ
        %wejœcia domyœlnie na srodku
        %1 punkt
        lin1X = dlin1 + prawa - lewa;
        lin1Yg = 95 + gora - dol;
        lin1Yd = lin1Yd - 5 + gora - dol;
        line1 = line([lin1X lin1X],[lin1Yd lin1Yg],'Color','r');
        lin2X = dlin2 + prawa - lewa;
        lin2 = line([lin2X lin2X],[lin1Yd lin1Yg],'Color','r');
        guidata(hObject,handles);
        
        %wpisanie w okno wartosci wejsc

        wej_wart = [dlin(1) dlin(2)];
        wej_wart = num2str(wej_wart);
        wej_wart = [' [' wej_wart '] '];
        set(handles.wej_ed,'String',wej_wart);
         set(handles.wej1_wart,'Value',dlin(1));
         set(handles.wej2_wart,'Value',dlin(2));
        lin1X = lin1X/100;
        lin2X = lin2X/100;

    



function Przerysuj(hObject,eventdata,handles)
handles = guidata(hObject);
nazwa = handles.nazwa;


axCol= 0.95*[1 1 1];
%%%%%Ustawianie podzia³ki x oraz y wykresu
    x = 0:0.25:100;
    hold on;
    

    axesPtch = patch([0 0 100 100],[0 100 100 0],axCol);

    axis off;


%wczytanie danych
fls = readfis(nazwa);
IleReg = length(fls.rule);
gora = handles.gora;
dol = handles.dol;
prawa = handles.prawa;
lewa = handles.lewa;

        %wspolrzedne okienek
%         krL1 = 4.5;
%         krP1 = 29.5;
%         krL2 = 37.5;
%         krP2 = 62.5;
%         krL3 = 70.5;
%         krP3 = 95.5;
%         krD = 78;
%         krG = 90;
%         skok = 14;
        krL1 = 2;
        krP1 = 19;
        krL2 = 20;
        krP2 = 37;
        krL3 = 38;
        krP3 = 55;
        krD = 78;
        krG = 90;
        skok = 14;

        wejCol = 1/255*[230 255 191];
        wyjCol = 1/255*[255 255 186];
        obCol = 1/255*[220 220 255];
        we1x = x;
        %mid1 = mean(min(we1x),max(we1x));
        we2x = x;
        %mid2 = mean(min(we2x),max(we2x));
        wy1x = x;
        %mid3 = mean(min(wy1x),max(wy1x));
        we1xx = krL1+prawa-lewa:0.25:krP1+prawa-lewa;
        we2xx = krL2+prawa-lewa:0.25:krP2+prawa-lewa;
        wy1xx = krL3+prawa-lewa:0.25:krP3+prawa-lewa;

        for i = 1:IleReg
            
            if (krD-5-skok*(i-1)+gora-dol) > 0 
               if (krG+5-skok*(i-1)+gora-dol) < 100 
                   if (krL1-lewa+prawa) > 0
                       if (krP1-lewa+prawa) < 100
                           
 
                        we1 = fls.rule(i).antecedent(1);
                        
                        patch([krL1+prawa-lewa krL1+prawa-lewa ...
                        krP1+prawa-lewa krP1+prawa-lewa], ...
                        [krD-skok*(i-1)+gora-dol krG-skok*(i-1)+gora-dol ...
                        krG-skok*(i-1)+gora-dol krD-skok*(i-1)+gora-dol],wejCol); 
                                   %funkcja przynaleznosci - rys
                                   parametr = fls.input(1).mf(we1).params*100;
                                   typ = fls.input(1).mf(we1).type;

                                   [dolna,gorna] = feval(typ,we1x,parametr);
                                    %wartosci potrzebne do obliczen
                                    mf_dolna1 = dolna;
                                    mf_dolna1 = downsample(mf_dolna1,4);
                                    mf_gorna1 = gorna;
                                    mf_gorna1 = downsample(mf_gorna1,4);
                                    
                                    %rysowanie
                                    dolna = dolna*12+krD-(i-1)*skok+gora-dol;
                                    dolna = downsample(dolna,4);
                                    gorna = gorna*12+krD-(i-1)*skok+gora-dol;             
                                    gorna = downsample(gorna,4);
                                    %wspolrzedna srodka podpisu funkcji

                                   % text(mid1,nazwa,'FontSize',8);
                                    [X,Y,Col] = plotmf2(we1xx,dolna,gorna);
                                    Col = [0.4 0.99 0.8];
                                    patch(X,Y,Col,'EdgeLighting','gouraud','LineWidth',1);
                                    hold on;
                       end
                   end
                    if (krL2-lewa+prawa) > 0
                        if (krP2-lewa+prawa) < 100
                            
                        we2 = fls.rule(i).antecedent(2);
                        
                        patch([krL2+prawa-lewa krL2+prawa-lewa ...
                        krP2+prawa-lewa krP2+prawa-lewa], ...
                        [krD-skok*(i-1)+gora-dol krG-skok*(i-1)+gora-dol ...
                        krG-skok*(i-1)+gora-dol krD-skok*(i-1)+gora-dol],wejCol); 

                              %funkcja przynaleznosci - rys          
                               parametr = fls.input(2).mf(we2).params*100;
                               typ = fls.input(2).mf(we2).type;

                               [dolna,gorna] = feval(typ,we2x,parametr);
                                    
                                    %wartosci potrzebne do obliczen
                                    mf_dolna2 = dolna;
                                    mf_dolna2 = downsample(mf_dolna2,4);
                                    mf_gorna2 = gorna;
                                    mf_gorna2 = downsample(mf_gorna2,4);

                                    
                                    %rysowanie
                                    dolna = dolna*12+krD-(i-1)*skok+gora-dol;
                                    dolna = downsample(dolna,4);
                                    gorna = gorna*12+krD-(i-1)*skok+gora-dol;             
                                    gorna = downsample(gorna,4);
                                %wspolrzedna srodka podpisu funkcji

                               % text(mid1,nazwa,'FontSize',8);
                                [X,Y,Col] = plotmf2(we2xx,dolna,gorna);
                                Col = [0.4 0.99 0.8];
                                patch(X,Y,Col,'EdgeLighting','gouraud','LineWidth',1);
                                hold on;  


                        end
                    end
                    if (krL3-lewa+prawa) > 0
                         if (krP3-lewa+prawa) < 100

                        wy1 = fls.rule(i).consequent(1);
                        
                        patch([krL3+prawa-lewa krL3+prawa-lewa ...
                        krP3+prawa-lewa krP3+prawa-lewa], ...
                        [krD-skok*(i-1)+gora-dol krG-skok*(i-1)+gora-dol ...
                        krG-skok*(i-1)+gora-dol krD-skok*(i-1)+gora-dol],wyjCol); 

                                   %funkcja przynaleznosci - rys          
                                   parametr = fls.output(1).mf(wy1).params*100;
                                   typ = fls.output(1).mf(wy1).type;

                                   [dolna,gorna] = feval(typ,wy1x,parametr);
                                   mf_dolna_wyj = dolna;
                                   mf_gorna_wyj = gorna;
                                    dolna = dolna*12+krD-(i-1)*skok+gora-dol;
                                    dolna = downsample(dolna,4);
                                    gorna = gorna*12+krD-(i-1)*skok+gora-dol;             
                                    gorna = downsample(gorna,4);
                                    %wspolrzedna srodka podpisu funkcji

                                   % text(mid1,nazwa,'FontSize',8);
                                    [X,Y,Col] = plotmf2(wy1xx,dolna,gorna);
                                    Col = [0.99 0.5 0.8];
                                    patch(X,Y,Col,'EdgeLighting','gouraud','LineWidth',1);
                                    hold on;
                                    
                                    
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %Obliczenia fls2
                        n_lin1x = get(handles.wej1_wart,'Value')*100+1;
                        n_lin2x = get(handles.wej2_wart,'Value')*100+1;
                        %warunki wybierajace odpowiednie pliki obliczajace
                        if strcmp(fls.andMethod,'min')
                            [min_dolna, min_gorna] = min_and(n_lin1x,n_lin2x,mf_dolna1,mf_gorna1,mf_dolna2,mf_gorna2);
                                if min_dolna > min_gorna
                                    temp = min_dolna;
                                    min_dolna = min_gorna;
                                    min_gorna = temp;
                                end
                            [X_ob, Y_ob] = and_plot_bs(x, min_dolna, min_gorna,mf_dolna_wyj,mf_gorna_wyj);

                            
                            %wpisanie do macierzy wynikow przed skalowaniem
                            X_ob_mac(i,:) = X_ob;
                            Y_ob_mac(i,:) = Y_ob;
                            
                            X_ob = X_ob*0.25+70.5;
                            X_ob = downsample(X_ob,8) + prawa - lewa;

                            Y_ob = Y_ob*12+krD-(i-1)*skok;
                            Y_ob = downsample(Y_ob,8) + gora - dol;

                            patch(X_ob,Y_ob,'b');
                            hold on
                            

                        elseif strcmp(fls.andMethod,'prod')
                            [prod_dolna, prod_gorna] =   prod_and(n_lin1x,n_lin2x,mf_dolna,mf_gorna);
                                if prod_dolna > prod_gorna
                                        temp = prod_dolna;
                                        prod_dolna = prod_gorna;
                                        prod_gorna = temp;
                                    end
                            [X_ob, Y_ob] = and_plot_bs(x, prod_dolna, prod_gorna,mf_dolna_wyj,mf_gorna_wyj);
                            
                            %wpisanie do macierzy wynikow
                            X_ob_mac(i,:) = X_ob;
                            Y_ob_mac(i,:) = Y_ob;
                            
                            
                            X_ob = X_ob*0.25+70.5;
                            X_ob = downsample(X_ob,8) + prawa - lewa;

                            Y_ob = Y_ob*12+krD-(i-1)*skok;
                            Y_ob = downsample(Y_ob,8) + gora - dol;

                            patch(X_ob,Y_ob,'b');
                            hold on
                            

                            end
                            end
                        end     
                    end
                end
        end
        
          if (krD-5-skok*(i-1)+gora-dol) > 0 
               if (krG+5-skok*(i-1)+gora-dol) < 100 
                   if (krL1-lewa+prawa) > 0
                       if (krP1-lewa+prawa) < 100
                           
                            dlin1 = get(handles.wej1_wart,'Value');
                            dlin2 = get(handles.wej2_wart,'Value');
                            dlin = [dlin1 dlin2];
                            Przerysuj_linie(hObject,dlin,handles);
                            
                        %rysowanie patch'a na dole wynikowego
                        patch([krL1+prawa-lewa krL1+prawa-lewa ...
                                krP3+prawa-lewa krP3+prawa-lewa], ...
                                [krD-skok*(IleReg)+gora-dol krG-skok*(IleReg)+gora-dol ...
                                krG-skok*(IleReg)+gora-dol krD-skok*(IleReg)+gora-dol],obCol);

                            if strcmp(fls.aggMethod,'max')
                                [Xagg_ob, Yagg_ob] = max_agg(X_ob_mac,Y_ob_mac);
                                x_do_wyj = Xagg_ob;
                                y_do_wyj = Yagg_ob;
                                Xagg_ob = Xagg_ob*0.91+4.5;
                                %potrzebne gdy wyniki maja byc w malym
                                %kwadraciku
                                %Xagg_ob = downsample(Xagg_ob,8) + prawa - lewa;
                                Yagg_ob = Yagg_ob*12+krD-(IleReg)*skok;
                                %Yagg_ob = downsample(Yagg_ob,8) + gora - dol;

                                patch(Xagg_ob,Yagg_ob,'b');
                                hold on
                        elseif strcmp(fls.aggMethod,'prod')
                        end


                        
                        %wybor metody defuzzyfikacji
                        %pobranie wart. wyboru  DOEDYCJI
                        %tworzenie danych potrzebnych do defuzzyfikacji
                        
                        z = x_do_wyj(1:length(x_do_wyj)/2);
                        %z = z';
                        
                        y_do_wyj = y_do_wyj';
                        len_y = length(y_do_wyj);
                        %centra (srednia obliczanych wartosci) = w i rozrzut
                        %(spread) = delta
                        for j = 1:length(z)
                            w(1,j) = y_do_wyj(j);
                            w(2,j) = y_do_wyj(floor(len_y/2)+j);
                            
                            
                        end
                        
                        w(2,:) = fliplr(w(2,:));
                        w = mean(w,1);
                        

                        delta = w(1,:)' - y_do_wyj(1:length(z)); 
                        
                        delta = delta';

                        defuzz_met = fls.defuzzMethod;
                        
                        switch defuzz_met
                            case 'centroid'
                            [l_out, r_out] = centroid_tr(z,w,delta);
                            out = mean([l_out r_out]);
                            case 'œrodek sum'
                            [l_out, r_out] = cos_tr(z,w,delta);
                            out = mean([l_out r_out]);
                        end
                           
                         %%%%%Rysowanie wartosci odpowiedzi wyjscia
                         odpCol = [1 1 0.5];
                         line([out+prawa-lewa out+prawa-lewa], [krD-3-skok*(IleReg)+gora-dol krG+1-skok*(IleReg)+gora-dol],'Color',odpCol,'LineWidth',3);
                         %tekstowo wartosc wyjscia
                         set(handles.wyj_wart,'String',num2str(out));
                       end
                   end
               end
          end
       
% --- Outputs from this function are returned to the command line.
function varargout = Pod_reg_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;



function wej_ed_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
nazwa = handles.nazwa;

dlin = get(handles.wej_ed,'String');
dlin = str2double(dlin);
dlin1 = dlin(1);
dlin2 = dlin(2);
set(handles.wej1_wart,'Value',dlin1);
set(handles.wej2_wart,'Value',dlin2);
guidata(hObject,handles);
    Przerysuj(hObject,eventdata,handles);

% --- Executes on key press with focus on wej_ed and none of its controls.
function wej_ed_KeyPressFcn(hObject, eventdata, handles)
 
klaw = get(gcf, 'CurrentKey');
     
if strcmp(klaw,'return')
       cla;
       wej_ed_Callback(hObject, eventdata, handles);

else
    return;
end


% --- Executes during object creation, after setting all properties.
function wej_ed_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in gora_push.
function gora_push_Callback(hObject, eventdata, handles)
    handles = guidata(hObject);    
    handles.gora = handles.gora+5;
    guidata(hObject,handles);
    Przerysuj(hObject,eventdata,handles);


% --- Executes on button press in lewa_push.
function lewa_push_Callback(hObject, eventdata, handles)
    handles = guidata(hObject);    
    handles.lewa = handles.lewa+3;
    guidata(hObject,handles);
    Przerysuj(hObject,eventdata,handles);
    
% --- Executes on button press in dol_push.
function dol_push_Callback(hObject, eventdata, handles)
    handles = guidata(hObject);
    handles.dol = handles.dol+5;
    guidata(hObject,handles);
    Przerysuj(hObject,eventdata,handles);

% --- Executes on button press in prawa_push.
function prawa_push_Callback(hObject, eventdata, handles)
    handles = guidata(hObject);
    handles.prawa = handles.prawa+3;
    guidata(hObject,handles);
    Przerysuj(hObject,eventdata,handles);

% --- Executes on button press in info_push.
function info_push_Callback(hObject, eventdata, handles)


% --- Executes on button press in wyjscie_push.
function wyjscie_push_Callback(hObject, eventdata, handles)
pod_CloseRequestFcn(hObject, eventdata, handles)

% --- Executes on slider movement.
function wej1_wart_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
    cla;
    Przerysuj(hObject,eventdata,handles);


% --- Executes during object creation, after setting all properties.
function wej1_wart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wej1_wart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.4 .4 .9]);
end


% --- Executes on slider movement.
function wej2_wart_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
    cla;
    Przerysuj(hObject,eventdata,handles);


% --- Executes during object creation, after setting all properties.
function wej2_wart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wej2_wart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.3 .9 .9]);
end


% --- Executes when user attempts to close pod.
function pod_CloseRequestFcn(hObject, eventdata, handles)
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
