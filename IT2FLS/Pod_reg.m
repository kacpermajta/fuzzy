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
%     krL,krL2,krL3,krP,krP2,krP3,krD,krG,lin1X,lin1Yg,lin1Yd -
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
    
    nazwa = char(varargin);
    fls = readfis(nazwa);
    handles.nazwa = nazwa;

end


  %wczytanie z workspace zslice
  zslices_num = evalin('base','zslices');
  %ustalenie czy zslices_str i zslice_slider jest enable
  if zslices_num ~= 0
      set(handles.zslices_str,'Visible','On');
%      set(handles.zslices_val,'Visible','On','String',num2str(get(handles.zslices_slider,'Value')));
      set(handles.zslices_slider,'Min',0,'Max',zslices_num,'Visible','On','Sliderstep',[1/zslices_num 1]); 

  else
      set(handles.zslices_str,'Visible','Off');
      set(handles.zslices_slider,'Visible','Off');
  end

    handles.zslices = zslices_num; 

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
   % x = 0:0.25:100;

    %y = 0.25:0.25:101;
    %h = plot(x,zeros(length(x)));
    hold on;
    axesPtch = patch([0 0 100 100],[0 100 100 0],axCol);
    axis off;
    


%%%%%rysowanie po raz pierwszy

    
    %zapis
    guidata(hObject,handles);
    
    %tworzenie okienek regul i zmiennych
        %ile regul
        IleReg = length(fls.rule);

      
        %ile wejsc
        IleWejsc = length(fls.input);
        


      
        
        %ustawienie disable sliderow i napisow
        if IleWejsc == 1
            set(handles.wej1_wart,'Enable','On');
            set(handles.text_we1,'Enable','On');
            set(handles.wej2_wart,'Enable','Off','Visible','Off');
            set(handles.text_we2,'Enable','Off');           
            set(handles.wej3_wart,'Enable','Off','Visible','Off');
            set(handles.text_we3,'Enable','Off');         
            set(handles.wej4_wart,'Enable','Off','Visible','Off');
            set(handles.text_we4,'Enable','Off'); 
            %ustawienie zakresow sliderow
            zakres1 = fls.input(1).range(1);            
            zakres2 = fls.input(1).range(2);
            slider_step(1) = 0.2/(zakres2-zakres1);
            slider_step(2) = 1/(zakres2-zakres1);
            initial = (zakres1+zakres2)/2;
            set(handles.wej1_wart,'Min',zakres1,'Max',zakres2,'Value',initial,'Sliderstep',slider_step); 
                    
             
        elseif IleWejsc == 2 

            set(handles.wej1_wart,'Enable','On','Visible','On');
            set(handles.text_we1,'Enable','On');
            set(handles.wej2_wart,'Enable','On','Visible','On');
            set(handles.text_we2,'Enable','On');           
            set(handles.wej3_wart,'Enable','Off','Visible','Off');
            set(handles.text_we3,'Enable','Off');         
            set(handles.wej4_wart,'Enable','Off','Visible','Off');
            set(handles.text_we4,'Enable','Off');  
            %ustawienie zakresow sliderow
            zakres1 = fls.input(1).range(1);            
            zakres2 = fls.input(1).range(2);
            slider_step(1) = 0.2/(zakres2-zakres1);
            slider_step(2) = 1/(zakres2-zakres1);
            initial = (zakres1+zakres2)/2;
            set(handles.wej1_wart,'Min',zakres1,'Max',zakres2,'Value',initial,'sliderstep',slider_step); 
            
            zakres1 = fls.input(2).range(1);            
            zakres2 = fls.input(2).range(2);            
            slider_step(1) = 0.2/(zakres2-zakres1);
            slider_step(2) = 1/(zakres2-zakres1);
            initial = (zakres1+zakres2)/2;
            set(handles.wej2_wart,'Min',zakres1,'Max',zakres2,'Value',initial,'sliderstep',slider_step); 
  
      
        elseif IleWejsc == 3
             %ustawienie enable siderow
            set(handles.wej1_wart,'Enable','On','Visible','On');
            set(handles.text_we1,'Enable','On');
            set(handles.wej2_wart,'Enable','On','Visible','On');
            set(handles.text_we2,'Enable','On');           
            set(handles.wej3_wart,'Enable','On','Visible','On');
            set(handles.text_we3,'Enable','On');         
            set(handles.wej4_wart,'Enable','Off','Visible','Off');
            set(handles.text_we4,'Enable','Off'); 
            %ustawienie zakresow sliderow
            zakres1 = fls.input(1).range(1);            
            zakres2 = fls.input(1).range(2);
            slider_step(1) = 0.2/(zakres2-zakres1);
            slider_step(2) = 1/(zakres2-zakres1);
            initial = (zakres1+zakres2)/2;
            set(handles.wej1_wart,'Min',zakres1,'Max',zakres2,'Value',initial,'sliderstep',slider_step); 
            
            zakres1 = fls.input(2).range(1);            
            zakres2 = fls.input(2).range(2);            
            slider_step(1) = 0.4/(zakres2-zakres1);
            slider_step(2) = 1/(zakres2-zakres1);
            initial = (zakres1+zakres2)/2;
            set(handles.wej2_wart,'Min',zakres1,'Max',zakres2,'Value',initial,'sliderstep',slider_step); 
  
            zakres1 = fls.input(3).range(1);            
            zakres2 = fls.input(3).range(2);            
            slider_step(1) = 0.4/(zakres2-zakres1);
            slider_step(2) = 1/(zakres2-zakres1);
            initial = (zakres1+zakres2)/2;
            set(handles.wej3_wart,'Min',zakres1,'Max',zakres2,'Value',initial,'sliderstep',slider_step); 


        else
            %ustawienie enable siderow
            set(handles.wej1_wart,'Enable','On','Visible','On');
            set(handles.text_we1,'Enable','On');
            set(handles.wej2_wart,'Enable','On','Visible','On');
            set(handles.text_we2,'Enable','On');           
            set(handles.wej3_wart,'Enable','On','Visible','On');
            set(handles.text_we3,'Enable','On');         
            set(handles.wej4_wart,'Enable','On','Visible','On');
            set(handles.text_we4,'Enable','On');             
            %ustawienie zakresow sliderow
            zakres1 = fls.input(1).range(1);            
            zakres2 = fls.input(1).range(2);
            slider_step(1) = 0.4/(zakres2-zakres1);
            slider_step(2) = 1/(zakres2-zakres1);
            initial = (zakres1+zakres2)/2;
            set(handles.wej1_wart,'Min',zakres1,'Max',zakres2,'Value',initial,'sliderstep',slider_step); 
            
            zakres1 = fls.input(2).range(1);            
            zakres2 = fls.input(2).range(2);            
            slider_step(1) = 0.4/(zakres2-zakres1);
            slider_step(2) = 1/(zakres2-zakres1);
            initial = (zakres1+zakres2)/2;
            set(handles.wej2_wart,'Min',zakres1,'Max',zakres2,'Value',initial,'sliderstep',slider_step); 
  
            zakres1 = fls.input(3).range(1);            
            zakres2 = fls.input(3).range(2);            
            slider_step(1) = 0.4/(zakres2-zakres1);
            slider_step(2) = 1/(zakres2-zakres1);
            initial = (zakres1+zakres2)/2;
            set(handles.wej3_wart,'Min',zakres1,'Max',zakres2,'Value',initial,'sliderstep',slider_step); 

            zakres1 = fls.input(4).range(1);            
            zakres2 = fls.input(4).range(2);     
            slider_step(1) = 0.4/(zakres2-zakres1);
            slider_step(2) = 1/(zakres2-zakres1);
            initial = (zakres1+zakres2)/2;
            set(handles.wej4_wart,'Min',zakres1,'Max',zakres2,'Value',initial,'sliderstep',slider_step); 

        end
