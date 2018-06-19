function varargout = Wej_ed(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Baza_regul
%   Funkcja sluzy do wywolywania okna edycji wejsc i wyjsc
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
%     IT2FLS
%     + funkcje wbudowane w program Matlab
%
%     Uzywane zmienne:
%     nazwa - nazwa aktualnego fis
%     rang
%     axmfPos
%     axmfCol
%     axmfHndl
%     parametry
%     mfTxt
%     kt_mf
%     kt_mf_str
%     zak
%     mf_typ_str
%     str_nw
%     txt
%     spacje
%     niezera
%     i,j,k
%     max_g
%     mid_i
%     dolna
%     gorna
%     (I)varargin - argument wejsciowy
%     (O)vargout - argument wyjsciowy
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
%     Plik/funkcja mocno powiazana z plikiem Wej_ed.fig - w nim zapisana jest 
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
                   'gui_OpeningFcn', @Wej_ed_OpeningFcn, ...
                   'gui_OutputFcn',  @Wej_ed_OutputFcn, ...
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


% --- Executes just before Wej_ed is made visible.
function Wej_ed_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Wej_ed (see VARARGIN)
clc;
if isempty(varargin)
    fls = readfis('bez_nazwy');
    handles.nazwa = 'bez_nazwy';
    nazwa = handles.nazwa;
else
    
    nazwa = char(varargin);
    fls = readfis(nazwa);
    handles.nazwa = nazwa;

end


IleWejsc = length(fls.input);
IleWyjsc = length(fls.output);

handles.output = hObject;
%structure = findobj(IT2FLS); 
   
  %wczytanie z workspace zslice
  zslices_num = evalin('base','zslices');
  %ustalenie czy zslices_str i zslice_slider jest enable
  if zslices_num ~= 0
      set(handles.zslices_str,'Visible','On');
      set(handles.zslices_val,'Visible','On','String',num2str(get(handles.zslices_slider,'Value')));
      set(handles.zslices_slider,'Min',0,'Max',zslices_num,'Visible','On'); 

  else
      set(handles.zslices_str,'Visible','Off');
      set(handles.zslices_slider,'Visible','Off');
      set(handles.zslices_val,'Visible','Off');
  end

    handles.zslices = zslices_num;         
    %pole wprowadzania zmiennych do handles
    %pomocnicza wartoœæ do mf_param_Callback()
    handles.enter_str = []; 
    
    %kt_wej - okreslanie na podstawie wpisanego napisu w pole naz_zmien
    pole_str = get(handles.naz_zmien,'String');
    wejscia_tab = get(handles.Wejscia_ed_pop,'String');
    wyjscia_tab = get(handles.Wyjscia_ed_pop,'String');

    handles.kt_wej = 1;
    
    if strcmp('init',pole_str)
            handles.kt_wej = 1;
    end
    for i = 1:IleWejsc
        
        if strcmp(pole_str,wejscia_tab)
            handles.kt_wej = i;
    
        end
    end
    
    for i = 1:IleWyjsc
        if strcmp(pole_str,wejscia_tab)
            handles.kt_wej = i+4;
        end
    end        
        
        
       
    %pomocnicza wartosc okresljaca ktore wejscie
    %poczatkowo 1


    
    %pobranie zakresu
    rang = fls.input(1).range;
      
    %handles odpowiedzialny za wykonanie funkcji w niektorych przypadkach
    %handles.kt_wej = 1;
    
    %handles odpowiedzialny za wywolanie rysowania we/wy przez linijke
    %parametry
    handles.return = 0;
    %handles odpowiedniego wyboru sporobu zmiany parametrow w okienku
    handles.param_case = 1;
    
    %zapis danych
    guidata(hObject,handles);
    handles = guidata(gcf); 
     %====================================
     %%%%%%Tworzenie g³ównego AXES  

    axmfPos = [220 250 320 187];
    axmfCol = [0.99 1 0.7];
    axmfHndl=axes( ...
            'Box','on', ...
            'Units','pixels', ...
            'Position',axmfPos, ...
            'Tag','mfaxes', ...
            'Visible','on', ...
            'Color', axmfCol);
        
        hold on;
    
     %%%%%Ustawianie podzia³ki x oraz y wykresu
        xlim([rang(1) rang(2)]);
        ylim([0 1.4]);
        %h = plot(x,zeros(101),'-k',zeros(121), y,'-k' );
        hold on;
        %patch([0 0 1 1],[0 1.2 1.2 0],axmfCol);
        
        %axis off;
        %%%%%wyrysowanie funkcji przynaleznosci
        %ustawienie parametrow            
        %handles.parametr = fls.input(1).mf(1).params
        parametry = fls.input(1).mf(1).params;
        %handles.co_robic = [];
        
        guidata(hObject,handles);
        handles = guidata(gcf);

        Wejscia_rysuj_Callback(hObject, parametry, handles);
%% 
        %%%%%Obecna figura i zmienna
         figNumber=get(0,'CurrentFigure');

        currVarAxes=findobj(figNumber,'Type','axes','XColor',[0 0 0.2]);
        varType=get(currVarAxes,'Tag');

        mainAxes=findobj(figNumber,'Type','axes','Tag','mainaxes');
        param=get(mainAxes,'UserData');
        %currMF=param.CurrMF;   



%%%%%Wypisanie w polach - wejscie i wyjscie
    for i = 1: length(fls.input) 
    wejsciaTxt(i,1) = [cellstr(fls.input(i).name)];
    end
    set(handles.Wejscia_ed_pop,'String',wejsciaTxt);
    
    for i = 1: length(fls.output) 
    wyjsciaTxt(i,1) = [cellstr(fls.output(i).name)];
    end
    
    
    set(handles.Wyjscia_ed_pop,'String',wyjsciaTxt);
    
    writefis(fls,nazwa);
    
%%%%%Wypisanie w polu funkcja przynaleznosci   

    for i = 1 : length(fls.input(1).mf);
        mfTxt(i,1) =  cellstr(fls.input(1).mf(i).name);
    end

        set(handles.Mf_ed_pop,'String',mfTxt);
    
    %pomocnicza wartoœæ okreslajaca ktora mf
    kt_mf = get(handles.Mf_ed_pop,'Value');
    kt_mf_str = get(handles.Mf_ed_pop,'String');
    mf_nazwa_str = kt_mf_str(kt_mf);
    handles.kt_mf = [kt_mf];
%%%%%Wpisanie w polu mf_nazwa

    set(handles.mf_nazwa,'String',mf_nazwa_str);
    
%%%%%Wpisanie w polu naz_zmien
    set(handles.naz_zmien,'String',fls.input(1).name);
    
%%%%%Wpisanie w polu zak - zakres
    zak = fls.input(1).range;
    zak = num2str(zak);
    zak = ['[' zak '] '];
    
    set(handles.zak,'String', zak);
    
%%%%%Wspiasnie w polu mf_typ
    mf_typ_str = [cellstr('trisymmftype2'); ...
                  cellstr('trimftype2'); ...
                  cellstr('tri2mftype2'); ...
                  cellstr('gaussmftype2'); ...
                  %cellstr('gausssymmftype2'); ...
                  cellstr('gbellmftype2'); ...
                  %cellstr('gbellsym2mftype2'); ...
                  %cellstr('gbellsym3mftype2'); ...
                  cellstr('trapmftype2'); ...
                  cellstr('zmftype2'); ...
                  cellstr('smftype2'); ...
                  cellstr('sigmftype2')];


      set(handles.mf_typ,'String',mf_typ_str);
%%%%%Wybranie w polu mf_typ odpowiedniej wartosci
if handles.kt_wej <= 4
    mf_val = strcmp(fls.input(handles.kt_wej).mf(kt_mf).type,mf_typ_str);
elseif handles.kt_wej > 4
    mf_val = strcmp(fls.output(handles.kt_wej-4).mf(kt_mf).type,mf_typ_str);
end
    typ_val = find(mf_val);


      set(handles.mf_typ,'Value',typ_val);
% Update handles structure
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = Wej_ed_OutputFcn(hObject, eventdata, handles) 
% varargout  cell 
%array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Zapisanie danych fis w macierzy jako fls

% Get default command line output from handles structure
varargout{1} = handles.output;


%====================================
    %%%%%Wygenerowane przez guide
    
    
% --- Executes on selection change in wej_ed.
function wej_ed_Callback(hObject, eventdata, handles)
    
% --- Executes during object creation, after setting all properties.
function wej_ed_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function naz_zmien_Callback(hObject, eventdata, handles)
% wpisywanie nowych wartosci 
    handles = guidata(gcf); 
    nazwa = handles.nazwa;
    fls=readfis(nazwa);
    %wpiszanie nazwy
        str_nw = get(handles.naz_zmien,'String');
        if handles.kt_wej <=4
            fls.input(handles.kt_wej).name = str_nw;
        elseif handles.kt_wej > 4
            fls.output(handles.kt_wej-4).name = str_nw;
        end
        writefis(fls,nazwa);
        handles.kt_wej = 0;
        guidata(hObject,handles);
        Wejscia_rysuj_Callback(hObject, eventdata, handles)  
    
%     if  strcmp(handles.kt_wej,'#zmiana_enter 1')
%         str_nw = get(handles.naz_zmien,'String');
%         fls.input(1).name = str_nw;
%         writefis(fls,nazwa);
%         handles.kt_wej = '';
%         guidata(hObject,handles);
%         Wejscia_rysuj_Callback(hObject, eventdata, handles)
% 
%     elseif strcmp(handles.kt_wej,'#zmiana_enter 2')
%         str_nw = get(handles.naz_zmien,'String');
%         fls.input(2).name = str_nw;
%         writefis(fls,nazwa);
%         
%         handles.kt_wej = '';
%         guidata(hObject,handles);
%         Wejscia_rysuj_Callback(hObject, eventdata, handles)
% 
%     elseif strcmp(handles.kt_wej,'#zmiana_enter 3')
%         str_nw = get(handles.naz_zmien,'String');
%         fls.input(3).name = str_nw;
%         writefis(fls,nazwa);
%         
%         handles.kt_wej = '';
%         guidata(hObject,handles);
%         Wejscia_rysuj_Callback(hObject, eventdata, handles)
%         
%         
%     elseif strcmp(handles.kt_wej,'#zmiana_enter 5')
%         str_nw = get(handles.naz_zmien,'String');
%         fls.output(1).name = str_nw;
%         writefis(fls,nazwa);
%         handles.kt_wej = '';
%         guidata(hObject,handles);
%         Wyjscia_rysuj_Callback(hObject, eventdata, handles)
%         %handles.kt_wej = '';
    
% --- Executes on key press with focus on naz_zmien and none of its controls.
function naz_zmien_KeyPressFcn(hObject, eventdata, handles)
% wpisywanie nowych wartosci 
    handles = guidata(gcf); 
    nazwa = handles.nazwa;
    fls=readfis(nazwa);
     
     
    %odczytanie klawisza - jezeli ktos wcisnie enter/return to ma sie
    %zapisywac i odczytywac od razu w okienku do wpisywania
     klaw = get(gcf, 'CurrentKey');
     
if strcmp(klaw,'return')
    
  %  if handles.kt_wej <10
        %ta funkcja narysuje nowe mf i przy okazji wpisze param
        handles.kt_wej = handles.kt_wej;
        guidata(hObject,handles);
%     else
%             case 2
% 
%                 %ta funkcja narysuje nowe mf i przy okazji wpisze param
%                 handles.kt_wej = '#zmiana_enter 2';
%                 guidata(hObject,handles);
% 
%             case 3
%                 %ta funkcja narysuje nowe mf i przy okazji wpisze param
%                 handles.kt_wej = '#zmiana_enter 3';
%                 guidata(hObject,handles);
 %   end
       naz_zmien_Callback(hObject, eventdata, handles);
%   
else
    return;
       
end

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function naz_zmien_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes during object creation, after setting all properties.
function zak_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function wysw_zak_Callback(hObject, eventdata, handles)
% wpisywanie nowych wartosci 
    handles = guidata(gcf);
    nazwa = handles.nazwa;
    fls=readfis(nazwa);
    
    zak = get(handles.wysw_zak,'String');
    set(handles.wysw_zak,'String',str2num(zak));

% --- Executes during object creation, after setting all properties.
function wysw_zak_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function mf_nazwa_Callback(hObject, eventdata, handles)
% wpisywanie nowych wartosci 
    handles = guidata(gcf);
    nazwa = handles.nazwa;
    fls=readfis(nazwa);
    
    kt_mf = get(handles.Mf_ed_pop,'Value');
    

        str_nw = get(handles.mf_nazwa,'String');
        str_nw = char(str_nw);
        if handles.kt_wej <= 4
            fls.input(handles.kt_wej).mf(kt_mf).name = str_nw;
        writefis(fls,nazwa);
        handles.kt_wej = 0;
        guidata(hObject,handles);
        Wejscia_rysuj_Callback(hObject, eventdata, handles)
        elseif handles.kt_wej > 4 
            fls.output(handles.kt_wej-4).mf(kt_mf).name = str_nw;
        writefis(fls,nazwa);
        handles.kt_wej = 0;
        guidata(hObject,handles);
        Wyjscia_rysuj_Callback(hObject, eventdata, handles);
        end
        
%         writefis(fls,nazwa);
%         handles.kt_wej = 0;
%         guidata(hObject,handles);
%         Wejscia_rysuj_Callback(hObject, eventdata, handles)
%     

        %handles.kt_wej = '';
    guidata(hObject,handles);
    writefis(fls,nazwa);
    
% --- Executes on key press with focus on mf_nazwa and none of its controls.
function mf_nazwa_KeyPressFcn(hObject, eventdata, handles)
% wpisywanie nowych wartosci 
    handles = guidata(gcf); 
    nazwa = handles.nazwa;
    fls=readfis(nazwa);
     
     
    %odczytanie klawisza - jezeli ktos wcisnie enter/return to ma sie
    %zapisywac i odczytywac od razu w okienku do wpisywania
     klaw = get(gcf, 'CurrentKey');
     
if strcmp(klaw,'return')
        handles.kt_wej = handles.kt_wej;
    mf_nazwa_Callback(hObject, eventdata, handles);
%   
else
    return;
       
end

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function mf_nazwa_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function mf_param_Callback(hObject, eventdata, handles)

handles = guidata(gcf);
nazwa = handles.nazwa;
fls = readfis(nazwa);

param_case = handles.param_case;
kt_mf = get(handles.Mf_ed_pop,'Value');
switch param_case
    %case = 1 zmiana przez zmiane wejscia/wyjscia
    case 1
        if handles.kt_wej <= 4

        txt = fls.input(handles.kt_wej).mf(kt_mf).params;
       % txt = num2str(txt);
        
         %mnoze aby pozbyc sie zbednych liczb po przecinku;
        txt = txt.*100;
        %zaokraglam aby sie pozbyc tych liczb
        txt = round(txt);
        %dziele aby miec poczatkowe wartosci
        txt = txt./100;
        spacje = isspace(txt); 
        %utworzenie nieladnego stringa
        parstr = num2str(txt);

        %usuwanie spacji i dodawanie w odpowiednich miejscach
        n=1;
        %znajduje spacje i wypisuje indeksy znakow ktore nia nie sa
        niezera = find(~isspace(parstr));
            for i = 1:length(niezera)-1
                if niezera(i+1)-niezera(i)>1

                niezera(length(niezera)+n) = niezera(i)+1;
                n=n+1;
                end
            end
            %znalezienie przypadkowych zer
        niezera = niezera(find(niezera));
        %sortowanie kolejnosci indeksow
        niezera=sort(niezera);
        %utworzenie ladnego stringa :)
        txt = parstr(niezera);


        %dodanie nawiaskow
        txt = ['[' txt ']'];
        
       % ustawienie wartosci w oknie 
        set(handles.mf_param,'String',txt);       
        handles.param_case = 0;
        guidata(hObject,handles);
        
        
        elseif handles.kt_wej> 4
         kt_mf = get(handles.Mf_ed_pop,'Value');
        txt = fls.output(handles.kt_wej-4).mf(kt_mf).params;
       % txt = num2str(txt);
        
         %mnoze aby pozbyc sie zbednych liczb po przecinku;
        txt = txt.*100;
        %zaokraglam aby sie pozbyc tych liczb
        txt = round(txt);
        %dziele aby miec poczatkowe wartosci
        txt = txt./100;
        spacje = isspace(txt); 
        %utworzenie nieladnego stringa
        parstr = num2str(txt);

        %usuwanie spacji i dodawanie w odpowiednich miejscach
        n=1;
        %znajduje spacje i wypisuje indeksy znakow ktore nia nie sa
        niezera = find(~isspace(parstr));
            for i = 1:length(niezera)-1
                if niezera(i+1)-niezera(i)>1

                niezera(length(niezera)+n) = niezera(i)+1;
                n=n+1;
                end
            end
            %znalezienie przypadkowych zer
        niezera = niezera(find(niezera));
        %sortowanie kolejnosci indeksow
        niezera=sort(niezera);
        %utworzenie ladnego stringa :)
        txt = parstr(niezera);


