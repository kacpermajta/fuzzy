function IT2FLS(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%IT2FLS
%   Funkcja sluzy do wywolywania toolboxa fuzzy 2
%   
%     Argumenty:
%     nazwa - nazwa aktualnego fis
%     nowyFls - pomocniczy arg. do utworzenia nowego fis
%     (B)varargin - argument wejsciowy/wyjsciowy
%     temp_val - pomocnicza wartosc 
%     temp_str - tymczasowa tablica stringow
%     str - string okreslony za pomoca 2 powyzszych arg.
%     I - macierz 0/1 okrelajaca identycznosc stringow
%     ind - indeks wartosci 1 w powyzszej tabeli
%     fls - zmienna w ktorej zapisany jest aktualny fis
%     klaw - arg. w ktorym zapisywany jest aktualnie wcisniety klawisz
%     plik - nazwa zapisywanego pliku
%     sciezka - sciezka dostepu do arg. plik
%     hObject - aktualny obiekt
%     eventdata - nie uzywane
%     handles - struktura zawierajaca wszystkie obiekty i ich zmienne
%     
%     Funkcja zwraca:
%     varargin
%     jest to nazwa obecnego fis
%     
%     Uzywane funkcje:
%     Surf
%     Wej_ed
%     Pod_reg
%     Baza_regul
%     Wszystkie wywolania (Callback) do listbox, textbox, popup etc.
%     ktore pomimo ze sa zapisane w tym pliku jako osobne funkcje stanowia
%     integralna czesc tej funkcji poprzez plik IT2FLS.fig
%     
%     Uzywane zmienne:
%     varargin
%     
%     Uwagi:
%     Plik/funkcja mocno powiazana z plikiem IT2FLS.fig - w nim zapisana jest 
%     konfiguracja graficzna wygladu GUI a takze powiazanie funkcji callback
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
%% 

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IT2FLS_OpeningFcn, ...
                   'gui_OutputFcn',  @IT2FLS_OutputFcn, ...
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


%% OPENING FUNCTION


    function IT2FLS_OpeningFcn(hObject, eventdata, handles, varargin)

    % tworzenie obiektu wejscia i wyjscia w nowym gui
    if isempty(varargin)
        nazwa = 'bez_nazwy';
        handles.nazwa = nazwa;
       nowyFls=nowyflstypu2(nazwa);
       nowyFls=dodajzmiennatypu2(nowyFls,'input','wejscie1',[0 1]);
       nowyFls=dodajzmiennatypu2(nowyFls,'input','wejscie2',[0 1]);
       nowyFls=dodajzmiennatypu2(nowyFls,'output','wyjscie1',[0 1]);
 
       
       varargin=nowyFls;
        % Zapisanie danych fis w macierzy jako fls
        fls = varargin;
         %%%%%Wypisanie w polach - nazwa fis i typ fis prawdziwych danych
    set(handles.naz_fis_txt,'String',nazwa);
%    set(handles.typ_fis_txt,'String',fls.type);
  
%ilosc zsclices
            handles.zslices = 0;
            
            assignin('base','zslices',handles.zslices);                
 %%%%%Wczytanie danych z pol met_sum_pop,met_il_pop,wyn_pop,defuz_pop,zbier_pop  
 %%%%%met_sum_pop 
    temp_val = get(handles.met_sum_pop,'Value');
    temp_str = get(handles.met_sum_pop,'String');
    str = temp_str{temp_val};
   
    fls.andMethod = str;
   
%%%%%typ_fis_txt %KVM
    temp_val = get(handles.typ_fis_txt,'Value');
    temp_str = get(handles.typ_fis_txt,'String');
    str = temp_str{temp_val};
   
    fls.type = str;
    
 %%%%%met_il_pop
    temp_val = get(handles.met_il_pop,'Value');
    temp_str = get(handles.met_il_pop,'String');
    str = temp_str{temp_val};
   
    fls.orMethod = str;
    
 %%%%%wyn_pop
    temp_val = get(handles.wyn_pop,'Value');
    temp_str = get(handles.wyn_pop,'String');
    str = temp_str{temp_val};
   
    fls.impMethod = str;
    
 %%%%%defuz_pop
   
    cd( setflspath());
    %%%przeskanowac folder metody
    lista_metod = ls('Metody');
    lista_metod=cellstr(lista_metod);
    lista_metod = lista_metod(3:end);
    lista_metod = char(lista_metod);
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
    
    
    if strcmp(fls.type,'mamdani')
        set(handles.defuz_pop,'String',lista_metod);
        temp_val = get(handles.defuz_pop,'Value');
        temp_str = get(handles.defuz_pop,'String');
        str = temp_str{temp_val};

        fls.defuzzMethod = str;
    else
        fls.defuzzMethod ='wtaver';
    end
        
 %%%%%zbier_pop
    temp_val = get(handles.zbier_pop,'Value');
    temp_str = get(handles.zbier_pop,'String');
    str = temp_str{temp_val};

    else
        nazwa= varargin;
        nazwa = char(nazwa);
        fls = readfis(nazwa);
        handles.nazwa = nazwa;
        guidata(hObject,handles);
        fls.name = nazwa;
        set(handles.naz_fis_txt,'String','');
        %ustawianie wartosci okienek 
        set(handles.naz_fis_txt,'String',handles.nazwa);
        
        %typ_fis_txt %KVM
        temp_str = get(handles.typ_fis_txt,'String');
        I = strcmp(fls.type,temp_str);
        ind = find(I);
        set(handles.typ_fis_txt,'Value',ind);

        %met_sum_pop
        temp_str = get(handles.met_sum_pop,'String');
        I = strcmp(fls.andMethod,temp_str);
        ind = find(I);
        set(handles.met_sum_pop,'Value',ind);
        %met_il_pop
        temp_str = get(handles.met_il_pop,'String');
        I = strcmp(fls.orMethod,temp_str);
        ind = find(I);
        set(handles.met_il_pop,'Value',ind);    
        %wyn_pop
        temp_str = get(handles.wyn_pop,'String');
        I = strcmp(fls.impMethod,temp_str);
        ind = find(I);
        set(handles.wyn_pop,'Value',ind); 
        %defuz_pop - skanuj folder w poszukiwaniu metod
        path = which('IT2FLS','-all');
        path_c = char(path);
        path_u = uint8(path_c);
        path_u = path_u(1:end-8);
        path_c = char(path_u);
        cd(path_c);
        temp_str = get(handles.defuz_pop,'String');
        I = strcmp(fls.defuzzMethod,temp_str);
        ind = find(I);
        set(handles.defuz_pop,'Value',ind); 
        %zbier_pop
        temp_str = get(handles.zbier_pop,'String');
        I = strcmp(fls.aggMethod,temp_str);
        ind = find(I);
        set(handles.zbier_pop,'Value',ind);        
    end
      
%%%%%ilosc wejsc textbox
        ilosc_wej_str = ['Ilosc wejsc ', num2str(length(fls.input))];
        ilosc_wyj_str = ['Ilosc wyjsc ', num2str(length(fls.output))];
        set(handles.ilosc_wej_txt,'String',ilosc_wej_str); 
        set(handles.ilosc_wyj_txt,'String',ilosc_wyj_str);
       



 %%%%%zapisanie obecnego fis do tymczasowego pliku w celu odczutu w innym
 %%%%%gui
  writefis(fls,nazwa);
  guidata(hObject,handles);
    % Choose default command line output for IT2FLS
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);
    
    % UIWAIT makes IT2FLS wait for user response (see UIRESUME)
    % uiwait(handles.glowne);

    %% OUTPUT FUNCTION
    
    