%         %wspolrzedne okienek
%         krL1 = 4.5;
%         krP1 = 29.5;
%         krL2 = 37.5;
%         krP2 = 62.5;
%         krL3 = 70.5;
%         krP3 = 95.5;
%          krD = 78;
%         krG = 90;
%         skok = 15;
% 
%         wejCol = 1/255*[238 233 191];
%         wyjCol = 1/255*[255 231 186];
%         
%         
         %we1x = x;
%         %mid1 = mean(min(we1x),max(we1x));
         %we2x = x;
%         %mid2 = mean(min(we2x),max(we2x));
        % wy1x = x;
%         %mid3 = mean(min(wy1x),max(wy1x));
         %we1xx = 4.5:0.25:29.5;
         %we2xx = 37.5:0.25:62.5;
         %wy1xx = 70.5:0.25:95.5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%stworzyc zmienne przenoszace wartosc n odpowiadajaca lin1 i lin2 wywolac
%funkcje obliczajaca i sprawdzic jak znajduje to minimum
%potem narysowac wykres na oknach wyjsc :D
        

        
        
        %%%%%%%%%%%%%%
        
%%
%ZMIENNE ODPOWIEDZIALNE ZA WE I WY
%         for i = 1:IleReg
%             we1 = fls.rule(i).antecedent(1);
% %            we2 = fls.rule(i).antecedent(2);
%             wy1 = fls.rule(i).consequent(1);
%             if (krD-skok*(i-1)) > 0 
%                 if (krG-skok*(i-1)) < 100 
%                     %okna wejsc 1
%                     
%                patch([krL1 krL1 krP1 krP1],[krD-skok*(i-1) ...
%                    krG-skok*(i-1) krG-skok*(i-1) krD-skok*(i-1)],wejCol); 
%                %funkcja przynaleznosci - rys
%               
%                parametr = fls.input(1).mf(we1).params*100;
%                typ = fls.input(1).mf(we1).type;
% 
%                [dolna,gorna] = feval(typ,we1x,parametr);
%                mf_dolna1 = dolna;
%                mf_dolna1 = downsample(mf_dolna1,4);
%                mf_gorna1 = gorna;
%                mf_gorna1 = downsample(mf_gorna1,4);
%                 dolna = dolna*12+krD-(i-1)*skok;
%                 dolna = downsample(dolna,4);
% 
%                 gorna = gorna*12+krD-(i-1)*skok;             
%                 gorna = downsample(gorna,4);
% 
%                 %wspolrzedna srodka podpisu funkcji
%                 
%                % text(mid1,nazwa,'FontSize',8);
%                 [X,Y,Col] = plotmf2(we1xx,dolna,gorna);
%                 Col = [0.4 0.99 0.8];
%                 patch(X,Y,Col,'EdgeLighting','gouraud','LineWidth',1);
%                 hold on;
%                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     %okna wejsc 2
%                 patch([krL2 krL2 krP2 krP2],[krD-skok*(i-1) ...
%                     krG-skok*(i-1) krG-skok*(i-1) krD-skok*(i-1)],wejCol); 
%                               %funkcja przynaleznosci - rys          
%                 parametr = fls.input(2).mf(we2).params*100;
%                 typ = fls.input(2).mf(we2).type;
%                
%                 [dolna,gorna] = feval(typ,we2x,parametr);
%                 mf_dolna2 = dolna;
%                 mf_dolna2 = downsample(mf_dolna2,4);
%                 mf_gorna2 = gorna;
%                 mf_gorna2 = downsample(mf_gorna2,4);
%                 dolna = dolna*12+krD-(i-1)*skok;
%                 dolna = downsample(dolna,4);
%                 
%                 gorna = gorna*12+krD-(i-1)*skok;             
%                 gorna = downsample(gorna,4);
%                 
%                 %wspolrzedna srodka podpisu funkcji
%                 
%                % text(mid1,nazwa,'FontSize',8);
%                 [X,Y,Col] = plotmf2(we2xx,dolna,gorna);
%                 Col = [0.4 0.99 0.8];
%                 patch(X,Y,Col,'EdgeLighting','gouraud','LineWidth',1);
%                 hold on;
%                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     %okna wyjsc
%                 patch([krL3 krL3 krP3 krP3],[krD-skok*(i-1) ...
%                    krG-skok*(i-1) krG-skok*(i-1) krD-skok*(i-1)],wyjCol); 
%                
%                %funkcja przynaleznosci - rys          
%                 parametr = fls.output(1).mf(wy1).params*100;
%                 typ = fls.output(1).mf(wy1).type;
%                
%                 [dolna,gorna] = feval(typ,wy1x,parametr);
%                 mf_dolna_wyj = dolna;
%                 mf_gorna_wyj = gorna;
%                 dolna = dolna*12+krD-(i-1)*skok;
%                 dolna = downsample(dolna,4);
%                 gorna = gorna*12+krD-(i-1)*skok;             
%                 gorna = downsample(gorna,4);
%                 %wspolrzedna srodka podpisu funkcji
%                 
%                % text(mid1,nazwa,'FontSize',8);
%                 [X,Y,Col] = plotmf2(wy1xx,dolna,gorna);
%                 Col = [0.99 0.5 0.8];
%                 patch(X,Y,Col,'EdgeLighting','gouraud','LineWidth',1);
%                 hold on;
%                
              %   lin1Yd = krD-skok*(i-1);
%                 
%      
%                 
%                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 %Obliczenia fls2
%                         n_lin1x = get(handles.wej1_wart,'Value')*100+1;
%                         n_lin2x = get(handles.wej2_wart,'Value')*100+1;
%                         %warunki wybierajace odpowiednie pliki obliczajace
%                         if strcmp(fls.andMethod,'min')
%                         [min_dolna, min_gorna] = min_and(n_lin1x,n_lin2x,mf_dolna1,mf_gorna1,mf_dolna2,mf_gorna2);
%                         if min_dolna>min_gorna
%                             temp = min_dolna;
%                             min_dolna = min_gorna;
%                             min_gorna = temp;
%                         end
%                         [X_ob, Y_ob] = and_plot_bs(wy1x, min_dolna, min_gorna,mf_dolna_wyj,mf_gorna_wyj);
% 
%                         x1 =X_ob(50);
%                         X_ob = X_ob*0.25+70.5;
%                         X_ob = downsample(X_ob,8);
%                         x2=X_ob();
% 
%                         Y_ob = Y_ob*12+krD-(i-1)*skok;
%                         Y_ob = downsample(Y_ob,8);
%                         
%                         patch(X_ob,Y_ob,'b');
%                         hold on
%                         elseif strcmp(fls.andMethod,'prod')
%                         % prod_and(n_lin1x,n_lin2x,mf_dolna,mf_gorna);
%                         end
%                         
%                            %ustawienie pomocniczych handles
             %    handles.lin1Yd = lin1Yd;
              %   handles.lin1Yg = 95;
                 guidata(hObject,handles);
%                 
%                 
%                 
%                 end
%             end
% 
%         end
%        
        %rysowanie linii wejœæ
        %wejœcia domyœlnie na srodku
        %1 punkt
        % lin1X = mean(we1xx);
         %lin1Yg = 95;

%         line1 = line([lin1X lin1X],[lin1Yd lin1Yg],'Color','r');
        % lin2X = mean(we2xx);
%         lin2 = line([lin2X lin2X],[lin1Yd lin1Yg],'Color','r');
% 
%         %wpisanie w okno wartosci wejsc
         %lin1X = floor(lin1X - 5)*100/24;
         %lin2X = floor(lin2X - 38)*100/24;
         %wej_wart = [lin1X lin2X]./100;
         %wej_wart = num2str(wej_wart);
         %wej_wart = [' [' wej_wart '] '];
         %set(handles.wej_ed,'String',wej_wart);
         %lin1X = lin1X/100;
         %lin2X = lin2X/100;
         %set(handles.wej1_wart,'Value',lin1X);
         %set(handles.wej2_wart,'Value',lin2X);
        
        Przerysuj(hObject,eventdata,handles);
       