%        dodanie nawiaskow
        txt = ['[' txt ']'];
        
        %ustawienie wartosci w oknie 
        set(handles.mf_param,'String',txt);       
        handles.param_case = 0;
        guidata(hObject,handles);           
            
                handles.param_case = 0;
        guidata(hObject,handles);    
        end
     %case = 2 zmiana przez zmiane mf
    case 2
       if handles.kt_wej <= 4
              txt = fls.input(handles.kt_wej).mf(kt_mf).params;
       else
              txt = fls.output(handles.kt_wej-4).mf(kt_mf).params;
       end
       % txt = num2str(txt);
        
         %mnoze aby pozbyc sie zbednych liczb po przecinku;
        txt = txt.*100;
        %zaokraglam aby sie pozbyc tych liczb
        txt = round(txt);
        %dziele aby miec poczatkowe wartosci
        txt = txt./100;
        spacje = isspace(txt); 
        %utworzenie nieladnego stringa
        parstr = num2str(txt);

        %usuwanie spacji i dodawanie w odpowiednich miejscach
        n=1;
        %znajduje spacje i wypisuje indeksy znakow ktore nia nie sa
        niezera = find(~isspace(parstr));
            for i = 1:length(niezera)-1
                if niezera(i+1)-niezera(i)>1

                niezera(length(niezera)+n) = niezera(i)+1;
                n=n+1;
                end
            end
            %znalezienie przypadkowych zer
        niezera = niezera(find(niezera));
        %sortowanie kolejnosci indeksow
        niezera=sort(niezera);
        %utworzenie ladnego stringa :)
        txt = parstr(niezera);


        %dodanie nawiaskow
        txt = ['[' txt ']'];
        
       % ustawienie wartosci w oknie 
        set(handles.mf_param,'String',txt);       
        handles.param_case = 0;
        guidata(hObject,handles);
        
        
        
    %case = 3 zmiana przez enter w mf_param
    case 3
            txt = get(handles.mf_param,'String');
            txt = str2num(txt);
        if handles.kt_wej <=4
            fls.input(handles.kt_wej).mf(kt_mf).params = txt;
            writefis(fls,nazwa);
            Wejscia_rysuj_Callback(hObject, eventdata, handles);

             handles.param_case = 0;
            guidata(hObject,handles);      
        else
            fls.output(handles.kt_wej-4).mf(kt_mf).params = txt;
            writefis(fls,nazwa);
            Wyjscia_rysuj_Callback(hObject, eventdata, handles);
             
             handles.param_case = 0;
            guidata(hObject,handles); 
        end
    %case =4 zmiana przez zmiane typu funkcji    
    %case 4
        otherwise
        return;