% --- Outputs from this function are returned to the command line.
function varargout = IT2FLS_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;
handles.output = hObject;


%% 
    %====================================
    %%%%%Wygenerowane przez guide

    % --- Executes on selection change in Wej_pop.
    function Wej_pop_Callback(hObject, eventdata, handles)


    % --- Executes during object creation, after setting all properties.
    function Wej_pop_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


    % --- Executes on selection change in Wyj_pop.
    function Wyj_pop_Callback(hObject, eventdata, handles)

    % --- Executes during object creation, after setting all properties.
    function Wyj_pop_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



% --- Executes on key press with focus on Wej_ed and none of its controls.
function Wej_ed_KeyPressFcn(hObject, eventdata, handles)


% --- Executes on button press in Wej_ed.
function Wej_ed_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function Plik_gl_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Edycja_gl_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Wstecz_gl_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Nowy_FIS_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Import_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Eksport_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Zamknij_gl_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Mamdami_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Sugeno_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Dodaj_zmienna_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Wejscie_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Wyjscie_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Plaszczyzna_Callback(hObject, eventdata, handles)
        nazwa = handles.nazwa;
        fls = readfis(nazwa);
        writefis(fls,nazwa);
        Surf(nazwa);
    

%% OKNA 
% --------------------------------------------------------------------
function Pod_reg_Callback(hObject, eventdata, handles)
        nazwa = handles.nazwa;
        fls = readfis(nazwa);
        writefis(fls,nazwa);
        Pod_reg(nazwa);
        