end
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Pod_reg wait for user response (see UIRESUME)
% uiwait(handles.pod);
function Przerysuj_linie(hObject,eventdata,handles)

%wczytanie danych
fls = readfis(handles.nazwa);
IleReg = length(fls.rule);
handles = guidata(hObject);
nazwa = handles.nazwa;


 IleWejsc = length(fls.input);
 IleWyjsc = length(fls.output);
 IleOkien = IleWejsc + IleWyjsc;
 IleReg = length(fls.rule);
 
        krL = 2;
        krP = 98;

    skok_x = (100 - (IleOkien+1)*2)/IleOkien;        
    skok_y = (100 - (IleReg+IleWyjsc)*2)/(IleReg+IleWyjsc+1); 

    oknoG = 98;
    oknoWys = 9 + (7-IleReg);
    oknoD = oknoG - oknoWys;
         lin1Yd = handles.lin1Yd;

         dlin = eventdata;
         %gorny punkt linii
         linYg = 100;       
         %przeskalowanie wspolrzednej x linii 1 
         dlin1 = dlin(1)*skok_x+2;
         %wsplrzedna x linii
         lin1X = dlin1;
         
         line1 = line([lin1X lin1X],[lin1Yd linYg],'Color','r');
         wej_wart = [dlin(1)];
         if IleWejsc >= 2
         %przeskalowanie wspolrzednej x linii 2
         dlin2 = dlin(2)*skok_x+4+skok_x;
         
         %wsplrzedna x linii
         lin2X = dlin2;
         line2 = line([lin2X lin2X],[lin1Yd linYg],'Color','r'); 
         wej_wart = [dlin(1) dlin(2)];         
         end
         if IleWejsc >= 3
         dlin3 = dlin(3)*skok_x+2+(skok_x+2)*2;        
         %wsplrzedna x linii
         lin3X = dlin3;
         line3 = line([lin3X lin3X],[lin1Yd linYg],'Color','r');
         wej_wart = [dlin(1) dlin(2) dlin(3)];        
         end
         if IleWejsc >= 4
         dlin4 = dlin(4)*skok_x+2+(skok_x+2)*3;   
         %wsplrzedna x linii
         lin4X = dlin4;
         line2 = line([lin4X lin4X],[lin1Yd linYg],'Color','r');
         wej_wart = [dlin(1) dlin(2) dlin(3) dlin(4)];         
         end
%rysowanie linii wejœæ
        %wejœcia domyœlnie na srodku
        %1 punkt



        guidata(hObject,handles);
        
        %wpisanie w okno wartosci wejsc


        wej_wart = num2str(wej_wart);
        wej_wart = [' [' wej_wart '] '];
        %set(handles.wej_ed,'String',wej_wart);
         %set(handles.wej1_wart,'Value',dlin(1));
         
         %set(handles.wej2_wart,'Value',dlin(2));
 %       lin1X = lin1X/100;
%        lin2X = lin2X/100;


        
        
        
function Przerysuj(hObject,eventdata,handles)
handles = guidata(hObject);
nazwa = handles.nazwa;


axCol= 0.95*[1 1 1];
%%%%%Ustawianie podzia³ki x oraz y wykresu

    hold on;
    

    axesPtch = patch([0 0 100 100],[0 100 100 0],axCol);

    axis off;

%odczyt wartosci zslice z handles
zslices_num = handles.zslices;
zslices_val = get(handles.zslices_slider,'Value'); 





%ustawienie ktory zslice brany pod uwage w oknie ktory_z
if handles.zslices == 0
    set(handles.ktory_z,'Visible','off');
else
        set(handles.ktory_z,'Visible','on');
set(handles.ktory_z,'String',num2str(zslices_val/zslices_num));
end
%wczytanie danych
fls = readfis(nazwa);
IleReg = length(fls.rule);
%ile okien = we + wy
 IleWejsc = length(fls.input);
 IleWyjsc = length(fls.output);
 IleOkien = IleWejsc + IleWyjsc;
 IleReg = length(fls.rule);
 
        krL = 2;
        krP = 98;

    skok_x = (100 - (IleOkien+1)*2)/IleOkien;        
    skok_y = (100 - (IleReg+1)*2)/(IleReg+IleWyjsc+1); 
        wejCol = 1/255*[230 255 191];
        wyjCol = 1/255*[255 255 186];
        obCol = 1/255*[220 220 255];
    oknoG = 98;
    oknoWys = 9+(7-IleReg);
    %18*(100-IleReg)/100
    oknoD = oknoG - oknoWys;
        
 for i = 1:IleWejsc
  
    oknoweL(i) = (skok_x + 2)*(i-1)+krL;
    oknoweP(i) = oknoweL(i) + skok_x;
   
 end

  for i = 1:IleWyjsc
  
    oknowyL(i) = (skok_x + 2)*(i-1+IleWejsc)+krL;
    oknowyP(i) = oknowyL(i) + skok_x;
   
  end
            %podzia³ka wykresu - 101 punktów o kreslonych pozycjach
            we1xx = linspace(oknoweL(1),oknoweP(1),101);
            %zakresy zmiennych dla skalowania wykresow funkcji.    
            zakres1 = fls.input(1).range(1);            
            zakres2 = fls.input(1).range(2);
            %404 liniowo rozlozone punkty.
            we1x = linspace(zakres1*100,zakres2*100,404);
        if IleWejsc >= 2
            we2xx = linspace(oknoweL(2),oknoweP(2),101);
            %zakresy zmiennych dla skalowania wykresow funkcji.    
            zakres1 = fls.input(2).range(1);            
            zakres2 = fls.input(2).range(2);
            %404 liniowo rozlozone punkty.
            %we2x = linspace(zakres1,zakres2,404);
            we2x = linspace(zakres1*100,zakres2*100,404);
        end
        if IleWejsc >= 3
            we3xx = linspace(oknoweL(3),oknoweP(3),101);
            %zakresy zmiennych dla skalowania wykresow funkcji.    
            zakres1 = fls.input(3).range(1);            
            zakres2 = fls.input(3).range(2);
            %404 liniowo rozlozone punkty.
            we3x = linspace(zakres1*100,zakres2*100,404);
        end        
        if IleWejsc >= 4
            we4xx = linspace(oknoweL(4),oknoweP(4),101);
            %zakresy zmiennych dla skalowania wykresow funkcji.    
            zakres1 = fls.input(4).range(1);            
            zakres2 = fls.input(4).range(2);
            %404 liniowo rozlozone punkty.
            we4x = linspace(zakres1*100,zakres2*100,404);
        end
        
            wy1xx = linspace(oknowyL(1),oknowyP(1),101);
            %zakresy zmiennych dla skalowania wykresow funkcji.    
            zakres1 = fls.output(1).range(1);            
            zakres2 = fls.output(1).range(2);
            %404 liniowo rozlozone punkty.
            wy1x = linspace(zakres1*100,zakres2*100,404);   
        if IleWyjsc >= 2
            wy2xx = linspace(oknowyL(2),oknowyP(2),101);
            %zakresy zmiennych dla skalowania wykresow funkcji.    
            zakres1 = fls.output(2).range(1);            
            zakres2 = fls.output(2).range(2);
            %404 liniowo rozlozone punkty.
            wy2x = linspace(zakres1*100,zakres2*100,404);
        end        

   
   %rysowanie regul
        for i = 1:IleReg
            
                         
                         for j = 1:IleWejsc
                             
 
                                we(j) = fls.rule(i).antecedent(j);

                                patch([oknoweL(j) oknoweL(j) ...
                                oknoweP(j) oknoweP(j)], ...
                                [oknoD-skok_y*(i-1) oknoG-skok_y*(i-1) ...
                                oknoG-skok_y*(i-1) oknoD-skok_y*(i-1)],wejCol); 
                                   %funkcja przynaleznosci - rys
                                   
                                   parametr = fls.input(j).mf(we(j)).params*100;
                                   typ = fls.input(j).mf(we(j)).type;
                                   if strcmp(typ,'gbellmftype2')
                                       parametr(3)=parametr(3)/100;
                                   end
                                   
                                   switch j
                                       case 1
                                    [dolnaz,gornaz] = feval(typ,we1x,parametr);
                                    
                                       case 2
                                    [dolnaz,gornaz] = feval(typ,we2x,parametr);  
                                       case 3
                                    [dolnaz,gornaz] = feval(typ,we3x,parametr);
                                       case 4
                                    [dolnaz,gornaz] = feval(typ,we4x,parametr);
                                   end
                                    
                                    if zslices_val == 0 
                                        dolna = dolnaz;
                                        gorna = gornaz;
                                    else
                                        dolna = mean([dolnaz; gornaz],1)+(mean([dolnaz; gornaz],1)-dolnaz)*1/zslices_num*(zslices_num-zslices_val);
                                        gorna = mean([dolnaz; gornaz],1)-(gornaz - mean([dolnaz; gornaz],1))*1/zslices_num*(zslices_num-zslices_val);
                                    end
                                    
                                    %wartosci potrzebne do obliczen
                                    
                                    mf_dolna(:,j) = downsample(dolna,4);
                                    %mf_dolna(:,j) = downsample(mf_dolna(:,j),4);
                                    mf_gorna(:,j) = downsample(gorna,4);
                                   % mf_gorna(:,j) = downsample(mf_gorna(:,j),4);
                                    %+oknoD-
                                    %rysowanie
                                    dolna = dolna*oknoWys+oknoD-(i-1)*skok_y;
                                    dolna = downsample(dolna,4);
                                    gorna = gorna*oknoWys+oknoD-(i-1)*skok_y;             
                                    gorna = downsample(gorna,4);
                                    %wspolrzedna srodka podpisu funkcji

                                   % text(mid1,nazwa,'FontSize',8);
                                   switch j
                                       case 1
                                    [X,Y,Col] = plotmf2(we1xx,dolna,gorna);
                                       case 2
                                    [X,Y,Col] = plotmf2(we2xx,dolna,gorna);  
                                       case 3
                                    [X,Y,Col] = plotmf2(we3xx,dolna,gorna);
                                       case 4
                                    [X,Y,Col] = plotmf2(we4xx,dolna,gorna);
                                   end
                                   
                                    Col = [0.4 0.99 0.8];
                                    patch(X,Y,Col,'EdgeLighting','gouraud','LineWidth',1);
                                    hold on;


 