end
% txt = eventdata;
% 
% if isempty(eventdata)
%    txt = fls.input(1).mf(1).params;
%     txt = num2str(txt);
% 
% 
%     if handles.kt_wej <= 4
% 
%         kt_mf = get(handles.Mf_ed_pop,'Value');
%        txt = get(handles.mf_param,'String');
%         set(handles.mf_param,'String','');
%         txt = str2num(txt);
%         fls.input(handles.kt_wej).mf(kt_mf).params = '';
%         fls.input(handles.kt_wej).mf(kt_mf).params = txt;
%         txt = num2str(txt)
% 
%         set(handles.mf_param,'String',txt);
%         handles.kt_wej = 0;
%         guidata(hObject,handles);
%         writefis(fls,nazwa);
%         txt = '';
%         ['<=4  1']
%         Wejscia_rysuj_Callback(hObject, eventdata, handles);
% ['<=4  2']
%     elseif handles.kt_wej > 4
% 
%         kt_mf = get(handles.Mf_ed_pop,'Value');
%         txt = get(handles.mf_param,'String')
%         set(handles.mf_param,'String','');
%         txt = str2num(txt);
%         fls.output(handles.kt_wej - 4).mf(kt_mf).params = '';
%         fls.output(handles.kt_wej - 4).mf(kt_mf).params = txt
%         txt = num2str(txt);
% 
%         set(handles.mf_param,'String',txt);
%         handles.kt_wej = '';
%         guidata(hObject,handles);
%         writefis(fls,nazwa); 
%         txt = '';
%         ['<=4  3']
%         Wyjscia_rysuj_Callback(hObject, eventdata, handles);
%     end
% end
%     if ~isempty(handles.enter_str)
%         txt = handles.enter_str;
%         txt = ['[' txt ']'];
%         set(handles.mf_param,'String',txt);
%         txt = '';
%         handles.enter_str = '';
%         guidata(hObject,handles);
%         
%         ['<=4  4']
%     else
% 
%         %mnoze aby pozbyc sie zbednych liczb po przecinku;
%         txt = txt.*100;
%         %zaokraglam aby sie pozbyc tych liczb
%         txt = round(txt);
%         %dziele aby miec poczatkowe wartosci
%         txt = txt./100;
%         spacje = isspace(txt); 
%         %utworzenie nieladnego stringa
%         parstr = num2str(txt);
% 
%         %usuwanie spacji i dodawanie w odpowiednich miejscach
%         n=1;
%         %znajduje spacje i wypisuje indeksy znakow ktore nia nie sa
%         niezera = find(~isspace(parstr));
%             for i = 1:length(niezera)-1
%                 if niezera(i+1)-niezera(i)>1
% 
%                 niezera(length(niezera)+n) = niezera(i)+1;
%                 n=n+1;
%                 end
%             end
%             znalezienie przypadkowych zer
%         niezera = niezera(find(niezera));
%         %sortowanie kolejnosci indeksow
%         niezera=sort(niezera);
%         %utworzenie ladnego stringa :)
%         txt = parstr(niezera);
% 
% 
%         dodanie nawiaskow
%         txt = ['[' txt ']'];
%         
%         ustawienie wartosci w oknie 
%         set(handles.mf_param,'String',txt);
%         guidata(hObject,handles);
%         txt = '';
   % end