function dodaj_zm_Callback(hObject, eventdata, handles)
        nazwa = handles.nazwa;
        fls = readfis(nazwa);
        writefis(fls,nazwa);
        Dodawanie_wejsc(nazwa);

% --- Executes on selection change in met_sum_pop.
function met_sum_pop_Callback(hObject, eventdata, handles)
    nazwa = handles.nazwa;
    fls = readfis(nazwa);
    str = get(handles.met_sum_pop,'String');
val = get(handles.met_sum_pop,'Value');
str = str{val};
if strcmp(str,'min')
fls.andMethod = str;
else
    fls.andMethod = 'prod';
end
writefis(fls,nazwa);
guidata(hObject,handles);

%% POP UPY
% --- Executes during object creation, after setting all properties.
function met_sum_pop_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in met_il_pop.
function met_il_pop_Callback(hObject, eventdata, handles)
    nazwa = handles.nazwa;
    fls = readfis(nazwa);
    str = get(handles.met_il_pop,'String');
val = get(handles.met_il_pop,'Value');
str = str{val};
if strcmp(str,'max')
fls.orMethod = str;
else
    fls.orMethod = 'probor';
end
writefis(fls,nazwa);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function met_il_pop_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in wyn_pop.
function wyn_pop_Callback(hObject, eventdata, handles)
nazwa = handles.nazwa;
    fls = readfis(nazwa);
str = get(handles.wyn_pop,'String');

if strcmp(fls.type,'mamdani')

    val = get(handles.wyn_pop,'Value');
    str = str{val};
    if strcmp(str,'min')
    fls.impMethod = str;
    else
        fls.impMethod = 'prod';
    end
else
    fls.impMethod = 'prod';
    set(handles.wyn_pop,'Value',2);
end

 writefis(fls,nazwa);
 guidata(hObject,handles);

    
% --- Executes during object creation, after setting all properties.
function wyn_pop_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in zbier_pop.
function zbier_pop_Callback(hObject, eventdata, handles)
nazwa = handles.nazwa;
    fls = readfis(nazwa);
str = get(handles.zbier_pop,'String');
if strcmp(fls.type,'mamdani')

    val = get(handles.zbier_pop,'Value');
    str = str{val};


    if strcmp(str,'max')
        fls.aggMethod = str;
    elseif strcmp(str,'probor')
        fls.aggMethod = 'probor';
    else
        fls.aggMethod='sum';
    end
else
    fls.aggMethod = 'sum';
    set(handles.zbier_pop,'Value',3);

end
writefis(fls,nazwa);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function zbier_pop_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in defuz_pop.
function defuz_pop_Callback(hObject, eventdata, handles)
nazwa = handles.nazwa;
    fls = readfis(nazwa);
    str = get(handles.defuz_pop,'String');
val = get(handles.defuz_pop,'Value');
str = str{val};
% if strcmp(str,'centroid')
if strcmp(fls.type,'mamdani')
 fls.defuzzMethod = str;
end
% elseif strcmp(str,'csum')
%     fls.defuzzMethod = 'csum';
% elseif strcmp(str,'cos')
% elseif strcmp(str,'md_height')
%     fls.defuzzMethod = 'md_height';
% elseif strcmp(str,'height')
%     fls.defuzzMethod = 'height';
% end
writefis(fls,nazwa);
guidata(hObject,handles);
  


% --- Executes on selection change in typ_fis_txt.
function typ_fis_txt_Callback(hObject, eventdata, handles)
    nazwa = handles.nazwa;
    fls = readfis(nazwa);
    str = get(handles.typ_fis_txt,'String');