%                                 we(j) = fls.rule(i).antecedent(j);
% 
%                                 patch([oknoweL(j) oknoweL(j) ...
%                                 oknoweP(j) oknoweP(j)], ...
%                                 [oknoD-skok_y*(i-1) oknoG-skok_y*(i-1) ...
%                                 oknoG-skok_y*(i-1) oknoD-skok_y*(i-1)],wejCol); 
%                                    %funkcja przynaleznosci - rys
%                                    
%                                    parametr = fls.input(j).mf(we(j)).params*100;
%                                    typ = fls.input(j).mf(we(j)).type;
%                                    
%                                    switch j
%                                        case 1
%                                     [dolna,gorna] = feval(typ,we1x,parametr);
%                                        case 2
%                                     [dolna,gorna] = feval(typ,we2x,parametr);  
%                                        case 3
%                                     [dolna,gorna] = feval(typ,we3x,parametr);
%                                        case 4
%                                     [dolna,gorna] = feval(typ,we4x,parametr);
%                                    end
%                                     
%                                     %wartosci potrzebne do obliczen
%                                     mf_dolna(:,j) = dolna;
%                                     %mf_dolna(:,j) = downsample(mf_dolna(:,j),4);
%                                     mf_gorna(:,j) = gorna;
%                                    % mf_gorna(:,j) = downsample(mf_gorna(:,j),4);
%                                     %+oknoD-
%                                     %rysowanie
%                                     dolna = dolna*oknoWys+oknoD-(i-1)*skok_y;
%                                     %dolna = downsample(dolna,4);
%                                     gorna = gorna*oknoWys+oknoD-(i-1)*skok_y;             
%                                     %gorna = downsample(gorna,4);
%                                     %wspolrzedna srodka podpisu funkcji
% 
%                                    % text(mid1,nazwa,'FontSize',8);
%                                    switch j
%                                        case 1
%                                     [X,Y,Col] = plotmf2(we1x,dolna,gorna);
%                                        case 2
%                                     [X,Y,Col] = plotmf2(we2x,dolna,gorna);  
%                                        case 3
%                                     [X,Y,Col] = plotmf2(we3x,dolna,gorna);
%                                        case 4
%                                     [X,Y,Col] = plotmf2(we4x,dolna,gorna);
%                                    end
%                                    
%                                     Col = [0.4 0.99 0.8];
%                                     patch(X,Y,Col,'EdgeLighting','gouraud','LineWidth',1);
%                                     hold on;
                         end
                         

                         
                         for j = 1:IleWyjsc
                       
                          wy(j) = fls.rule(i).consequent(j);
                        
                                    patch([oknowyL(j) oknowyL(j) ...
                                    oknowyP(j) oknowyP(j)], ...
                                    [oknoD-skok_y*(i-1) oknoG-skok_y*(i-1) ...
                                    oknoG-skok_y*(i-1) oknoD-skok_y*(i-1)],wyjCol); 

                                   %funkcja przynaleznosci - rys          
                                   parametr = fls.output(j).mf(wy(j)).params*100;
                                   typ = fls.output(j).mf(wy(j)).type;
                                   if strcmp(typ,'gbellmftype2')
                                       parametr(3)=parametr(3)/100;
                                   end
                                   
                                   switch j
                                       case 1
                                   [dolnaz,gornaz] = feval(typ,wy1x,parametr);
                                   if zslices_val == 0 
                                        dolna = dolnaz;
                                        gorna = gornaz;
                                   else
                                        dolna = mean([dolnaz; gornaz],1)+(mean([dolnaz; gornaz],1)-dolnaz)*1/zslices_num*(zslices_num-zslices_val);
                                        gorna = mean([dolnaz; gornaz],1)-(gornaz - mean([dolnaz; gornaz],1))*1/zslices_num*(zslices_num-zslices_val);
                                   end                                   
                                   mf_dolna_wyj(1,:) = dolna;
                                   mf_gorna_wyj(1,:) = gorna;
                                       case 2                                          
                                   [dolnaz,gornaz] = feval(typ,wy2x,parametr);
                                   if zslices_val == 0 
                                        dolna = dolnaz;
                                        gorna = gornaz;
                                   else
                                        dolna = mean([dolnaz; gornaz],1)+(mean([dolnaz; gornaz],1)-dolnaz)*1/zslices_num*(zslices_num-zslices_val);
                                        gorna = mean([dolnaz; gornaz],1)-(gornaz - mean([dolnaz; gornaz],1))*1/zslices_num*(zslices_num-zslices_val);
                                   end                                   
                                   mf_dolna_wyj(2,:) = dolna;
                                   mf_gorna_wyj(2,:) = gorna;                                   
                                   end
                                   

                                  %% mf_dolna_wyj = dolna;
                                  %% mf_gorna_wyj = gorna;
                                    dolna = dolna*oknoWys+oknoD-(i-1)*skok_y;
                                    dolna = downsample(dolna,4);
                                    gorna = gorna*oknoWys+oknoD-(i-1)*skok_y;             
                                    gorna = downsample(gorna,4);
                                    %wspolrzedna srodka podpisu funkcji

                                   % text(mid1,nazwa,'FontSize',8);
                                    switch j
                                       case 1
                                    [X,Y,Col] = plotmf2(wy1xx,dolna,gorna);
                                       case 2
                                    [X,Y,Col] = plotmf2(wy2xx,dolna,gorna);  

                                   end
                                   % [X,Y,Col] = plotmf2(wy1xx,dolna,gorna);
                                    Col = [0.99 0.5 0.8];
                                    patch(X,Y,Col,'EdgeLighting','gouraud','LineWidth',1);
                                    hold on;
                
                         end  
                                           
                                 
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                  Obliczenia fls2
                  %pobieranie wartosci z zadajnika slider i przeskalowanie
                  %jej na zakres 1-101
                  if IleWejsc == 1
                      
                        n_lin1x = get(handles.wej1_wart,'Value')*100+1;
                        n_lin1x = (n_lin1x-fls.input(1).range(1)*100)/(fls.input(1).range(2)-fls.input(1).range(1));
  
                  elseif IleWejsc == 2
                      
                        n_lin1x = get(handles.wej1_wart,'Value')*100+1;
                        n_lin1x = (n_lin1x-fls.input(1).range(1)*100)/(fls.input(1).range(2)-fls.input(1).range(1));
                        
                        n_lin2x = get(handles.wej2_wart,'Value')*100+1;
                        n_lin2x = (n_lin2x-fls.input(2).range(1)*100)/(fls.input(2).range(2)-fls.input(2).range(1));                      
                  elseif IleWejsc == 3
                      
                        n_lin1x = get(handles.wej1_wart,'Value')*100+1;
                        n_lin1x = (n_lin1x-fls.input(1).range(1)*100)/(fls.input(1).range(2)-fls.input(1).range(1));
                        
                        n_lin2x = get(handles.wej2_wart,'Value')*100+1;
                        n_lin2x = (n_lin2x-fls.input(2).range(1)*100)/(fls.input(2).range(2)-fls.input(2).range(1));
                        
                        n_lin3x = get(handles.wej3_wart,'Value')*100+1;
                        n_lin3x = (n_lin3x-fls.input(3).range(1)*100)/(fls.input(3).range(2)-fls.input(3).range(1));
                  elseif IleWejsc == 4
                        n_lin1x = get(handles.wej1_wart,'Value')*100+1;
                        n_lin1x = (n_lin1x-fls.input(1).range(1)*100)/(fls.input(1).range(2)-fls.input(1).range(1));
                        
                        n_lin2x = get(handles.wej2_wart,'Value')*100+1;
                        n_lin2x = (n_lin2x-fls.input(2).range(1)*100)/(fls.input(2).range(2)-fls.input(2).range(1));
                        
                        n_lin3x = get(handles.wej3_wart,'Value')*100+1;
                        n_lin3x = (n_lin3x-fls.input(3).range(1)*100)/(fls.input(3).range(2)-fls.input(3).range(1));                  
                        
                        n_lin4x = get(handles.wej4_wart,'Value')*100+1;
                        n_lin4x = (n_lin4x-fls.input(4).range(1)*100)/(fls.input(4).range(2)-fls.input(4).range(1));
                  end
                        %warunki wybierajace odpowiednie pliki obliczajace

                        %odczytanie czy CONNECTION OR albo AND
                        %OR = 2, AND = 1
                        Conn = fls.rule(i).connection;
                       for  k=1:IleWyjsc 
                        if Conn == 1
                            
                            if strcmp(fls.andMethod,'min')
                            %warunek gdy sa 2 wejscia 1 wyjscie
                            if IleWejsc == 1
                                min_dolna(k,i) = mf_dolna(n_lin1x,1);
                                min_gorna(k,i) = mf_gorna(n_lin1x,1);

                            elseif IleWejsc == 2
                                [min_dolna(k,i), min_gorna(k,i)] = min_and(n_lin1x,n_lin2x,mf_dolna(:,1),mf_gorna(:,1),mf_dolna(:,2),mf_gorna(:,2));
                                    if min_dolna(k,i) > min_gorna(k,i)
                                        temp = min_dolna(k,i);
                                        min_dolna(k,i) = min_gorna(k,i);
                                        min_gorna(k,i) = temp;
                                    end

                            elseif IleWejsc == 3  
                                [min_dolna1, min_gorna1] = min_and(n_lin1x,n_lin2x,mf_dolna(:,1),mf_gorna(:,1),mf_dolna(:,2),mf_gorna(:,2));

                                    if min_dolna1 > min_gorna1
                                        temp = min_dolna1;
                                        min_dolna1 = min_gorna1;
                                        min_gorna1 = temp;
                                    end
                                [min_dolna2, min_gorna2] = min_and(n_lin1x,n_lin3x,mf_dolna(:,1),mf_gorna(:,1),mf_dolna(:,3),mf_gorna(:,3));
                                    if min_dolna2 > min_gorna2
                                        temp = min_dolna2;
                                        min_dolna2 = min_gorna2;
                                        min_gorna2 = temp;
                                    end                                
                                    min_dolna(k,i) = min([min_dolna1 min_dolna2]);
                                    min_gorna(k,i) = min([min_gorna1 min_gorna2]);
                          
                            elseif IleWejsc == 4
                                [min_dolna1, min_gorna1] = min_and(n_lin1x,n_lin2x,mf_dolna(:,1),mf_gorna(:,1),mf_dolna(:,2),mf_gorna(:,2));
                                    if min_dolna1 > min_gorna1
                                        temp = min_dolna1;
                                        min_dolna1 = min_gorna1;
                                        min_gorna1 = temp;
                                    end
                                [min_dolna2, min_gorna2] = min_and(n_lin3x,n_lin4x,mf_dolna(:,3),mf_gorna(:,3),mf_dolna(:,4),mf_gorna(:,4));
                                    if min_dolna2 > min_gorna2
                                        temp = min_dolna2;
                                        min_dolna2 = min_gorna2;
                                        min_gorna2 = temp;
                                    end                                
                                    min_dolna(k,i) = min([min_dolna1 min_dolna2]);
                                    min_gorna(k,i) = min([min_gorna1 min_gorna2]);
                       
                            end                            

                            elseif strcmp(fls.andMethod,'prod')
                                if IleWejsc == 1
                                    min_dolna(k,i) = mf_dolna(n_lin1x,1);
                                    min_gorna(k,i) = mf_gorna(n_lin1x,1);
                                elseif IleWejsc == 2
                                    [min_dolna(k,i), min_gorna(k,i)] =   prod_and(n_lin1x,n_lin2x,mf_dolna(:,1),mf_gorna(:,1),mf_dolna(:,2),mf_gorna(:,2));
                                    if min_dolna(k,i) > min_gorna(k,i)
                                            temp = min_dolna(k,i);
                                            min_dolna(k,i) = min_gorna(k,i);
                                            min_gorna(k,i) = temp;
                                    end

                                elseif IleWejsc == 3
                                    [prod_dolna1, prod_gorna1] =   prod_and(n_lin1x,n_lin2x,mf_dolna(:,1),mf_gorna(:,1),mf_dolna(:,2),mf_gorna(:,2));
                                    if prod_dolna1 > prod_gorna1
                                            temp = prod_dolna1;
                                            prod_dolna1 = prod_gorna1;
                                            prod_gorna1 = temp;
                                    end
                                    [prod_dolna2, prod_gorna2] =   prod_and(n_lin1x,n_lin2x,mf_dolna(:,3),mf_gorna(:,3),mf_dolna(:,2),mf_gorna(:,2));
                                    if prod_dolna2 > prod_gorna2
                                            temp = prod_dolna2;
                                            prod_dolna2 = prod_gorna2;
                                            prod_gorna2 = temp;
                                    end
                                    min_dolna(k,i) = prod([prod_dolna1 prod_dolna2]);
                                    min_gorna(k,i) = prod([prod_gorna1 prod_gorna2]);

                                elseif IleWejsc == 4
                                     [prod_dolna1, prod_gorna1] =   prod_and(n_lin1x,n_lin2x,mf_dolna(:,1),mf_gorna(:,1),mf_dolna(:,2),mf_gorna(:,2));
                                    if prod_dolna1 > prod_gorna1
                                            temp = prod_dolna1;
                                            prod_dolna1 = prod_gorna1;
                                            prod_gorna1 = temp;
                                    end
                                    [prod_dolna2, prod_gorna2] =   prod_and(n_lin3x,n_lin4x,mf_dolna(:,3),mf_gorna(:,3),mf_dolna(:,4),mf_gorna(:,4));
                                    if prod_dolna2 > prod_gorna2
                                            temp = prod_dolna2;
                                            prod_dolna2 = prod_gorna2;
                                            prod_gorna2 = temp;
                                    end
                                    min_dolna(k,i) = prod([prod_dolna1 prod_dolna2]);
                                    min_gorna(k,i) = prod([prod_gorna1 prod_gorna2]);
                               
                                end                           
                            end

                        %dla connection OR
                            elseif Conn == 2
                            if strcmp(fls.orMethod,'max')
                            %warunek gdy sa 2 wejscia 1 wyjscie
                            if IleWejsc == 1
                                min_dolna(k,i) = max(mf_dolna(:,1));
                                min_gorna(k,i) = max(mf_gorna(:,1));
 
                            elseif IleWejsc == 2
                                [min_dolna(k,i), min_gorna(k,i)] = max_or(n_lin1x,n_lin2x,mf_dolna(:,1),mf_gorna(:,1),mf_dolna(:,2),mf_gorna(:,2));
                                    if min_dolna(k,i) > min_gorna(k,i)
                                        temp = min_dolna(k,i);
                                        min_dolna(k,i) = min_gorna(k,i);
                                        min_gorna(k,i) = temp;
                                    end

                            elseif IleWejsc == 3  
                                [min_dolna1, min_gorna1] = max_or(n_lin1x,n_lin2x,mf_dolna(:,1),mf_gorna(:,1),mf_dolna(:,2),mf_gorna(:,2));

                                    if min_dolna1 > min_gorna1
                                        temp = min_dolna1;
                                        min_dolna1 = min_gorna1;
                                        min_gorna1 = temp;
                                    end
                                [min_dolna2, min_gorna2] = max_or(n_lin3x,n_lin4x,mf_dolna(:,1),mf_gorna(:,1),mf_dolna(:,3),mf_gorna(:,3));
                                    if min_dolna2 > min_gorna2
                                        temp = min_dolna2;
                                        min_dolna2 = min_gorna2;
                                        min_gorna2 = temp;
                                    end                                
                                    min_dolna(k,i) = max([min_dolna1 min_dolna2]);
                                    min_gorna(k,i) = max([min_gorna1 min_gorna2]);
                            
                            elseif IleWejsc == 4
                                [min_dolna1, min_gorna1] = max_or(n_lin1x,n_lin2x,mf_dolna(:,1),mf_gorna(:,1),mf_dolna(:,2),mf_gorna(:,2));
                                    if min_dolna1 > min_gorna1
                                        temp = min_dolna1;
                                        min_dolna1 = min_gorna1;
                                        min_gorna1 = temp;
                                    end
                                [min_dolna2, min_gorna2] = max_or(n_lin3x,n_lin4x,mf_dolna(:,3),mf_gorna(:,3),mf_dolna(:,4),mf_gorna(:,4));
                                    if min_dolna2 > min_gorna2
                                        temp = min_dolna2;
                                        min_dolna2 = min_gorna2;
                                        min_gorna2 = temp;
                                    end                                
                                    min_dolna(k,i) = max([min_dolna1 min_dolna2]);
                                    min_gorna(k,i) = max([min_gorna1 min_gorna2]);                         
                            end
                                    
                            elseif strcmp(fls.orMethod,'probor')
                                if IleWejsc == 1
                                    min_dolna(k,i) = mf_dolna(n_lin1x,1);
                                    min_gorna(k,i) = mf_gorna(n_lin1x,1);
                                elseif IleWejsc == 2
                                    [min_dolna(k,i), min_gorna(k,i)] =   probor_or(n_lin1x,n_lin2x,mf_dolna(:,1),mf_gorna(:,1),mf_dolna(:,2),mf_gorna(:,2));
                                    if min_dolna(k,i) > min_gorna(k,i)
                                            temp = min_dolna(k,i);
                                            min_dolna(k,i) = min_gorna(k,i);
                                            min_gorna(k,i) = temp;
                                    end

                                elseif IleWejsc == 3
                                    [prod_dolna1, prod_gorna1] =   probor_or(n_lin1x,n_lin2x,mf_dolna(:,1),mf_gorna(:,1),mf_dolna(:,2),mf_gorna(:,2));
                                    if prod_dolna1 > prod_gorna1
                                            temp = prod_dolna1;
                                            prod_dolna1 = prod_gorna1;
                                            prod_gorna1 = temp;
                                    end
                                    [prod_dolna2, prod_gorna2] =   probor_or(n_lin1x,n_lin2x,mf_dolna(:,3),mf_gorna(:,3),mf_dolna(:,2),mf_gorna(:,2));
                                    if prod_dolna2 > prod_gorna2
                                            temp = prod_dolna2;
                                            prod_dolna2 = prod_gorna2;
                                            prod_gorna2 = temp;
                                    end
                                    min_dolna(k,i) = probor([prod_dolna1 prod_dolna2]);
                                    min_gorna(k,i) = probor([prod_gorna1 prod_gorna2]);

                                elseif IleWejsc == 4
                                     [prod_dolna1, prod_gorna1] =   probor_or(n_lin1x,n_lin2x,mf_dolna(:,1),mf_gorna(:,1),mf_dolna(:,2),mf_gorna(:,2));
                                    if prod_dolna1 > prod_gorna1
                                            temp = prod_dolna1;
                                            prod_dolna1 = prod_gorna1;
                                            prod_gorna1 = temp;
                                    end
                                    [prod_dolna2, prod_gorna2] =   probor_or(n_lin3x,n_lin4x,mf_dolna(:,3),mf_gorna(:,3),mf_dolna(:,4),mf_gorna(:,4));
                                    if prod_dolna2 > prod_gorna2
                                            temp = prod_dolna2;
                                            prod_dolna2 = prod_gorna2;
                                            prod_gorna2 = temp;
                                    end
                                    min_dolna(k,i) = probor([prod_dolna1 prod_dolna2]);
                                    min_gorna(k,i) = probor([prod_gorna1 prod_gorna2]);

                                end
                               
                            end
                        end
                             
                             if strcmp(fls.impMethod,'min')
                                if k==1
                                    x=wy1x;
                                elseif k==2
                                    x=wy2x;
                                end
                               
                            [X_ob(k,:), Y_ob(k,:)] = min_plot_bs(x, min_dolna(k,i), min_gorna(k,i),mf_dolna_wyj(k,:),mf_gorna_wyj(k,:));
                            elseif strcmp(fls.impMethod,'prod')
                                if k==1
                                    x=wy1x;
                                elseif k==2
                                    x=wy2x;
                                end
                            [X_ob(k,:), Y_ob(k,:)] = prod_plot_bs(x, min_dolna(k,i), min_gorna(k,i),mf_dolna_wyj(k,:),mf_gorna_wyj(k,:));                            
                             end
                        
                            
                             %wpisanie do macierzy wynikow przed skalowaniem
                                X_ob_mac(i,:,k) = X_ob(k,:);    %k- wyjscie, i-regula
                                Y_ob_mac(i,:,k) = Y_ob(k,:);

                                %wartosc obliczona * wspolczynnik skalujacy +
                                %krawedz lewa + odleglosc o ilosc wejsc
                                X_ob2(k,:) = downsample(X_ob(k,:),8);                      
                                X_ob2(k,:) = X_ob2(k,:)*skok_x/100+krL+(skok_x+2)*(IleWejsc+k-1);
                                
                                %wartosc obliczona * wspolczynik wysokosci +
                                %ilosc okien * skok w pionie

                                Y_ob2(k,:) = downsample(Y_ob(k,:),8);
                                Y_ob2(k,:) = Y_ob2(k,:)*oknoWys+oknoD-(i-1)*skok_y;

                                patch(X_ob2(k,:),Y_ob2(k,:),'b');
                                hold on;
                            
                            
                       end
        end

                            


                           
                       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%DOROBIC FOR I POTEM PODODAWAC WYBOR WZGLEDEM K KTORA ZMIENNA WYJSCIOWA JEST RYSOWANA
                   
                
       