% --- Executes on key press with focus on mf_param and none of its controls.
function mf_param_KeyPressFcn(hObject, eventdata, handles)
% wpisywanie nowych wartosci 
    handles = guidata(gcf); 
    nazwa = handles.nazwa;
    fls=readfis(nazwa);
     
     
    %odczytanie klawisza - jezeli ktos wcisnie enter/return to ma sie
    %zapisywac i odczytywac od razu w okienku do wpisywania
     klaw = get(gcf, 'CurrentKey');
     if strcmp(klaw,'return')
    
    %handles.return = 1;
    handles.param_case = 3;

    guidata(hObject,handles);
    %mf_param_Callback(hObject, eventdata, handles);
%   
else
    return;
       
end







function mf_param_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in mf_typ.
function mf_typ_Callback(hObject, eventdata, handles)
handles = guidata(gcf);
nazwa = handles.nazwa;
fls=readfis(nazwa);
kt_mf = get(handles.Mf_ed_pop,'Value');
handles.kt_wyj = handles.kt_wej - 4;
temp_val = get(handles.mf_typ,'Value');
temp_str = get(handles.mf_typ,'String');
mf_typ_str = temp_str{temp_val};
if handles.kt_wej < 5
    %obecny typ mf
    ob_typ = fls.input(handles.kt_wej).mf(kt_mf).type;
    %nowy typ mf
    nw_typ = mf_typ_str;
    fls.input(handles.kt_wej).mf(kt_mf).type = mf_typ_str;
    ob_param = fls.input(handles.kt_wej).mf(kt_mf).params;
    wej_zak = fls.input(handles.kt_wej).range;    
    %ob_param = str2double(ob_param)
    %zmiana parametrow za pomoca funkcji zmiana param
    %zamiast zmiany parametrów - generacja parametrów
    %nw_param = zmianaparammf2mf(ob_param,ob_typ,nw_typ);
    nw_param = genparammf2mf(wej_zak,ob_param,ob_typ,nw_typ);    
    fls.input(handles.kt_wej).mf(kt_mf).params = nw_param;

    writefis(fls,nazwa);
    Wejscia_rysuj_Callback(hObject, eventdata, handles);
    
else %output >10-9
    %obecny typ mf
    ob_typ = fls.output(handles.kt_wyj).mf(kt_mf).type;
    %nowy typ mf
    wej_zak = fls.output(handles.kt_wyj).range;    
    nw_typ = mf_typ_str;
    fls.output(handles.kt_wyj).mf(kt_mf).type = mf_typ_str;
    ob_param = fls.output(handles.kt_wyj).mf(kt_mf).params;
    %ob_param = str2double(ob_param)
    %zmiana parametrow za pomoca funkcji zmiana param
    %zamiast zmiany parametrów - generacja parametrów
    %nw_param = zmianaparammf2mf(ob_param,ob_typ,nw_typ);
    nw_param = genparammf2mf(wej_zak,ob_param,ob_typ,nw_typ);    
    fls.output(handles.kt_wyj).mf(kt_mf).params = nw_param;
    writefis(fls,nazwa);
    Wyjscia_rysuj_Callback(hObject, eventdata, handles);