val = get(handles.typ_fis_txt,'Value');
str = str{val};
IleWyjsc=length(fls.output);
if strcmp(str,'mamdani')
    fls.type = str;
    
    temp_val = get(handles.defuz_pop,'Value');
    temp_str = get(handles.defuz_pop,'String');
    str = temp_str{temp_val};

    fls.defuzzMethod = str;
else
    fls.type = 'sugeno';
    fls.defuzzMethod ='wtaver';
    set(handles.zbier_pop,'Value',3);%agregacja/zbieranie: sum
    set(handles.wyn_pop,'Value',2);%implikacja: prod
    
    
end
fls.rule=[];
fls.output=[];
if IleWyjsc>0
    fls=dodajzmiennatypu2(fls,'output','wyjscie1',[0 1]);
end
if IleWyjsc>1
    fls=dodajzmiennatypu2(fls,'output','wyjscie2',[0 1]);
end

writefis(fls,nazwa);

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function typ_fis_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to typ_fis_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% POLA TEKSTOWE

 function naz_fis_txt_Callback(hObject, eventdata, handles)
       nazwa = handles.nazwa;
     fls = readfis(nazwa); 
     klaw = get(gcf, 'CurrentKey');
  
if strcmp(klaw,'return')
       
       fls_name = get(handles.naz_fis_txt,'String');
       set(handles.naz_fis_txt,'String',fls_name);
       fls.name = fls_name;
       handles.nazwa = fls_name;
       writefis(fls,fls_name);
       
       guidata(hObject,handles);
else
    return;
end


% --- Executes during object creation, after setting all properties.
function naz_fis_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to naz_fis_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
   
    
    
% --- Executes during object creation, after setting all properties.
function defuz_pop_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in wejscia_pop.
function wejscia_pop_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function wejscia_pop_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in wyjscia_pop.
function wyjscia_pop_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function wyjscia_pop_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function naz_zm_main_Callback(hObject, eventdata, handles)
% hObject    handle to naz_zm_main (see GCBO)
hndl=findobj(obecnyWyk,'Type','uicontrol','Tag','naz_zm_main');
    set(hndl,'String',' ');

% --- Executes during object creation, after setting all properties.
function naz_zm_main_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function typ_zm_main_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function typ_zm_main_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zak_zm_main_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function zak_zm_main_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% BUTTONY

% --- Executes on button press in info.
function info_Callback(hObject, eventdata, handles)
fprintf('        Praca magisterska\n');
fprintf('        Autor:                 Marcin Mik³as\n');
fprintf('        Specjalnosc:           Automatyka i Metrologia\n');

fprintf('        Temat:                 Oprogramowanie s³u¿¹ce do badañ nad regulatorami rozmytymi typu 2\n');
fprintf('        Promotor:              dr inz. Ireneusz Dominik\n');
fprintf('        Ostatnia modyfikacja:  14.07.2014r.\n');
msgbox(['Praca magisterska                                             ',...
        '       Autor:                     Marcin Mik³as                           ',...
        '       Specjalnosc:          Automatyka i Metrologia                     ',...
        '       Temat:                   Oprogramowanie s³u¿¹ce do badañ nad regulatorami                                   rozmytymi typu 2                                                ',...
        '       Promotor:               dr inz. Ireneusz Dominik                                                                  ',...
        '       Ostatnia modyfikacja:  14.07.2014r.                    '],'Informacje');


% --- Executes on button press in wyjscie_all.
function wyjscie_all_Callback(hObject, eventdata, handles)
glowne_CloseRequestFcn(hObject, eventdata, handles);

                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Zamykanie Gui
%%%%% Executes when user attempts to close glowne.
function glowne_CloseRequestFcn(hObject, eventdata, handles)
selection = questdlg('Czy chcesz zapisaæ przebieg pracy?','Close Request Function','Tak','Nie','Anuluj','Anuluj');
nazwa = handles.nazwa;
fls = readfis(nazwa);
    switch selection
        case 'Tak'
            [plik,sciezka] = uiputfile('*.mat','Zapisz jako');
            delete(gcf);
        case 'Nie'
            delete(gcf);
        case 'Anuluj'
            return;
    end


% --------------------------------------------------------------------
function Z_pliku_Callback(hObject, eventdata, handles)
[nazwa,sciezka] = uigetfile('*.mat','Wczytaj plik');
    if isequal(nazwa,0) || isequal(sciezka,0)
       disp('Anulowano')
    else
        disp(['Wybrano ', fullfile(nazwa, path)])
        fls = importdata(nazwa);
        
        writefis(fls,fls.name);
      
       fls.name = char(fls.name);
        IT2FLS(fls.name);
    end