%         %%%RYSOWANIE LINII

%   
%                 %Obliczenia fls2
                  %pobieranie wartosci z zadajnika slider i przeskalowanie
                  %jej na zakres 1-101
                  if IleWejsc == 1
                         dlin1ps = get(handles.wej1_wart,'Value');
                        dlin1 = (dlin1ps - fls.input(1).range(1))/(fls.input(1).range(2)-fls.input(1).range(1));
                        
                                                    dlin = [dlin1];
                                                    dlinps = dlin1ps;
                  elseif IleWejsc == 2
                         dlin1ps = get(handles.wej1_wart,'Value');
                        dlin1 = (dlin1ps - fls.input(1).range(1))/(fls.input(1).range(2)-fls.input(1).range(1));
                        
                        dlin2ps = get(handles.wej2_wart,'Value');
                        dlin2 = (dlin2ps - fls.input(2).range(1))/(fls.input(2).range(2)-fls.input(2).range(1));  
                                                    dlin = [dlin1 dlin2];
                                                    dlinps = [dlin1ps dlin2ps];                                                    
                                                    
                  elseif IleWejsc == 3
                         dlin1ps = get(handles.wej1_wart,'Value');
                        dlin1 = (dlin1ps - fls.input(1).range(1))/(fls.input(1).range(2)-fls.input(1).range(1));
                        
                        dlin2ps = get(handles.wej2_wart,'Value');
                        dlin2 = (dlin2ps - fls.input(2).range(1))/(fls.input(2).range(2)-fls.input(2).range(1)); 

                      dlin3ps = get(handles.wej3_wart,'Value');
                        dlin3 = (dlin3ps - fls.input(3).range(1))/(fls.input(3).range(2)-fls.input(3).range(1));
                                                    dlin = [dlin1 dlin2 dlin3];
                                                    dlinps = [dlin1ps dlin2ps dlin3ps];
                  elseif IleWejsc == 4
                         dlin1ps = get(handles.wej1_wart,'Value');
                        dlin1 = (dlin1ps - fls.input(1).range(1))/(fls.input(1).range(2)-fls.input(1).range(1));
                        
                        dlin2ps = get(handles.wej2_wart,'Value');
                        dlin2 = (dlin2ps - fls.input(2).range(1))/(fls.input(2).range(2)-fls.input(2).range(1));   
                                         
                      dlin3ps = get(handles.wej3_wart,'Value');
                        dlin3 = (dlin3ps - fls.input(3).range(1))/(fls.input(3).range(2)-fls.input(3).range(1));

                      dlin4ps = get(handles.wej4_wart,'Value');
                        dlin4 = (dlin4ps - fls.input(4).range(1))/(fls.input(4).range(2)-fls.input(4).range(1));
                                                    dlin = [dlin1 dlin2 dlin3 dlin4];
                                                    dlinps = [dlin1ps dlin2ps dlin3ps dlin4ps];
                  end
                  %wartosci w handles wej_ed
                  
                  wej_wart = num2str(dlinps);
                  set(handles.wej_ed,'String',wej_wart);
                            

             %               Przerysuj_linie(hObject,dlin,handles);
                    
             for k=1:IleWyjsc
                 
                        %rysowanie patch'a na dole wynikowego
                        patch([krL krL krP krP], ...
                               [oknoD-skok_y*(IleReg + k) oknoG-skok_y*(IleReg + k) ...
                                oknoG-skok_y*(IleReg + k) oknoD-skok_y*(IleReg + k)],obCol);
                            
                            if strcmp(fls.aggMethod,'max')
                                if IleReg == 1
                                Xagg_ob = X_ob_mac(:,:,k);
                                Yagg_ob = Y_ob_mac(:,:,k);
                                else
                                [Xagg_ob, Yagg_ob] = max_agg(X_ob_mac(:,:,k),Y_ob_mac(:,:,k));
                                end
                            elseif strcmp(fls.aggMethod,'probor')
                                if IleReg == 1
                                Xagg_ob = X_ob_mac(:,:,k);
                                Yagg_ob = Y_ob_mac(:,:,k);
                                else
                                [Xagg_ob, Yagg_ob] = probor_agg(X_ob_mac(:,:,k),Y_ob_mac(:,:,k));
                                end
                            end
                               x_do_wyj = Xagg_ob;
                               y_do_wyj = Yagg_ob;

                                Xagg_ob = Xagg_ob*0.96+krL;
                                %potrzebne gdy wyniki maja byc w malym
                                %kwadraciku
                                %Xagg_ob = downsample(Xagg_ob,8) + prawa - lewa;
                                Yagg_ob = Yagg_ob*(oknoWys)+oknoD-(IleReg+k)*skok_y;
                                %Yagg_ob = downsample(Yagg_ob,8) + gora - dol;
                                
                                patch(Xagg_ob,Yagg_ob,'b');     %wykers po agregacji
                                hold on
                  
                        


                        
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
%               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          
                        w(2,:) = fliplr(w(2,:));
                        w = mean(w,1);
                        

                        delta = w(1,:)' - y_do_wyj(1:length(z)); 
                        
                        delta = delta';

                        defuzz_met = fls.defuzzMethod;

                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        %przerobione na mozliwosc dodawania swoich metod
                        %pobor listy metod z folderu
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

                                for j = 1:length(lista_metod);
                                    if lista_metod(i,j) == '.'
                                       lista_metod2(i,j-3:end) = ' ';
                                    break;
                                    else
                                       lista_metod2(i,j) = lista_metod(i,j);
                                    end
                                end
                            end
                            lista_metod = cellstr(lista_metod2);
                            
                            %wyszukiwanie aktualnej metody defuzyfikacji
                            for i=1:length(lista_metod)
                                if strcmp(cellstr(defuzz_met),lista_metod(i))
                                    defuzz_met_c = fls.defuzzMethod;
                                    %defuzz_met_u = uint8(defuzz_met_c)
                                    %defuzz_met_u =defuzz_met_u(1:end)
                                    defuzz_met_c = char([defuzz_met_c '_tr']);
                                    point_fcn = str2func(defuzz_met_c);
                                    
                                    if(strcmp(defuzz_met,'centroid'))
                                    [l_out, r_out] = feval(point_fcn,z/100,w,delta);
                                    elseif (strcmp(defuzz_met,'csum')) %efekt raczej taki sam jak w centroid
                                    [l_out, r_out] = feval(point_fcn,z'/100,w',delta');
                                    elseif (strcmp(defuzz_met,'height'))

                                        for p = 1:IleReg
                                            typmf= fls.output(k).mf( fls.rule(p).consequent(k) ).type;
                                            parametr = fls.output(k).mf( fls.rule(p).consequent(k) ).params;
                                            
                                        if strcmp(typmf, 'trisymmftype2')
                                        h(k,p)=parametr(3);
                                        elseif strcmp(typmf, 'trimftype2')
                                        h(k,p)=(parametr(2)+parametr(5))/2;
                                        elseif strcmp(typmf, 'tri2mftype2')
                                        h(k,p)=(parametr(1)+parametr(2)+parametr(3))/3;
                                        elseif strcmp(typmf, 'gaussmftype2')
                                        h(k,p)=(parametr(2)+parametr(4))/2;
                                        elseif strcmp(typmf, 'gbellmfype2')
                                        h(k,p)=parametr(4);
                                        elseif strcmp(typmf, 'trapmftype2')
                                        h(k,p)=(parametr(2)+parametr(3)+parametr(6)+parametr(7))/4;
%                                         elseif strcmp(typmf, 'zmftype2')
%                                         h(k,p)=sum(parametr)/4;
%                                         elseif strcmp(typmf, 'sigmftype2')
%                                         h(k,p)=sum(parametr)/4;
%                                         elseif strcmp(typmf, 'smftype2')
%                                         h(k,p)=sum(parametr)/4;
                                        else
                                        error('Uzyto na wyjsciu jednej z niedozwolonych funkcji (zmftype2,sigmftype2,smftype2) lub zdefiniowanej przez uzytkownika');
                                        end
                                        
                                        end


                                        w     = (min_gorna + min_dolna)/2;
                                        delta = (min_gorna - min_dolna)/2;
                                        [l_out, r_out] = feval(point_fcn,h(k,:)',w',delta');
                                        
                                    elseif (strcmp(defuzz_met,'md_height'))
                                        for p = 1:IleReg
                                            typmf= fls.output(k).mf( fls.rule(p).consequent(k) ).type;
                                            parametr = fls.output(k).mf( fls.rule(p).consequent(k) ).params;
                                            
                                        if strcmp(typmf, 'trisymmftype2')
                                        h(k,p)=parametr(3);
                                        sp1=parametr(3) - parametr(1);
                                        sp2=parametr(3) - parametr(2);
                                        sp(k,p)=sp1+sp2;
                                        elseif strcmp(typmf, 'trimftype2')
                                        h(k,p)=(parametr(2)+parametr(5))/2;
                                        sp1=parametr(6) - parametr(1);
                                        sp2=parametr(3) - parametr(4);
                                        sp(k,p)=(sp1+sp2)/2;                                        
                                        elseif strcmp(typmf, 'tri2mftype2')
                                        h(k,p)=(parametr(1)+parametr(2)+parametr(2))/3;
                                        sp1=parametr(3) + 2*parametr(4) - parametr(1);
                                        sp2=parametr(3) - parametr(1);
                                        sp(k,p)=(sp1+sp2)/2;                                          
                                        elseif strcmp(typmf, 'gaussmftype2')
                                        h(k,p)=(parametr(2)+parametr(4))/2;
                                        sp(k,p)=(parametr(1) + parametr(3))/2;                                          
                                        elseif strcmp(typmf, 'gbellmfype2')
                                        h(k,p)=parametr(4);
                                        sp(k,p)=(parametr(1) + parametr(2))/2;                                         
                                        elseif strcmp(typmf, 'trapmftype2')
                                        h(k,p)=(parametr(2)+parametr(3)+parametr(6)+parametr(7))/4;
                                        sp1=parametr(1) + parametr(4);
                                        sp2=parametr(5) + parametr(8);
                                        sp(k,p)=(sp1+sp2)/2;                                         
%                                         elseif strcmp(typmf, 'zmftype2')
%                                         h(k,p)=sum(parametr)/4;
%                                         elseif strcmp(typmf, 'sigmftype2')
%                                         h(k,p)=sum(parametr)/4;
%                                         elseif strcmp(typmf, 'smftype2')
%                                         h(k,p)=sum(parametr)/4;
                                        else
                                        error('Uzyto na wyjsciu jednej z niedozwolonych funkcji (zmftype2,sigmftype2,smftype2) lub zdefiniowanej przez uzytkownika');
                                        end
                                        
                                        end


                                        w     = (min_gorna + min_dolna)/2;
                                        delta = (min_gorna - min_dolna)/2;
                                        [l_out, r_out] = feval(point_fcn,h(k,:),w,delta,sp(k,:));
                                        
                                    elseif (strcmp(defuzz_met,'cos'))
                                        
                                            for p = 1:IleReg %liczba wszystkich funkcji na wyjsciach                                                
                                            typmf= fls.output(k).mf( fls.rule(p).consequent(k) ).type;   
                                            mf_fcn = str2func(typmf);
                                            parametr = fls.output(k).mf( fls.rule(p).consequent(k) ).params*100;
                                                if strcmp(typ,'gbellmftype2')
                                                parametr(3)=parametr(3)/100;
                                                end
                                            [gorna, dolna]= feval(mf_fcn,we1x,parametr);
                                            h2      = (gorna+dolna)/2; %przyjmowane wartosci funkcji na wyjsciach przed implikacja
                                            delta2  = (gorna-dolna)/2;
                                            [yl,yr]=centroid_tr(z/100,h2,delta2);%% !!!!!!!!!!!!!!!
                                            centroidL(1,p) = yl;
                                            centroidR(1,p) = yr;
                                            end
                                            
                                    z     = (centroidR + centroidL)/2;
                                    s     = (centroidR - centroidL)/2;
                                    w     = (min_gorna + min_dolna)/2;
                                    delta = (min_gorna - min_dolna)/2;
                                    [l_out, r_out] = feval(point_fcn,z,s',w,delta);
                                    end
                                     
                                    %warunek dla wartosci sredniej gdy nie
                                    %wystepuja stany posrednie wartosci

                                    if isnan(l_out) || isnan(r_out) 
                                        out(k) = mean(fls.output(k).range)*100;
                                    else
                                        %rozwiazanie dorazne
                                        if IleWejsc == 4
                                        
                                        out(k) = mean([l_out r_out])/2;
                                        else
                                        out(k) = mean([l_out r_out]);
                                        end
                                    end
                                    break;
                                end
                            end
%                         switch defuzz_met  %podstawowy przypadek
%                             case 'centroid'
%                             [l_out, r_out] = centroid_tr(z,w,delta);
%                             out = mean([l_out r_out]);
%                             case 'œrodek sum'
%                             [l_out, r_out] = cos_tr(z,w,delta);
%                             out = mean([l_out r_out]);
%                         end
                           
                         %%%%%Rysowanie wartosci odpowiedzi wyjscia
                         odpCol = [1 1 0.5];
                         line([out(k)*100 out(k)*100], [oknoD-3-skok_y*(IleReg+k) oknoG+1-skok_y*(IleReg+k)],'Color',odpCol,'LineWidth',3);
                         %tekstowo wartosc wyjscia
                         set(handles.wyj_wart,'String',num2str(out(k)));
                         
                         %Ile Regul
                         IleRegul = length(fls.rule);
       
                         %dolna wartsc y linii
                         handles.lin1Yd = oknoD-oknoWys*(IleRegul);

                         guidata(hObject,handles);
                         Przerysuj_linie(hObject,dlin,handles);
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



% --- Executes on button press in info_push.
function info_push_Callback(hObject, eventdata, handles)


% --- Executes on button press in wyjscie_push.
function wyjscie_push_Callback(hObject, eventdata, handles)
pod_CloseRequestFcn(hObject, eventdata, handles);

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
       disp('Anulowano');
    else
       disp(['Wybrano ', fullfile(plik, sciezka)]);
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


% --- Executes on slider movement.
function wej3_wart_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
    cla;
    Przerysuj(hObject,eventdata,handles);


% --- Executes during object creation, after setting all properties.
function wej3_wart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wej3_wart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function wej4_wart_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
    cla;
    Przerysuj(hObject,eventdata,handles);


% --- Executes during object creation, after setting all properties.
function wej4_wart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wej4_wart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function zslices_slider_Callback(hObject, eventdata, handles)
    handles = guidata(gcf); 
    nazwa = handles.nazwa;
    fls=readfis(nazwa);
    zslices_val = get(handles.zslices_slider,'Value');
%    set(handles.zslices_val,'String',num2str(zslices_val));
    Przerysuj(hObject, eventdata, handles);
    guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function zslices_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zslices_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