end
guidata(hObject,handles);




% --- Executes during object creation, after setting all properties.
function mf_typ_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Wejscia_ed_pop.
function Wejscia_ed_pop_Callback(hObject, eventdata, handles)
% hObject    handle to Wejscia_ed_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Wejscia_ed_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Wejscia_ed_pop


% --- Executes during object creation, after setting all properties.
function Wejscia_ed_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Wejscia_ed_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Wejscia rysuj callback

% --- Executes on button press in Wejscia_rysuj.
function Wejscia_rysuj_Callback(hObject, eventdata, handles)
%deklaracja zmiennej pomocniczej okreslajacej ktore wejscie jest rysowane

handles = guidata(gcf);
%handles.kt_wej = handles.kt_wej;
handles.kt_wej = get(handles.Wyjscia_ed_pop,'Value');
nazwa = handles.nazwa;
fls=readfis(nazwa);
%ktora funkcja przynaleznosci
kt_mf = get(handles.Mf_ed_pop,'Value');

%odczyt wartosci zslice z handles
zslices_num = handles.zslices;
zslices_val = get(handles.zslices_slider,'Value');

%mf_param_Callback(hObject, eventdata, handles);
% %% do poprawieniA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %warunek gdy instrukcja jest wykonywana pierwszy raz
% if ~isempty(eventdata)
%     mf_param_pom = eventdata;
%     %warunek gdy instrukcja jest wykonywana przez 'enter' w oknie wpisywania
% %parametrów
% elseif handles.return
%    % mf_param_pom = handles.enter_str;
%    mf_param_pom = handles.mf_param;
%    fls.input(handles.kt_wej).mf(kt_mf).params = mf_param_pom;
% %Zwykly przypadek
% else
%     
%     mf_param_pom = fls.input(handles.kt_wej).mf(kt_mf).params;
%end
%mf_param_pom = fls.input(handles.kt_wej).mf(kt_mf).params;
%czyszczenie axes
   cla;
    %czyszczenie pola parametrow
    set(handles.mf_param,'String','');
  
     writefis(fls,nazwa);   
    
% if handles.kt_wej <= 4
%    % mf_param_pom = handles.enter_str;
%     %kt_mf = get(handles.Mf_ed_pop,'Value');
% 
% 
% % elseif handles.kt_wej > 4
% %     %mf_param_pom = handles.enter_str;
% %     kt_mf = get(handles.Mf_ed_pop,'Value');
% %     fls.output(handles.kt_wej-4).mf(kt_mf).params = mf_param_pom;
% %     writefis(fls,nazwa);
% %     co_robic = '';
% end


    obecnieWyk_str = get(handles.Wejscia_ed_pop,'String');
    obecnieWyk_val = get(handles.Wejscia_ed_pop,'Value');
    
    %wpisanie nazwy mf obecnie wyswietlonego parametru w mf_param 
    mf_param_str = get(handles.Mf_ed_pop,'String');
    mf_param_val = get(handles.Mf_ed_pop,'Value');
    mf_param_val = 1;
    set(handles.mf_param,'String',mf_param_str(mf_param_val));
    

    
    
    %zdefiniowanie wartosci obecnie wykonywanego wejscia w zmiennej
    %pomocniczej
    handles.kt_wej = obecnieWyk_val;
    guidata(hObject,handles);
    
    

    
    %wpisanie nowego stringa do Mf_ed_pop
    for k = 1:length(fls.input(handles.kt_wej).mf);
        Mf_ed_str(k) = cellstr(fls.input(handles.kt_wej).mf(k).name);
    end
    set(handles.Mf_ed_pop,'String',Mf_ed_str);
    
    %sprawdzenie ile jest mf i zablokowanie usuwania jezeli 1
    if (length(get(handles.Mf_ed_pop,'String')) == 1)
        set(handles.usun_mf,'Enable','off');
    else
        set(handles.usun_mf,'Enable','on');
    end  
    
        %odczytanie zakresu
    rang = fls.input(handles.kt_wej).range;
    %rysowanie ramki u gory
    %%%%%Ustawianie podzia³ki x oraz y wykresu
    xlim([rang(1) rang(2)]);
    txtCol = [0.6 0.8 0.99];
    patch([rang(1) rang(1) rang(2) rang(2)],[1.2 1.4 1.4 1.2],txtCol);
    %x = 0:0.01:1;
    x = linspace(rang(1),rang(2),101);
    
    for j = 1:length(fls.input(handles.kt_wej).mf)
        
        %Nazwa wybranego wejscia
        txtStr = fls.input(handles.kt_wej).name;
        txtCol = [0.6 0.8 0.99];
        
        
        set(handles.nazwa_wejscie,'String',txtStr, ...
                    'BackgroundColor',txtCol, ...
                    'FontWeight','bold','FontSize',17);
        
       %podpisy nad funkcjami przynaleznosci
       
        txtStr = num2str(fls.input(handles.kt_wej).mf(j).name);
        
        %cellstr do pola Mf_ed_pop - nazwy mf
        mfStr(j,1) = cellstr(fls.input(handles.kt_wej).mf(j).name);

        
        %pobranie parametrow funkcji

        parametr = fls.input(handles.kt_wej).mf(j).params;
        [dolnaz,gornaz] = feval(fls.input(handles.kt_wej).mf(j).type,x,parametr);
        
        if zslices_val == 0 
            dolna = dolnaz;
            gorna = gornaz;
        else
            dolna = mean([dolnaz; gornaz],1)+(mean([dolnaz; gornaz],1)-dolnaz)*1/zslices_num*(zslices_num-zslices_val);
            gorna = mean([dolnaz; gornaz],1)-(gornaz - mean([dolnaz; gornaz],1))*1/zslices_num*(zslices_num-zslices_val);
        end


        [X,Y,Col] = plotmf2(x,dolna,gorna);
        Col = Col.*[0 1 0]+[0 0 0.5];
        patch(X,Y,Col,'EdgeLighting','gouraud','LineWidth',3);
        hold on;
                

        
        %wspolrzedna srodka podpisu funkcji