% --------------------------------------------------------------------
function Z_workspace_Callback(hObject, eventdata, handles)
Z_workspace;
    %fls = evalin('base',fls);


% --------------------------------------------------------------------
function Do_pliku_Callback(hObject, eventdata, handles)
nazwa = handles.nazwa;
    fls = readfis(nazwa);
    assignin('base','fls',fls);
[plik,sciezka] = uiputfile('*.mat','Zapisz jako');

save(plik,'fls');
    if isequal(plik,0) || isequal(sciezka,0)
       disp('Anulowano');
    else
       disp(['Wybrano ', fullfile(plik, sciezka)]);
    end


% --------------------------------------------------------------------
function Do_workspace_Callback(hObject, eventdata, handles)
    fls = readfis(handles.nazwa);
%save('fls');
    assignin('base','fls',fls);


% --- Executes on button press in wej_push.
function wej_push_Callback(hObject, eventdata, handles)
    handles = guidata(hObject);
    nazwa = handles.nazwa;
    fls = readfis(nazwa);

      Wej_ed(nazwa);



% --- Executes on button press in baza_push.
function baza_push_Callback(hObject, eventdata, handles)
 
    handles = guidata(hObject);
    nazwa = handles.nazwa;
    fls = readfis(nazwa);
    Baza_regul(nazwa);



% --- Executes on button press in wyj_push.
function wyj_push_Callback(hObject, eventdata, handles)
    handles = guidata(hObject);
    nazwa = handles.nazwa;
    fls = readfis(nazwa);
    Wej_ed(nazwa);



% --- Executes on button press in podg_push.
function podg_push_Callback(hObject, eventdata, handles)
    handles = guidata(hObject);
    nazwa = handles.nazwa;
     fls = readfis(nazwa);
    Pod_reg(nazwa);



% --- Executes on button press in surf_push.
function surf_push_Callback(hObject, eventdata, handles)
    handles = guidata(hObject);
    nazwa = handles.nazwa;
     fls = readfis(nazwa);
    Surf(nazwa);


% --------------------------------------------------------------------


% --------------------------------------------------------------------
function defuz_dodaj_Callback(hObject, eventdata, handles)
        handles = guidata(hObject);
        nazwa = handles.nazwa;
        fls = readfis(nazwa);
        writefis(fls,nazwa);
        Dodawanie_funkcji(nazwa);


% --- Executes on button press in general_ed.
function general_ed_Callback(hObject, eventdata, handles)
        handles = guidata(hObject);
        nazwa = handles.nazwa;
        fls = readfis(nazwa);
        writefis(fls,nazwa);
        %assignin('base','zslices',handles.zslices);         
        General_ed(nazwa);   



% --- Executes on button press in general_on.
function general_on_Callback(hObject, eventdata, handles)
        handles = guidata(hObject);
        nazwa = handles.nazwa;
        fls = readfis(nazwa);
        writefis(fls,nazwa);
        handles.zslices = evalin('base','zslices'); 
        fls.general = get(handles.general_on,'Value');
        if fls.general == 1
            if handles.zslices == 0
            set(handles.general_ed,'Enable','On');
            set(handles.general_ed,'FontWeight','bold'); 
            handles.zslices = 3;
            assignin('base','zslices',handles.zslices);
            end
        else
            set(handles.general_ed,'Enable','Off');   
            set(handles.general_ed,'FontWeight','normal');
            handles.zslices = 0;
            assignin('base','zslices',handles.zslices);
        end
         guidata(hObject,handles);
         


% --- Executes during object creation, after setting all properties.
function glowne_CreateFcn(hObject, eventdata, handles)
% hObject    handle to glowne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in popupmenu10.
function popupmenu10_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu10 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu10


% --- Executes during object creation, after setting all properties.
function popupmenu10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

list = dir('metody_redukcji');
names = {list.name};
names = names(3:end);
clear list;

set(hObject, 'String', names);

handles.names = names;
guidata(hObject, handles);


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index = get(handles.popupmenu10, 'Value');
list = handles.names;
name = list{index};

copyfile(strcat('metody_redukcji\', name), 'Operacje\adapt.m');