%         [max_g,mid_i] = max(Y);
%         mid = mid_i/length(gorna);
%        
%             if mid <= (rang(1)+0.05) 
%                 txtWsp = (rang(1)+0.05) ;
% 
%             elseif mid >= (rang(2)-0.1)  
%                 txtWsp = (rang(2)-0.1)  ;
%             else 
%                 txtWsp = mid;
%             end
        %wspolrzedna srodka podpisu funkcji
        [max_g,mid_i] = max(Y);
        mid = X(mid_i);
       
            if mid <= (rang(1)+0.05) 
                txtWsp = (rang(1)+0.1*(rang(2)-rang(1))) ;

            elseif mid >= (rang(2)-0.1)  
                txtWsp = (rang(2)-0.15*(rang(2)-rang(1)))  ;
            else 
                txtWsp = mid-0.1*(rang(2)-rang(1));
            end

            
        handles.wejTxt = text(txtWsp,1.1,txtStr,'FontSize',8);
        guidata(hObject,handles);        


        handles.wejTxt = text(txtWsp,1.1,txtStr,'FontSize',8);
        guidata(hObject,handles);
%         if get(handles.Mf_ed_pop,'Value') == j
%             set(handles.wejTxt,'Color','r','FontSize',12);
%         end
    end %koniec petli mf
   
    %wpisanie do pola naz_zmien
    set(handles.naz_zmien,'String',fls.input(handles.kt_wej).name);
    
    %wpisanie do pola Mf_ed_pop
    set(handles.Mf_ed_pop,'String',mfStr);

    %%%%%Wypisanie w polach - wejscie i wyjscie
    for k = 1:length(fls.input);
        wejsciaTxt(k) = cellstr(fls.input(k).name);
    end
    set(handles.Mf_ed_pop,'String',Mf_ed_str);

    set(handles.Wejscia_ed_pop,'String',wejsciaTxt);
    
    for k = 1:length(fls.output);
        wyjsciaTxt(k) = cellstr(fls.output(k).name);
    end    
    
    set(handles.Wyjscia_ed_pop,'String', wyjsciaTxt);
    
    writefis(fls,nazwa);
    
    %wpisanie do pola zak
    zak = fls.input(handles.kt_wej).range;
    zak = num2str(zak);
    zak = [' [' zak '] '];
    set(handles.zak,'String',zak);
    set(handles.wysw_zak,'String',zak);
    
    mf_typ_str = get(handles.mf_typ,'String');
        %Wybranie w polu mf_typ odpowiedniej wartosci

    if handles.kt_wej < 5
        mf_val = strcmp(fls.input(handles.kt_wej).mf(get(handles.Mf_ed_pop,'Value')).type,mf_typ_str);
    elseif handles.kt_wej >= 5
        mf_val = strcmp(fls.output(handles.kt_wej-4).mf(get(handles.Mf_ed_pop,'Value')).type,mf_typ_str);
    end
        typ_val = find(mf_val);
    set(handles.mf_typ,'value',typ_val);


    set(handles.mf_typ,'Value',typ_val);
    %handles.parametr = fls.input(handles.kt_wej).mf(mf_param_val).params;
    handles.param_case = 1;
    guidata(hObject,handles);    
    mf_param_Callback(hObject,eventdata,handles);
   %mf_param_Callback(hObject, fls.input(handles.kt_wej).mf(mf_param_val).params, handles);
  

%     [dolna,gorna] = feval(fls.input(1).mf(i).type,x,param);
%     [X,Y,Col] = plotmf2(x,dolna,gorna);
%     patch(X,Y,Col);

   


% --- Executes on selection change in Wyjscia_ed_pop.
function Wyjscia_ed_pop_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function Wyjscia_ed_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Wyjscia_ed_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%% Wyjscia rysuj callback

% --- Executes on button press in Wyjscia_rysuj.
function Wyjscia_rysuj_Callback(hObject, eventdata, handles)


handles = guidata(gcf); %wczytanie handles
nazwa = handles.nazwa; %pobranie nazwy fis
fls=readfis(nazwa); %wczytanie aktualnego fis
%handles.kt_wej = handles.kt_wej


%odczyt wartosci zslice z handles
zslices_num = handles.zslices;
zslices_val = get(handles.zslices_slider,'Value');


%odczytanie które wyjscie jest wybrane
handles.kt_wej = get(handles.Wyjscia_ed_pop,'Value'); %sprawdzenie ktore wejscie dziala
%dodaje wartosc 4 do handles.kt_wej zeby wiadomobylo ze to wyjscie (nie ma to
%innego zastosowania
handles.kt_wej = handles.kt_wej+4; % wyjscia >4
%czyszczenie axes
    cla;

    %czyszczenie pola parametrow

    set(handles.mf_param,'String','');   %pole parametry = ''  


    
    
%     if strcmp(zad,'#zmiana_enter 3')
        %mf_param_pom = handles.enter_str; %zm pom wpisany str?
       % kt_mf = get(handles.Mf_ed_pop,'Value'); %obecny mf
       % writefis(fls,nazwa); 
       % co_robic = '';
%     end
    
        %mf_param_pom = handles.enter_str;
        %kt_mf = get(handles.Mf_ed_pop,'Value');
        %fls.output(handles.kt_wej-4).mf(kt_mf).params = mf_param_pom;
    %odczytanie zakresu
    rang = fls.output(handles.kt_wej-4).range; %zakres 
    %rysowanie ramki u gory
    xlim([rang(1) rang(2)]);%os x -zakres
    txtCol = [0.9 0.5 0.7]; % kolor
    patch([rang(1) rang(1) rang(2) rang(2)],[1.2 1.4 1.4 1.2],txtCol); %zakres '³aty'
    x = linspace(rang(1),rang(2),101); %odstep liniowy
    
    %Nazwa wybranego wyjscia
    
    txtStr = num2str(fls.output(handles.kt_wej-4).name); %nazwa wyjscia numer handles.kt_wej-4
    txtCol = [0.9 0.5 0.7];
    
            set(handles.nazwa_wejscie,'String',txtStr, ...
                    'BackgroundColor',txtCol, ...
                    'FontWeight','bold','FontSize',17);
   
    
    temp_val = get(handles.Wyjscia_ed_pop,'Value');
    temp_str = get(handles.Wyjscia_ed_pop,'String');
    n = length(fls.output(handles.kt_wej-4).mf);
    
    %zdefiniowanie wartosci obecnie wykonywanego wyjscia w zmiennej
    %pomocniczej >4 oznacza wyjscie
    handles.kt_wej = 5;
    guidata(hObject,handles);
    
    
    for i=1:length(fls.output(handles.kt_wej-4).mf)     
        parametr = fls.output(handles.kt_wej-4).mf(i).params;
        [dolnaz,gornaz] = feval(fls.output(handles.kt_wej-4).mf(i).type,x,parametr);
        
        if zslices_val == 0 
            dolna = dolnaz;
            gorna = gornaz;
        else
            dolna = mean([dolnaz; gornaz],1)+(mean([dolnaz; gornaz],1)-dolnaz)*1/zslices_num*(zslices_num-zslices_val);
            gorna = mean([dolnaz; gornaz],1)-(gornaz - mean([dolnaz; gornaz],1))*1/zslices_num*(zslices_num-zslices_val);
        end
        
        [X,Y,Col] = plotmf2(x,dolna,gorna);
        Col = Col.*[1 0 0]+[0 0 0.5];
        patch(X,Y,Col,'EdgeLighting','gouraud','LineWidth',3);
        hold on;      
        
        %podpisy nad funkcjami przynaleznosci
       
        txtStr = num2str(fls.output(handles.kt_wej-4).mf(i).name);  %podpis na mf
        
        %pobranie parametrow funkcji
        
        parametr = fls.output(handles.kt_wej-4).mf(i).params;       %parametry mf
        [dolna,gorna] = feval(fls.output(handles.kt_wej-4).mf(i).type,x,parametr); %generacja funkcji
        
               [max_g,mid_i] = max(Y);
        mid = X(mid_i);
       
            if mid <= (rang(1)+0.05) 
                txtWsp = (rang(1)+0.1*(rang(2)-rang(1))) ;

            elseif mid >= (rang(2)-0.1)  
                txtWsp = (rang(2)-0.15*(rang(2)-rang(1)))  ;
            else 
                txtWsp = mid-0.1*(rang(2)-rang(1));
            end

            
        handles.wejTxt = text(txtWsp,1.1,txtStr,'FontSize',8);
        guidata(hObject,handles);        
        
        %str nazw mf
        mfStr(i,1) = cellstr(fls.output(handles.kt_wej-4).mf(i).name);
% 
%         if get(handles.Mf_ed_pop,'Value') == j
%             set(handles.wejTxt,'Color','r','FontSize',12);
%         end
    
    end %koniec petli rysujacej mf

    %sprawdzenie ile jest mf i zablokowanie usuwania jezeli 1
    if (length(get(handles.Mf_ed_pop,'String')) == 1)
        set(handles.usun_mf,'Enable','off');
    else
        set(handles.usun_mf,'Enable','on');
    end
    
    %wpisanie do pola naz_zmien
    set(handles.naz_zmien,'String',fls.output(handles.kt_wej-4).name); %wpisanie do pola nazwy wyjscia
    %wpisanie do listy Mf_ed_pop
    set(handles.Mf_ed_pop,'String',mfStr);

    %%%%%Wypisanie w polach - wejscie i wyjscie
    for k = 1:length(fls.input);
        wejsciaTxt(k) = cellstr(fls.input(k).name);
    end
    %set(handles.Mf_ed_pop,'String',Mf_ed_str);

    set(handles.Wejscia_ed_pop,'String',wejsciaTxt);
    
    for k = 1:length(fls.output);
        wyjsciaTxt(k) = cellstr(fls.output(k).name);
    end    
    
    set(handles.Wyjscia_ed_pop,'String', wyjsciaTxt);
    
    writefis(fls,nazwa);
    
    
    %     for k = 1:length(fls.input);
%         wejsciaTxt(k) = cellstr(fls.input(k).name);
%     end
%     wejsciaTxt = [cellstr(fls.input(1).name); cellstr(fls.input(2).name)];
%     set(handles.Wejscia_ed_pop,'String',wejsciaTxt);
%     
%     set(handles.Wyjscia_ed_pop,'String',fls.output(1).name);
%     
%     writefis(fls,nazwa);
    


    %wpisanie do pola zak
    zak = fls.output(handles.kt_wej-4).range;
    zak = num2str(zak);
    zak = [' [' zak '] '];
    set(handles.zak,'String',zak);
    set(handles.wysw_zak,'String',zak);
    
     mf_typ_str = get(handles.mf_typ,'String');
        %Wybranie w polu mf_typ odpowiedniej wartosci
    if handles.kt_wej <= 4
        mf_val = strcmp(fls.input(handles.kt_wej).mf(get(handles.Mf_ed_pop,'Value')).type,mf_typ_str);
    elseif handles.kt_wej > 4
        mf_val = strcmp(fls.output(handles.kt_wej-4).mf(get(handles.Mf_ed_pop,'Value')).type,mf_typ_str);
    end
        typ_val = find(mf_val);
    set(handles.mf_typ,'value',typ_val);
    
   mf_param_val = get(handles.Mf_ed_pop,'Value');
   %parametr = fls.output(handles.kt_wej-4).mf(mf_param_val).params;
   handles.param_case = 1;
   guidata(hObject,handles);
   mf_param_Callback(hObject, eventdata, handles);



% --- Executes on selection change in Mf_ed_pop.
function Mf_ed_pop_Callback(hObject, eventdata, handles)

handles = guidata(gcf);
nazwa = handles.nazwa;
fls=readfis(nazwa);

%odczytanie wartosci mf
Mf_ed_str = get(handles.Mf_ed_pop,'String');
Mf_ed_val = get(handles.Mf_ed_pop,'Value');
Mf_obecny_str = Mf_ed_str(Mf_ed_val);
%odczytanie obecnego wejscia/wyjscia
   
    %odczytanie prametrow i odczytanie ktora nazwa mf
    if handles.kt_wej <= 4
            mf_param_pom = fls.input(handles.kt_wej).mf(Mf_ed_val).params;
            mf_nazwa_pom = fls.input(handles.kt_wej).mf(Mf_ed_val).name;
            mf_typ = fls.input(handles.kt_wej).mf(Mf_ed_val).type;
            
    else
            mf_param_pom = fls.output(handles.kt_wej-4).mf(Mf_ed_val).params;
            mf_nazwa_pom = fls.output(handles.kt_wej-4).mf(Mf_ed_val).name;
            mf_typ = fls.output(handles.kt_wej-4).mf(Mf_ed_val).type;
    end
    
    %zapis w strukturze
    parametry = mf_param_pom;
    
    %ustawienie paramaetrow w mf_param
    %wyslanie do funkcji bo ona ladnie to wpisuje
    handles.param_case = 2;
    guidata(hObject,handles);
    mf_param_Callback(hObject, parametry, handles);                                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %ustawienie nazwy w mf_nazwa
    set(handles.mf_nazwa,'String',mf_nazwa_pom);
    %ustawienie mf_typ
    
    temp_str = get(handles.mf_typ,'String');
    typ_cmp = strcmp(mf_typ,temp_str);
    typ_val = find(typ_cmp);
    set(handles.mf_typ,'Value',typ_val);
    
    
    guidata(hObject,handles);
    





% --- Executes during object creation, after setting all properties.
function Mf_ed_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mf_ed_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close edycja.
function edycja_CloseRequestFcn(hObject, eventdata, handles)
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


% --- Executes on button press in Info.
function Info_Callback(hObject, eventdata, handles)
% hObject    handle to Info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in wyjscie.
function wyjscie_Callback(hObject, eventdata, handles)
edycja_CloseRequestFcn(hObject, eventdata, handles);

%% zakres callback

function zak_Callback(hObject, eventdata, handles)
% wpisywanie nowych wartosci 
    handles = guidata(gcf);
    nazwa = handles.nazwa;
    fls=readfis(nazwa);
    
    
    if  handles.kt_wej  <= 4
        str_nw = get(handles.zak,'String');
        str_nw = str2num(str_nw);
        fls.input(handles.kt_wej).range = str_nw;
        writefis(fls,nazwa);
        handles.kt_wej = 1;
        guidata(hObject,handles);
        Wejscia_rysuj_Callback(hObject, eventdata, handles);

    else
        str_nw = get(handles.zak,'String');
        str_nw = str2num(str_nw);
        fls.output(handles.kt_wej-4).range = str_nw;
        writefis(fls,nazwa);
        handles.kt_wej = 5;
        guidata(hObject,handles);
        Wyjscia_rysuj_Callback(hObject, eventdata, handles);
        %handles.kt_wej = '';
    end
    writefis(fls,nazwa);

% --- Executes on key press with focus on zak and none of its controls.
function zak_KeyPressFcn(hObject, eventdata, handles)
% wpisywanie nowych wartosci 
    handles = guidata(gcf); 
    nazwa = handles.nazwa;
    fls=readfis(nazwa);
     
     
    %odczytanie klawisza - jezeli ktos wcisnie enter/return to ma sie
    %zapisywac i odczytywac od razu w okienku do wpisywania
     klaw = get(gcf, 'CurrentKey');
     
if strcmp(klaw,'return')
    
    if handles.kt_wej <= 4 
                %ta funkcja narysuje nowe mf i przy okazji wpisze param
                handles.kt_wej = handles.kt_wej;
                guidata(hObject,handles);
               

    else
                %ta funkcja narysuje nowe mf i przy okazji wpisze param
                handles.kt_wej = handles.kt_wej;
                guidata(hObject,handles);
    end

    zak_Callback(hObject, eventdata, handles);
%   
else
    return;
       
end

guidata(hObject,handles);


% --- Executes on slider movement.
function zslices_slider_Callback(hObject, eventdata, handles)
    handles = guidata(gcf); 
    nazwa = handles.nazwa;
    fls=readfis(nazwa);
    zslices_val = get(handles.zslices_slider,'Value');
    set(handles.zslices_val,'String',num2str(zslices_val/handles.zslices));
    Wejscia_rysuj_Callback(hObject, eventdata, handles);
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


% --- Executes on button press in dodaj_mf.
function dodaj_mf_Callback(hObject, eventdata, handles)
    handles = guidata(gcf); 
    nazwa = handles.nazwa;
    fls=readfis(nazwa);
    if handles.kt_wej > 4
        typZm = 'output';
        indeks = handles.kt_wej-4;
        nazwaMf = ['mf' num2str(length(fls.output(handles.kt_wej-4).mf))+1];
    else
        typZm = 'input';
        indeks = handles.kt_wej;
            nazwaMf = ['mf' num2str(length(fls.input(handles.kt_wej).mf))+1];
    end


    fls = dodajmftypu2(fls,typZm,indeks,nazwaMf,'gaussmftype2',fls.input(1).mf(1).params);
    if handles.kt_wej > 4
    writefis(fls,nazwa);    
    guidata(hObject,handles); 
    Wyjscia_rysuj_Callback(hObject, eventdata, handles);
 
  
    %Wej_ed(nazwa);
    else
        
    writefis(fls,nazwa);    
    guidata(hObject,handles);
    %Wej_ed(nazwa);
    Wejscia_rysuj_Callback(hObject, eventdata, handles);
    end
   



% --- Executes on button press in usun_mf.
function usun_mf_Callback(hObject, eventdata, handles)
    handles = guidata(gcf); 
    nazwa = handles.nazwa;
    fls=readfis(nazwa);
    kt_wej = handles.kt_wej;
    kt_mf = get(handles.Mf_ed_pop,'val');
    


    if handles.kt_wej > 4

            if kt_mf == length(fls.output(kt_wej-4).mf)
                fls.output(kt_wej-4).mf = fls.output(kt_wej-4).mf(1:kt_mf-1);
                        %set(handles.Mf_ed_pop,'Value',kt_mf-1);
            else 
                fls.output(kt_wej-4).mf = fls.output(kt_wej-4).mf([1:kt_mf-1 kt_mf+1:end]);
            end

    %tworzenie nowej listy
    %for i = 1:length(fls.output(kt_wej-4).mf
    %    mfList(i) = cellstr(fls.output(i).name)
    %end
    %set(handles.wyj_list,'String',wyjsciaList); 
    writefis(fls,nazwa);     
    for i =1:length(fls.output(kt_wej-4).mf)
        mfList(i) = cellstr(fls.output(kt_wej-4).mf(i).name);
    end
    
    set(handles.Mf_ed_pop,'String',mfList);
    
    writefis(fls,nazwa);    
    guidata(hObject,handles);
    %Wej_ed(nazwa);
    Wyjscia_rysuj_Callback(hObject, eventdata, handles);     
    else
        
    if kt_mf == length(fls.input(kt_wej).mf)
        fls.input(kt_wej).mf = fls.input(kt_wej).mf(1:kt_mf-1);
        %set(handles.Mf_ed_pop,'Value',val-1);
    else 
        fls.input(kt_wej).mf = fls.input(kt_wej).mf([1:kt_mf-1 kt_mf+1:end]);
    end        
    writefis(fls,nazwa);     
    for i =1:length(fls.input(kt_wej).mf)
        mfList(i) = cellstr(fls.input(kt_wej).mf(i).name);
    end
    
    set(handles.Mf_ed_pop,'String',mfList);
    
        writefis(fls,nazwa);    
    guidata(hObject,handles);
    %Wej_ed(nazwa);
    Wejscia_rysuj_Callback(hObject, eventdata, handles); 
    end
   

